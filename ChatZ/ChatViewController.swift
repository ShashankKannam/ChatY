//
//  ChatViewController.swift
//  ChatZ
//
//  Created by IOS Course Project on 12/4/16.
//  Copyright © 2016 IOS Course Projectvb. All rights reserved.
//

import UIKit
import Photos
import Firebase
//cocoapods chat view
import JSQMessagesViewController

final class ChatViewController: JSQMessagesViewController {

    // : Properties
    
    var translatedText:String = ""
    
    private let imageURLNotSetKey = "NOTSET"
    
    var selectedUser:User!
    
    var selectedGroup:GroupContacts!
    
    var inChatGroup: GroupContacts!
    
    var inChatUser: User!
    
    var channelRef: FIRDatabaseReference?
    
    private lazy var messageRef: FIRDatabaseReference = DataService.instance.mainRef.child("messages")
    fileprivate lazy var storageRef: FIRStorageReference = DataService.instance.mainStorageRef
    private lazy var userIsTypingRef: FIRDatabaseReference = self.channelRef!.child("typingIndicator").child(self.senderId)
    private lazy var usersTypingQuery: FIRDatabaseQuery = self.channelRef!.child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)
    
    private var newMessageRefHandle: FIRDatabaseHandle?
    private var updatedMessageRefHandle: FIRDatabaseHandle?
    
    private var messages: [JSQMessage] = []
    private var photoMessageMap = [String: JSQPhotoMediaItem]()
    
    private var localTyping = false
    
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    var languageTitle:String = "Hindi"
    var languageCode = ["English":"en","Japanese":"ja", "French":"fr", "Hindi":"hi", "Telugu":"te","Chinese":"zh","Russian":"ru"]
    
    var group: Group? {
        didSet {
            title = group?.groupName
        }
    }
    
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
            userIsTypingRef.setValue(newValue)
        }
    }
    
    // MARK: View Lifecycle
    
  override func viewDidLoad() {
    
    super.viewDidLoad()

     getCurrentUser()
    
    inChatGroup = GroupContacts(groupName: selectedNGroup.groupName, date: selectedNGroup.date, conversionLanguage: selectedNGroup.conversionLanguage, groupURL: selectedNGroup.groupURL)
    
    inChatUser = User(uid: selectedNUser.uid, firstName: selectedNUser.firstName, profilePic: selectedNUser.profilePicURL)
    //\(selectedGroup.conversionLanguage)
    
    print("details of the selected group is \(inChatGroup.conversionLanguage)")
    
    //self.senderId = FIRAuth.auth()?.currentUser?.uid
    
    observeMessages()

    // No avatars
    collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
    collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
   }
    
   
    // dismiss view
    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // getcurrent user details
    func getCurrentUser(){
        self.senderId = "A"
        self.senderDisplayName = "A"
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        // dataservice instance
        DataService.instance.usersRef.child(uid).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            if let dict = snapshot.value as? Dictionary<String, AnyObject> {
                if let profile = dict["profile"] as? Dictionary<String, AnyObject> {
                    if let firstName = profile["firstName"] as? String {
                        if let profileUrl = dict["profilePicURL"] as? Dictionary<String, AnyObject> {
                            if (profileUrl["profilePicURL"] as? String) != nil {
                                self.senderId = uid
                                self.senderDisplayName = firstName
                            }
                        }
                    }
                }
            }
        }
    }

    
   // observe typing
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observeTyping()
    }
    
    deinit {
        if let refHandle = newMessageRefHandle {
            messageRef.removeObserver(withHandle: refHandle)
        }
        if let refHandle = updatedMessageRefHandle {
            messageRef.removeObserver(withHandle: refHandle)
        }
    }
    
    // Collection view data source (and related) methods
    
    //message data
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    //number of items(messages)
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    // bubbleview foe message data
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    //cell for message customized
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        if message.senderId == senderId { // 1
            cell.textView?.textColor = UIColor.white // 2
        } else {
            cell.textView?.textColor = UIColor.black // 3
        }
        return cell
    }
    
    //avatar - image
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    // height of collection view
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 15
    }
    
    // text attributed with name
    override func collectionView(_ collectionView: JSQMessagesCollectionView?, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString? {
        let message = messages[indexPath.item]
        switch message.senderId {
        case senderId:
            return nil
        default:
            guard let senderDisplayName = message.senderDisplayName else {
                assertionFailure()
                return nil
            }
            return NSAttributedString(string: senderDisplayName)
        }
    }
    
    
    // Firebase related methods
    
  private func observeMessages() {
        let a = inChatGroup.groupName
        messageRef = DataService.instance.mainRef.child("groups").child("\(a)").child("messages")
        let messageQuery = messageRef.queryLimited(toLast:25)
        // We can use the observe method to listen for new
        // messages being written to the Firebase DB
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            let messageData = snapshot.value as! Dictionary<String, String>
            
            if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0 {
                self.addMessage(withId: id, name: name, text: text)
                self.finishReceivingMessage()
            } else if let id = messageData["senderId"] as String!, let photoURL = messageData["photoURL"] as String! {
                if let mediaItem = JSQPhotoMediaItem(maskAsOutgoing: id == self.senderId) {
                    self.addPhotoMessage(withId: id, key: snapshot.key, mediaItem: mediaItem)
                    
                    if photoURL.hasPrefix("gs://") {
                        self.fetchImageDataAtURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: nil)
                    }
                }
            } else {
                print("Error! Could not decode message data")
            }
        })
        
        // We can also use the observer method to listen for
        // changes to existing messages.
        // We use this to be notified when a photo has been stored
        // to the Firebase Storage, so we can update the message data
        updatedMessageRefHandle = messageRef.observe(.childChanged, with: { (snapshot) in
            let key = snapshot.key
            let messageData = snapshot.value as! Dictionary<String, String>
            
            if let photoURL = messageData["photoURL"] as String! {
                // The photo has been updated.
                if let mediaItem = self.photoMessageMap[key] {
                    self.fetchImageDataAtURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: key)
                }
            }
        })
    }
    
    // fetch image data
  private func fetchImageDataAtURL(_ photoURL: String, forMediaItem mediaItem: JSQPhotoMediaItem, clearsPhotoMessageMapOnSuccessForKey key: String?) {
    let storageRef = FIRStorage.storage().reference(forURL: photoURL)
    storageRef.data(withMaxSize: INT64_MAX){ (data, error) in
        if let error = error {
            print("Error downloading image data: \(error)")
            return
        }
        storageRef.metadata(completion: { (metadata, metadataErr) in
            if let error = metadataErr {
                print("Error downloading metadata: \(error)")
                return
            }
            if (metadata?.contentType == "image/gif") {
               // mediaItem.image = UIImage.gifWithData(data!)
            } else {
                mediaItem.image = UIImage.init(data: data!)
            }
            self.collectionView.reloadData()
            
            guard key != nil else {
                return
            }
            self.photoMessageMap.removeValue(forKey: key!)
        })
    }
   }
   
    
  // observe typing the data
  private func observeTyping() {
    let a = inChatGroup.groupName
    let typingIndicatorRef = DataService.instance.mainRef.child("groups").child("\(a)").child("typingIndicator")
    userIsTypingRef = typingIndicatorRef.child(senderId)
    userIsTypingRef.onDisconnectRemoveValue()
    usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqual(toValue: true)
    usersTypingQuery.observe(.value) { (data: FIRDataSnapshot) in
        // You're the only typing, don't show the indicator
        if data.childrenCount == 1 && self.isTyping {
            return
        }
        // Are there others typing?
        self.showTypingIndicator = data.childrenCount > 0
        self.scrollToBottom(animated: true)
    }
   }
  
    
  // send the message
  override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
   convert(textS: text, completed:
    {
        // 1
        let itemRef = messageRef.childByAutoId()
        
       // text = translatedText
        // 2
        let messageItem = [
            "senderId": senderId!,
            "senderName": senderDisplayName!,
            "text": self.translatedText,
            ]
        // 3
        itemRef.setValue(messageItem)
        // 4
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        // 5

    })
    finishSendingMessage(animated: true)
    isTyping = false

  }

    
    //convereted text from yandex
    func convert(textS:String, completed: completionE){
       // let lang = languageCode["\(selectedGroup.conversionLanguage)"]
        let encodedString = textS.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        var code:String = ""
        code = languageCode["\(inChatGroup.conversionLanguage)"]!
        
       // urlString	String	"https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20160316T201633Z.3edd97cd482f5f99.44412180dddb0c1a07bd7ab38d4a746421932f28&text=Hi&lang=en-Optional(\"te\")"

       let  urlString = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20160316T201633Z.3edd97cd482f5f99.44412180dddb0c1a07bd7ab38d4a746421932f28&text=\(encodedString)&lang=en-\(code)"
        
        var request = URLRequest(url: URL(string: urlString)!)
        
        let session = URLSession.shared
        
        // print(token)
        request.httpMethod = "GET"
        
        //urlString	String	"https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20160316T201633Z.3edd97cd482f5f99.44412180dddb0c1a07bd7ab38d4a746421932f28&text=Optional(\"Hi\")&lang=en-Optional(\"te\")"
        // print(request)
        
        //data tesk
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                     print(" here ......josn ...\(json)")
                    if let jsonF = json as? Dictionary<String, Any>{
                        let translatedStringArray:[Any] = jsonF["text"] as! [String] as [Any]
                        self.translatedText = translatedStringArray[0] as! String
                        print(" here ......josn ...\(translatedStringArray)")
                        print(" here ......josn ...\(self.translatedText)")

                    }
                    }
                catch {
                    print("Error with Json: \(error)")
                }
                
            }
            else{
                print("error\(statusCode)")
            }
        }
        
        task.resume()
        completed()
    }
    
    
    //send photos messages
    func sendPhotoMessage() -> String? {
        let itemRef = messageRef.childByAutoId()
        let messageItem = [
            "photoURL": imageURLNotSetKey,
            "senderId": senderId!,
            ]
        
        itemRef.setValue(messageItem)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
        return itemRef.key
    }
    
    //image url
    func setImageURL(_ url: String, forPhotoMessageWithKey key: String) {
        let itemRef = messageRef.child(key)
        itemRef.updateChildValues(["photoURL": url])
    }
    
    // UI and User Interaction
    
    // outgoing view
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    // incoming view
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    // accesory button pressed
    override func didPressAccessoryButton(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            picker.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        present(picker, animated: true, completion:nil)
    }
    
    // add message
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    // add photo message
    private func addPhotoMessage(withId id: String, key: String, mediaItem: JSQPhotoMediaItem) {
        if let message = JSQMessage(senderId: id, displayName: "", media: mediaItem) {
            messages.append(message)
            
            if (mediaItem.image == nil) {
                photoMessageMap[key] = mediaItem
            }
            
            collectionView.reloadData()
        }
    }
    
    //UITextViewDelegate methods
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        isTyping = textView.text != ""
    }
  }

 //Image Picker Delegate
 extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion:nil)
        
        // 1
        if let photoReferenceUrl = info[UIImagePickerControllerReferenceURL] as? URL {
            // Handle picking a Photo from the Photo Library
            // 2
            let assets = PHAsset.fetchAssets(withALAssetURLs: [photoReferenceUrl], options: nil)
            let asset = assets.firstObject
            
            // 3
            if let key = sendPhotoMessage() {
                // 4
                asset?.requestContentEditingInput(with: nil, completionHandler: { (contentEditingInput, info) in
                    let imageFileURL = contentEditingInput?.fullSizeImageURL
                    
                    // 5
                    let path = "\(FIRAuth.auth()?.currentUser?.uid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000))/\(photoReferenceUrl.lastPathComponent)"
                    
                    // 6
                    self.storageRef.child(path).putFile(imageFileURL!, metadata: nil) { (metadata, error) in
                        if let error = error {
                            print("Error uploading photo: \(error.localizedDescription)")
                            return
                        }
                        // 7
                        self.setImageURL(self.storageRef.child((metadata?.path)!).description, forPhotoMessageWithKey: key)
                    }
                })
            }
        } else {
            // Handle picking a Photo from the Camera - TODO
        }
    }
    
    // cancel picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
}




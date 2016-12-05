//
//  ChatViewController.swift
//  ChatZ
//
//  Created by IOS Course Project on 12/4/16.
//  Copyright © 2016 IOS Course Projectvb. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

typealias done = () -> ()

class ChatViewController: JSQMessagesViewController {
    
    var nextNumber = "1";
    
    var currentUser:ChatUser!

    var selectedUser:User!
    
    var reverseMessages = [JSQMessage]()
    
    var messages = [JSQMessage]()
    var tempMessages = [JSQMessage]()
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    

    //

    func getPreviousChat(completed: done){
  
        DataService.instance.chatRef.observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
              // print("in here......and not in messages....\(snapshot.value)")
            
            if let messagesk = snapshot.value as? Dictionary<String, AnyObject>{
                 // print("in here.........at msgs.\(messagesk)")
                  let num = messagesk.count + 1
                   self.nextNumber = "\(num)"
                   print("in here..........\(self.nextNumber)......= \(num)")
                
                for (_, valueK) in messagesk{
                    
                    if let single = valueK as? Dictionary<String, String>{
                        print("here details as")
                       // print(single["message"])
                        
                        self.didPressSend(UIButton(), withMessageText: single["message"], senderId: single["senderID"], senderDisplayName: single["senderName"], date: Date())
                        
                        self.messages.append(JSQMessage(senderId: single["senderID"], displayName: single["senderName"], text: single["message"]))
                        
                    }
                }
         
        }
        }
        messages.reversed()
        //finishReceivingMessage(animated: true)
        completed()
   }

    
    
    
    func getCurrentUser(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
     
        DataService.instance.usersRef.child(uid).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
           // print(snapshot.value)
            
            
            
            
            if let dict = snapshot.value as? Dictionary<String, AnyObject> {
                if let profile = dict["profile"] as? Dictionary<String, AnyObject> {
                    if let firstName = profile["firstName"] as? String {
                        self.currentUser = ChatUser(uid: uid, firstName: firstName)
                        self.senderId = uid
                        self.senderDisplayName = firstName

                    }
                }
            }
        }
                }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messages = [JSQMessage]()
        reverseMessages = [JSQMessage]()
      //  downloadMessages()
        //self.navigationItem.title = selectedUser.firstName
        self.senderId = "2"
        self.senderDisplayName = "govind"
        getCurrentUser()
       //collectionView.reloadData()
        getPreviousChat { 
          // downloads data
        }
        // collectionView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    

    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {

        DataService.instance.sendMyMessgae(chatNumber: "\(nextNumber)A", senderID: senderId, senderName: senderDisplayName, message: text)
            //finishSendingMessage(animated: true)
        collectionView.reloadData()
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
       // getPreviousChat {
            
        //}
        
    }

    
//    override func viewWillAppear(_ animated: Bool) {
//        messages = [JSQMessage]()
//        getPreviousChat {
//            collectionView.reloadData()
//        }
//    }
//    
    
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        //
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
            cell.cellBottomLabel.text = message.senderDisplayName
        } else {
            cell.textView?.textColor = UIColor.black
            cell.messageBubbleTopLabel.text = message.senderDisplayName
        }
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    

     func collectionView(collectionView: JSQMessagesCollectionView?, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
            return NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    
    
     func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 13 //or what ever height you want to give
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

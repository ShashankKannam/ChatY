//
//  RegisterGroupViewController.swift
//  ChatZ
//
//  Created by IOS Course Project on 12/5/16.
//  Copyright © 2016 IOS Course Projectvb. All rights reserved.
//

import UIKit
import Firebase

typealias completionE =  () -> ()

class RegisterGroupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

   var groupProfileImageUrl = ""
    
    var languageSelectted:String = ""
    
   var languageCode = ["English":"en","Japanese":"ja", "French":"fr", "Hindi":"hi", "Telugu":"te","Chinese":"zh","Russian":"ru"]
   
    var languages = [String]()
    
    @IBOutlet weak var languageButtuon: UIButton!
    
    
    @IBOutlet weak var languagePicker: UIPickerView!
    
    
    
    @IBOutlet weak var imageProfile: UIImageView!
    
    var dateSelected: String = ""
    
    var group:Group!
    
    @IBOutlet weak var groupName: UITextField!
    
    
    @IBOutlet weak var datePIcker: UIDatePicker!
    

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var toGetDateBtn: UIButton!
    
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBAction func selectDate(_ sender: UIButton) {
        groupName.isHidden = true
        toGetDateBtn.isHidden = true
        datePIcker.isHidden = false
        continueButton.isHidden = false
        createButton.isHidden = true
        languageButtuon.isHidden = true
    }
    
    
    @IBAction func selectLanguage(_ sender: UIButton) {
        groupName.isHidden = true
        toGetDateBtn.isHidden = true
        datePIcker.isHidden = true
        continueButton.isHidden = true
        createButton.isHidden = true
        languagePicker.isHidden = false
       languageButtuon.isHidden = true
        nextBtn.isHidden = false
        
    }
  
    @IBAction func nextPressed(_ sender: UIButton) {
        
        groupName.isHidden = false
        toGetDateBtn.isHidden = false
        datePIcker.isHidden = true
        continueButton.isHidden = true
        createButton.isHidden = false
        languagePicker.isHidden = true
        languageButtuon.isHidden = false
        nextBtn.isHidden = true
        
    }
  
    

    @IBAction func continuePressed(_ sender: UIButton) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = datePIcker.calendar
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        dateSelected = dateFormatter.string(from: datePIcker.date)
        print("dates ------------ s & n")
        print(dateSelected)
        print(Date())
        createButton.isHidden = false
        toGetDateBtn.isHidden = false
        groupName.isHidden = false
        datePIcker.isHidden = true
        continueButton.isHidden = true
        languageButtuon.isHidden = false
        
        
        toGetDateBtn.setTitle(dateSelected, for: UIControlState.normal)

    }
   
    @IBOutlet weak var createButton: UIButton!
    
    @IBAction func createPressed(_ sender: UIButton) {
        
        group = Group(groupName: groupName.text!, date: dateSelected, conversionLanguage: languageSelectted)
        print(group.date)
        print(group.groupName)
        
        
            let newChannelRef = DataService.instance.mainRef.childByAutoId()
            let channelItem = [
                "name": group.groupName
            ]
            newChannelRef.setValue(channelItem)
       

        
        self.uploadImage {
            DataService.instance.saveGroupChat(groupName: group.groupName, chatNumber: "1\(group.groupName)", senderID: "ChatZ", senderName: "Team ChatZ", message: "Welcome to \(group.groupName)!!")
            DataService.instance.saveUserImage(group.groupName, profilePicURL: groupProfileImageUrl)
        }
        
        
        
        
        // Successfully registered
        let alert = UIAlertController(title: "Successfully registered your group!", message: "Click 'OK' to chat", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePIcker.isHidden = true
        continueButton.isHidden = true
        languagePicker.delegate=self
        
        languagePicker.dataSource=self
        
        languagePicker.isHidden = true
        nextBtn.isHidden = true
        
        for(key, value) in languageCode{
            languages.append(key)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
    //image
    
    let picker = UIImagePickerController()
    
    @IBAction func changeImage(_ sender: UIButton) {
        
        
        // Action Sheet
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        // Action to openCamera()
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        
        // Action to openGallary()
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        
        // Action to cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        
        // Adding all the actions
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // Opens Camera
    func openCamera(){
        // Assigning picker delegate so it works only for camera by this method
        picker.delegate=self
        // Checks if it has Camera
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            // Assigns picker sourceType to Camera
            picker.sourceType = UIImagePickerControllerSourceType.camera
            // Presenting picker view
            self.present(picker, animated: true, completion: nil)
        }
        else{
            // No Camera Warning Alert
            let alertC:UIAlertController = UIAlertController(title: "Sorry!",message: "You don't have camera", preferredStyle: UIAlertControllerStyle.alert)
            
            alertC.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler:{(action:UIAlertAction)->Void in }))
            
            self.present(alertC, animated: true, completion: nil)
            
        }
    }
    
    
    // Opens photoLibrary
    func openGallary(){
        // Assigning picker delegate so it works only for picking from photoLibrary by this method
        picker.delegate = self
        // Assigns picker sourceType to Camera and can't be edited
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = false
        // Presenting picker view
        self.present(picker, animated: true, completion: nil)
    }
    
    // did Finish Picking Media With Info
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageProfile.image = img
        }
        else
        {
            print("Something went wrong while picking image")
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    func uploadImage(completed: completionE){
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let storageRef = DataService.instance.groupImagesStorageRef.child("\(uid)\(groupName.text)")
        
        if let uploadData = UIImagePNGRepresentation(imageProfile.image!){
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                
                if let groupProfileImageUrl = metadata?.downloadURL()?.absoluteString {
                    DataService.instance.saveGroupImage(self.groupName.text!, groupPicURL: groupProfileImageUrl)
                }
            })
        }
        
         completed()
    }
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
   
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        languageButtuon.isHidden = false
        languageSelectted = languages[row]
        languageButtuon.setTitle(languageSelectted, for: .normal)
        
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

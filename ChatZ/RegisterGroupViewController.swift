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
    // register the groups
    @IBOutlet weak var languageButtuon: UIButton!
    
    @IBOutlet weak var languagePicker: UIPickerView!
    
    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var groupName: UITextField!
    
    @IBOutlet weak var datePIcker: UIDatePicker!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var toGetDateBtn: UIButton!
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var createButton: UIButton!
    
    var groupProfileImageUrl = ""
    
    var languageSelectted:String = ""
    
    var languageCode = ["English":"en","Japanese":"ja", "French":"fr", "Hindi":"hi", "Telugu":"te","Chinese":"zh","Russian":"ru"]
    
    var languages = [String]()
    
    var dateSelected: String = ""
    
    var group:Group!
    
    //image picker
    let picker = UIImagePickerController()
 
    // dissmiss the view
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // select date
    @IBAction func selectDate(_ sender: UIButton) {
        groupName.isHidden = true
        toGetDateBtn.isHidden = true
        datePIcker.isHidden = false
        continueButton.isHidden = false
        createButton.isHidden = true
        languageButtuon.isHidden = true
    }
    
   // select language
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
  
    // next pressed
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
  
    // continue pressed
    @IBAction func continuePressed(_ sender: UIButton) {
       // date to get
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
    
    // create pressed
    @IBAction func createPressed(_ sender: UIButton) {
        // model group instance
        group = Group(groupName: groupName.text!, date: dateSelected, conversionLanguage: languageSelectted)
        print(group.date)
        print(group.groupName)
        // in firebase database
        let newChannelRef = DataService.instance.mainRef.child("groups").childByAutoId()
        let channelItem = [
            "name": group.groupName,
            "roupUpTo": group.date,
            "groupLang": group.conversionLanguage,
            ]
        newChannelRef.setValue(channelItem)
        
        // upload image
        self.uploadImage(completed: {
            // Successfully registered
            let alert = UIAlertController(title: "Successfully registered your group!", message: "Click 'OK' to chat", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePIcker.isHidden = true
        continueButton.isHidden = true
        languagePicker.delegate=self
        languagePicker.dataSource=self
        languagePicker.isHidden = true
        nextBtn.isHidden = true
        
        for(key, _) in languageCode{
            languages.append(key)
        }
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // change default image
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
   
    
    // upload image to firebase
    func uploadImage(completed: completionE){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let storageRef = DataService.instance.groupImagesStorageRef.child("\(uid)\(groupName.text)")
        // png representation
        if let uploadData = UIImagePNGRepresentation(imageProfile.image!){
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                if let groupProfileImageUrl = metadata?.downloadURL()?.absoluteString {
                    DataService.instance.saveGroupImage(self.group.groupName, groupPicURL: groupProfileImageUrl)
                }
            })
        }
        // closure completed
         completed()
    }
    
    // number Of Components in picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
     // number Of rows in picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
     // title Of row in picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }
    
     // seleced row in picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        languageButtuon.isHidden = false
        languageSelectted = languages[row]
        languageButtuon.setTitle(languageSelectted, for: .normal)
    }
}

// extension to return keyboard
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

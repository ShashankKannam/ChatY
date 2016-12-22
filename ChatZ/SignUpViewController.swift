//
//  SignUpViewController.swift
//  ChatZ
//
//  Created by IOS Course Project on 12/3/16.
//  Copyright © 2016 IOS Course Projectvb. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   // signup class controller
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var firstNameTF: UITextField!
    
    @IBOutlet weak var lastNameTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    
    @IBOutlet weak var imageProfile: UIImageView!
    
    //image picker
    let picker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurEffect()
        self.hideKeyboardWhenTappedAround()
    }
   
    // blureffect to view
    func blurEffect(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView.addSubview(blurEffectView)
    }
    
    // dismiss the current view
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // register the user
    @IBAction func Register(_ sender: UIButton) {
    
        if let email = emailTF.text, let pass = passwordTF.text, let firstName = firstNameTF.text, let lastName = lastNameTF.text, (email.characters.count > 0 && pass.characters.count > 0 && firstName.characters.count > 0 && lastName.characters.count > 0) {
        
        //-------signup  the user with firebase signup
        AuthService.instance.signUP(email, password: pass, firstName: firstName, lastName: lastName, profilePic: imageProfile.image!, onComplete: { (errMsg, data) in
           
            guard errMsg == nil else {
                let alert = UIAlertController(title: "Error Authentication", message: errMsg?.description, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        //do stuff // Successfully registered
                let alert = UIAlertController(title: "Successfully registered!", message: "Click 'OK' to login", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
        })
        } else {
            // alert validation
            let alert = UIAlertController(title: "Details Required", message: "You must enter all details to register an account", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    
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
    
}

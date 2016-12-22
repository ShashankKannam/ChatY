//
//  LoginViewController.swift
//  ChatZ
//
//  Created by IOS Course Project on 12/3/16.
//  Copyright © 2016 IOS Course Projectvb. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseDatabase
import FirebaseAuth

class LoginViewController: UIViewController {
  // login view controller
    @IBOutlet weak var loggedUserImg: UIImageView!
    
    
    @IBOutlet weak var emailLBL: UITextField!
    
    @IBOutlet weak var passwordLBL: UITextField!
    
    
    var currentUser:User!
 
    // to get current user
    override func viewWillAppear(_ animated: Bool) {
        loggedUserImg.isHidden = true
         getCurrentUser()
    }
    
    
    override func viewDidLoad() {
        
        currentUser = User(uid: "", firstName: "", profilePic: "")
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        loggedUserImg.isHidden = true
         getCurrentUser()
    }
    
    //login and validations
    
    @IBAction func login(_ sender: UIButton) {
        
        if let email = emailLBL.text, let pass = passwordLBL.text, (email.characters.count > 0 && pass.characters.count > 0) {
         // authentication
            AuthService.instance.login(email, password: pass, onComplete: { (errMsg, data) in
                guard errMsg == nil else {
                      // authentication alert
                    let alert = UIAlertController(title: "Error Authentication", message: errMsg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                // successful alert
                let alert = UIAlertController(title: "Successfully LoggedIn!", message: "Click 'OK' to enjoy ChatX", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                    self.performSegue(withIdentifier: "ContactsVC", sender: nil)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            })
    
        } else {
            // validation alert
            let alert = UIAlertController(title: "Username and Password Required", message: "You must enter both a username and a password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    
// to download the image from a url
    func downloadImage(url: String) {
        let url = URL(string: url)!
        
      // asynchronous download
        DispatchQueue.global().async {
            do
            {
                let datax = try Data(contentsOf: url)
               // synchronous push to view
                DispatchQueue.global().sync {
                    self.loggedUserImg.image = UIImage(data:datax)
                }
            }
            catch let error as NSError{
                print(error.debugDescription)
            }
        }
        self.loggedUserImg.isHidden = false
        self.loggedUserImg.layer.cornerRadius = self.loggedUserImg.frame.size.height/2
        self.loggedUserImg.clipsToBounds = true
    }
    
    
    
 // to get logged user image
    func loggedUserImage(){
        if FIRAuth.auth()?.currentUser != nil {
            // User is signed in.
            // ...
            //let toDownloadUserData = CurrentUser.Current_User_Logged.currentUs    er.profilePicURL
            downloadImage(url: currentUser.profilePicURL)
        } else {
            // No user is signed in.
            // ...
            self.loggedUserImg.isHidden = true
        }
    }
   
    // to get current user
    func getCurrentUser(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        // download user data
    DataService.instance.usersRef.child(uid).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
        
        if let dict = snapshot.value as? Dictionary<String, AnyObject> {
            if let profile = dict["profile"] as? Dictionary<String, AnyObject> {
                if let firstName = profile["firstName"] as? String {
                    if let profileUrl = dict["profilePicURL"] as? Dictionary<String, AnyObject> {
                        if let proURL = profileUrl["profilePicURL"] as? String {
                            self.currentUser = User(uid: uid, firstName: firstName, profilePic: proURL)
                            MyVariables.me = User(uid: uid, firstName: firstName, profilePic: proURL)
                            if self.currentUser.profilePicURL.isEqual("") {
                                self.loggedUserImg.isHidden = true
                            }
                            else{
                               self.loggedUserImage()
                            }
                            
                        }
                    }
                }
            }
        }
    }
    }
}

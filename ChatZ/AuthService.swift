//
//  AuthService.swift
//  ChatZ
//
//  Created by IOS Course Project on 12/3/16.
//  Copyright © 2016 IOS Course Projectvb. All rights reserved.
//
//
//  AuthService.swift
//  ChatX
//
//  Created by IOS Course Project on 12/1/16.
//  Copyright © 2016 IOS Course Projectvb. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
//import FirebaseStorage


typealias Completion = (_ errMsg: String?, _ data: AnyObject?) -> Void

class AuthService {
    
    private static let _instance = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    func login(_ email: String, password: String, onComplete: Completion?){
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                    if errorCode == .errorCodeUserNotFound{
                        //Successfully logged in
                        print("Successfully logged in")
                        onComplete?(nil, user)
                        //}
                        
                    }
                }else {
                    //Handle all other errors
                    self.handleFirebaseError(error! as NSError, onComplete: onComplete)
                }
            } else {
                //Successfully logged in
                print("Successfully logged in")
                onComplete?(nil, user)
            }
            
        })
    }
    
    
    
    
    func signUP(_ email: String, password: String, firstName: String, lastName: String, profilePic:UIImage, onComplete: Completion?) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                    if errorCode == .errorCodeUserNotFound{
                        
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                self.handleFirebaseError(error! as NSError, onComplete: onComplete)
                            } else {
                                if user?.uid != nil {
                                    
                                    DataService.instance.saveUser(user!.uid, firstName: firstName, lastName: lastName)
                                    
                                    // profilePicUpload
                                    
                                    //-----
                                    let imageName = user!.uid.description
                                    
                                let storageRef = DataService.instance.imagesStorageRef.child("\(imageName).png")
                                    
                                    if let uploadData = UIImagePNGRepresentation(profilePic){
                                        storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                                            
                                            if error != nil {
                                                print(error.debugDescription)
                                                return
                                            }
                                            
                                            if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                                                DataService.instance.saveUserImage(user!.uid, profilePicURL: profileImageUrl)
                                            }
                                        })
                                    }
                                    
                                    //----

                                }
                            }
                            
                        })
                        
                        
                    }
                } else {
                    //Handle all other errors
                    self.handleFirebaseError(error! as NSError, onComplete: onComplete)
                }
            } else {
                //Successfully logged in
                print("Successfully logged in")
                
                //Sign in
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        self.handleFirebaseError(error! as NSError, onComplete: onComplete)
                    } else {
                        onComplete?(nil, user)
                    }
                    
                })
                
                onComplete?(nil, user)
            }
            
        })
    }
    
    
    func handleFirebaseError(_ error: NSError, onComplete: Completion?) {
        
        print(error.debugDescription)
        if let errorCode = FIRAuthErrorCode(rawValue: error.code) {
            switch (errorCode) {
            case .errorCodeInvalidEmail:
                onComplete?("Invalid email address", nil)
                break
            case .errorCodeWrongPassword:
                onComplete?("Invalid password", nil)
                break
            case .errorCodeEmailAlreadyInUse, .errorCodeAccountExistsWithDifferentCredential:
                onComplete?("Could not create account. Email already in use", nil)
                break
            default:
                onComplete?("There was a problem authenticating. Try again.", nil)
            }
        }
    }
}




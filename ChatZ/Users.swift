//
//  CurrentUser.swift
//  ChatZ
//
//  Created by IOS Course Project on 12/3/16.
//  Copyright © 2016 IOS Course Projectvb. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

// struct to make copies of users
struct MyVariables {
    static var me = User(uid: "", firstName: "", profilePic: "")
}

class Users{
  
    // current user
    private var _currentUser:User!
    // saved user
    public static var _savedUsersData = [UserData]()
    // logged user
    public static var current_User_Logged = Users()
    // logged users
    public static var current_Users = Users()
    
    // getters and setters
    var currentUser:User{
        set{
           // getCurrentUser()
             _currentUser = newValue
             }
        get{
            
            return _currentUser
        }
    }
    // users data getters and setters
    var savedUsersData:[UserData]{
        set{
            // getCurrentUser()
            Users._savedUsersData = newValue
        }
        get{
            
            return Users._savedUsersData
        }
    }
    
  // get current users
    func getCurrentUser(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        // To get cuurent logged users
        DataService.instance.usersRef.child(uid).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            if let dict = snapshot.value as? Dictionary<String, AnyObject> {
                        if let profile = dict["profile"] as? Dictionary<String, AnyObject> {
                            if let firstName = profile["firstName"] as? String {
                                if let profileUrl = dict["profilePicURL"] as? Dictionary<String, AnyObject> {
                                    if let proURL = profileUrl["profilePicURL"] as? String {
                                       self.currentUser = User(uid: uid, firstName: firstName, profilePic: proURL)
                                        
                                    }
                                }
                            }
                        }
                    }
                }
             }
      }

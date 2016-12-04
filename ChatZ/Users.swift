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

struct MyVariables {
    static var me = User(uid: "", firstName: "", profilePic: "")
}

class Users{
    
    private var _currentUser:User!
    
    public static var _savedUsersData = [UserData]()
    
    public static var Current_User_Logged = Users()
    
    public static var Current_Users = Users()
    
    var currentUser:User{
        set{
           // getCurrentUser()
             _currentUser = newValue
             }
        get{
            
            return _currentUser
        }
    }
    
    var savedUsersData:[UserData]{
        set{
            // getCurrentUser()
            Users._savedUsersData = newValue
        }
        get{
            
            return Users._savedUsersData
        }
    }
    
    
    func getCurrentUser(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
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

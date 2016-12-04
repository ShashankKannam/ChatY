//
//  DataService.swift
//  ChatZ
//
//  Created by IOS Course Project on 12/3/16.
//  Copyright © 2016 IOS Course Projectvb. All rights reserved.
//

//
//  DataService.swift
//  ChatX
//
//  Created by IOS Course Project on 12/1/16.
//  Copyright © 2016 IOS Course Projectvb. All rights reserved.
//

let FIR_CHILD_USERS = "users"

let FIR_CHILD_MESSAGES = "chat"

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
//import FirebaseAuth

class DataService {
    
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    //    var currentUserRef:FIRDatabaseReference{
    //        return usersRef.child((FIRAuth.auth()?.currentUser?.uid)!)
    //    }
    
    var mainRef:FIRDatabaseReference{
        return FIRDatabase.database().reference()
    }
    
    var usersRef: FIRDatabaseReference {
        return mainRef.child(FIR_CHILD_USERS)
    }
    
    
    var chatRef: FIRDatabaseReference {
        return mainRef.child(FIR_CHILD_MESSAGES)
    }
    
    var mainStorageRef: FIRStorageReference {
        return FIRStorage.storage().reference(forURL: "gs://chatz-a934e.appspot.com")
    }
    
    var imagesStorageRef: FIRStorageReference {
        return mainStorageRef.child("profile_images")
    }
    
    //    var videoStorageRef: FIRStorageReference {
    //        return mainStorageRef.child("videos")
    //    }
    
    func saveUser(_ uid: String, firstName: String, lastName:String) {
        let profile: Dictionary<String, AnyObject> = ["firstName": firstName as AnyObject, "lastName": lastName as AnyObject]
        mainRef.child(FIR_CHILD_USERS).child(uid).child("profile").setValue(profile)
    }
    
    func saveUserImage(_ uid: String, profilePicURL: String) {
        let profileImage: Dictionary<String, AnyObject> = ["profilePicURL": profilePicURL as AnyObject]
        mainRef.child(FIR_CHILD_USERS).child(uid).child("profilePicURL").setValue(profileImage)
    }
    
    
    //    func sendMediaPullRequest(senderUID: String, sendingTo:Dictionary<String, User>, mediaURL: URL, textSnippet: String? = nil) {
    //
    //        var uids = [String]()
    //        for uid in sendingTo.keys {
    //            uids.append(uid)
    //        }
    //
    //        let pr: Dictionary<String, AnyObject> = ["mediaURL":mediaURL.absoluteString as AnyObject, "userID":senderUID as AnyObject,"openCount": 0 as AnyObject, "recipients":uids as AnyObject]
    //
    //        mainRef.child("pullRequests").childByAutoId().setValue(pr)
    //        
    //    }
    
    
}

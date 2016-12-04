//
//  User.swift
//  ChatZ
//
//  Created by IOS Course Project on 12/3/16.
//  Copyright © 2016 IOS Course Projectvb. All rights reserved.
//
import Foundation

class User{
    
    private var _firstName:String!
    
    private var _uid:String!
    
    private var _profilePicURL:String!
    
    init(uid:String, firstName: String, profilePic: String) {
        _firstName = firstName
        _uid = uid
        _profilePicURL = profilePic
    }
    
    var profilePicURL:String{
        set{
            _profilePicURL = newValue
        }
        get{
            return _profilePicURL
        }
    }
    
    
    var firstName:String{
        set{
            _firstName = newValue
        }
        get{
            return _firstName
        }
    }
    
    var uid:String{
        set{
            _uid = newValue
        }
        get{
            return _uid
        }
    }
    
}

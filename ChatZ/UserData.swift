//
//  UsersData.swift
//  ChatZ
//
//  Created by IOS Course Project on 12/4/16.
//  Copyright © 2016 IOS Course Projectvb. All rights reserved.
//

import Foundation
import UIKit

class UserData{
    private var _firstName:String!
    
    private var _uid:String!
    
    private var _profilePic:UIImage!
    
    
    init(uid:String, firstName: String, profilePic: UIImage) {
        _firstName = firstName
        _uid = uid
        _profilePic = profilePic
    }
    
    var profilePic:UIImage{
        set{
            _profilePic = newValue
        }
        get{
            return _profilePic
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

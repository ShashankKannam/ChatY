//
//  ChatUser.swift
//  ChatZ
//
//  Created by IOS Course Project on 12/4/16.
//  Copyright © 2016 IOS Course Projectvb. All rights reserved.
//

import Foundation

class ChatUser{
  // chat data
    private var _firstName:String!
    private var _uid:String!
    // initializers
    init(uid:String, firstName: String) {
        _firstName = firstName
        _uid = uid
    }

    // getters and setters
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

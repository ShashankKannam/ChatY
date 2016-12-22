//
//  groupContacts.swift
//  ChatZ
//
//  Created by IOS Course Project on 12/6/16.
//  Copyright © 2016 IOS Course Projectvb. All rights reserved.
//

import Foundation

class GroupContacts{
// group contacts model class
    private var _groupName:String!
    
    private var _date:String!
    
    private var _conversionLanguage:String!
    
    private var _groupURL:String!
// initializers
    init(groupName: String, date: String, conversionLanguage:String, groupURL: String) {
        _groupName = groupName
        _date = date
        _conversionLanguage = conversionLanguage
        _groupURL = groupURL
    }
    
 // getters and setters for private variables
    var groupURL:String{
        set{
            _groupURL = newValue
        }
        get{
            return _groupURL
            
        }
    }
    
    var groupName:String{
        set{
            _groupName = newValue
        }
        get{
            return _groupName
            
        }
    }
    
    var date:String{
        set{
            _date = newValue
        }
        get{
            return _date
            
        }
    }
    
    var conversionLanguage:String{
        set{
            _conversionLanguage = newValue
        }
        get{
            return _conversionLanguage
            
        }
    }
}

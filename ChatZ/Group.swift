//
//  Group.swift
//  ChatZ
//
//  Created by IOS Course Project on 12/5/16.
//  Copyright © 2016 IOS Course Projectvb. All rights reserved.
//

import Foundation
// groups model class
class Group{
    
    private var _groupName:String!
    
    private var _date:String!
    
    private var _conversionLanguage:String!
    
    private var _groupID:String!
   
    // initializers
    init(groupName: String, date: String, conversionLanguage:String) {
        _groupName = groupName
        _date = date
        _conversionLanguage = conversionLanguage
    }
    
  // getters and setters to access private variables
    var groupID:String{
        set{
            _groupID = newValue
        }
        get{
            return _groupID
            
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

//
//  Group.swift
//  ChatZ
//
//  Created by IOS Course Project on 12/5/16.
//  Copyright © 2016 IOS Course Projectvb. All rights reserved.
//

import Foundation

class Group{
    
    private var _groupName:String!
    
    private var _date:String!
    
    init(groupName: String, date: String) {
        _groupName = groupName
        _date = date
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
}

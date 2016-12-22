//
//  UserCell.swift
//  ChatZ
//
//  Created by IOS Course Project on 12/3/16.
//  Copyright © 2016 IOS Course Projectvb. All rights reserved.
//

import UIKit
// custom table view cell
class UserCell: UITableViewCell {
        
    @IBOutlet weak var firstNameLBL: UILabel!
    
    @IBOutlet weak var contactImage: UIImageView!
    
        override func awakeFromNib() {
            super.awakeFromNib()
        }
    
 // for updating  the groups cell
    func updateGroup(group: GroupContacts){
        self.contactImage.layer.cornerRadius = self.contactImage.frame.size.height/2
        self.contactImage.clipsToBounds = true
        
        firstNameLBL.text = group.groupName
        
        let url = URL(string: group.groupURL)!
        
        
        // asynchronous download
        DispatchQueue.global().async {
            do
            {
                let datax = try Data(contentsOf: url)
               // synchronous display of view 
                DispatchQueue.global().sync {
                    
                    let image = UIImage(data:datax)
                    self.contactImage.image = image
                    
                    //Users._savedUsersData.append(UserData(uid: , firstName: user.firstName, profilePic: image!))
                }
                
            }
            catch let error as NSError{
                print(error.debugDescription)
            }
        }
    }
    
 // for updating  the user cell
    func updateUI(user: User)
    {
        self.contactImage.layer.cornerRadius = self.contactImage.frame.size.height/2
        self.contactImage.clipsToBounds = true
        
        firstNameLBL.text = user.firstName
        
        let url = URL(string: user.profilePicURL)!
        
      // asynchronous download
        DispatchQueue.global().async {
            do
            {
                let datax = try Data(contentsOf: url)
              // synchronous display of view
                DispatchQueue.global().sync {
                    
                    let image = UIImage(data:datax)
                    self.contactImage.image = image

                    Users._savedUsersData.append(UserData(uid: user.uid, firstName: user.firstName, profilePic: image!))
                }
                
            }
            catch let error as NSError{
                print(error.debugDescription)
            }
        }
        
}
}

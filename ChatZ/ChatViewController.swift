//
//  ChatViewController.swift
//  ChatZ
//
//  Created by IOS Course Project on 12/3/16.
//  Copyright © 2016 IOS Course Projectvb. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    var selectedUser:User!
    
    @IBOutlet weak var selctedUserImg: UIImageView!
    
    
    @IBOutlet weak var selectedUserName: UILabel!
    
    @IBOutlet weak var chatBoxTF: UITextField!
    
    
    @IBAction func back(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func sendText(_ sender: UIButton) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
         self.selectedUserName.text = selectedUser.firstName
        downloadImage()
        
        for a in Users._savedUsersData{
            if a.uid == selectedUser.uid{
                self.selctedUserImg.image = a.profilePic
                self.selctedUserImg.isHidden = false
                self.selctedUserImg.layer.cornerRadius = self.selctedUserImg.frame.size.height/2
                self.selctedUserImg.clipsToBounds = true

            }
        }
        
        //self.selctedUserImg.image = Users._savedUsersData[selectedUser]
        
        selctedUserImg.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        downloadImage()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func downloadImage() {
        
        let url = URL(string: selectedUser.profilePicURL)!
        
        
        DispatchQueue.global().async {
            do
            {
                let datax = try Data(contentsOf: url)
                
                DispatchQueue.global().sync {
                    self.selctedUserImg.image = UIImage(data:datax)
                    self.selctedUserImg.isHidden = false
                    self.selctedUserImg.layer.cornerRadius = self.selctedUserImg.frame.size.height/2
                    self.selctedUserImg.clipsToBounds = true
                }
            }
            catch let error as NSError{
                print(error.debugDescription)
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

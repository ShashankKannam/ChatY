//
//  ChatViewController.swift
//  ChatZ
//
//  Created by IOS Course Project on 12/3/16.
//  Copyright © 2016 IOS Course Projectvb. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var selectedUser:User!
    
    var me:User!
        
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    @IBOutlet weak var selctedUserImg: UIImageView!
    
    
    @IBOutlet weak var selectedUserName: UILabel!
    
    @IBOutlet weak var chatBoxTF: UITextField!
    
    
    @IBAction func back(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func sendText(_ sender: UIButton) {
        
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        me = MyVariables.me
 
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

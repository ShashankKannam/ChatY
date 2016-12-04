//
//  ContactsViewController.swift
//  ChatZ
//
//  Created by IOS Course Project on 12/3/16.
//  Copyright © 2016 IOS Course Projectvb. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    private var users = [User]()
    
  
    
    var selectedUser:User!
    
    var selectedUserData:UserData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        downloadUsers()
        // Do any additional setup after loading the view.
    }
    
    func downloadUsers(){
        
        DataService.instance.usersRef.observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            if let users = snapshot.value as? Dictionary<String, AnyObject> {
                for (key, value) in users {
                    if let dict = value as? Dictionary<String, AnyObject> {
                        if let profile = dict["profile"] as? Dictionary<String, AnyObject> {
                            if let firstName = profile["firstName"] as? String {
                                let uid = key
                                if let profileUrl = dict["profilePicURL"] as? Dictionary<String, AnyObject> {
                                 if let proURL = profileUrl["profilePicURL"] as? String {
                                let user = User(uid: uid, firstName: firstName, profilePic: proURL)
                                self.users.append(user)
                            }
                        }
                        
                    }
                }
            }
            }
            }
            self.tableView.reloadData()
            
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
                guard FIRAuth.auth()?.currentUser != nil else{
                    performSegue(withIdentifier: "LoginVC", sender: nil)
                   return
                }
    }
    

 
    @IBAction func loggedOut(_ sender: UIButton) {
        do{
            try FIRAuth.auth()?.signOut()
            dismiss(animated: true, completion: nil)
        }catch{
            print("Can't logout")
        }
        dismiss(animated: true, completion: nil)

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedUser = users[indexPath.row]
        performSegue(withIdentifier: "ChatVC", sender: selectedUser)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell{
            
            let user = users[indexPath.row]
            
            cell.updateUI(user: user)
            
            return cell
        }
        else{
            return UITableViewCell()
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatVC"{
            if let dest = segue.destination as? ChatViewController{
                if let present = sender as? User{
                    dest.selectedUser = present
                }
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

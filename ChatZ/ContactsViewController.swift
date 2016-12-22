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
// global variables default lets not crash the app incase
var selectedNUser = User(uid: "", firstName: "", profilePic: "")
var selectedNGroup = GroupContacts(groupName: "", date: "", conversionLanguage: "", groupURL: "")

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // users and searched users
    private var users = [User]()
    
    private var filteresUsers:[User]!
    
    // users and searched groups
    private var groups = [GroupContacts]()
    
    private var filteresgroups:[GroupContacts]!
    
    // to check searchmode
    var inSearchMode:Bool = false
    
    // to send data to next controller
    var selectedUser:User!
    
    var selectedGroup:GroupContacts!
    
    var selectedUserData:UserData!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        selectedUser = User(uid: "", firstName: "", profilePic: "")
        selectedGroup = GroupContacts(groupName: "", date: "", conversionLanguage: "", groupURL: "")
        filteresUsers = users
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
         searchBar.returnKeyType = UIReturnKeyType.done
        downloadUsers()
        downloadGroups()
        // Do any additional setup after loading the view.
    }
    
   // when segement controller is being tapped
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    
    // search in progress
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }

    //text changed in search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            inSearchMode = false
            tableView.reloadData()
            view.endEditing(true)
        }else{
            // with firstname ranges
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            if segmentedControl.selectedSegmentIndex == 0{
            filteresUsers = users.filter({($0.firstName.range(of: lower) != nil)})
            }
            else{
             filteresgroups = groups.filter({($0.groupName.range(of: lower) != nil)})
            }
            tableView.reloadData()
        }
    }
 

    
    override func viewDidAppear(_ animated: Bool) {
     // if logged out sends to login page
        guard FIRAuth.auth()?.currentUser != nil else{
            performSegue(withIdentifier: "LoginVC", sender: nil)
           return
        }
    }
    

 // logout users from app and firebase
    @IBAction func loggedOut(_ sender: UIButton) {
       //
        do{
            try FIRAuth.auth()?.signOut()
            dismiss(animated: true, completion: nil)
        }catch{
            print("Can't logout")
        }
        dismiss(animated: true, completion: nil)
    }
    
    
   // sections in table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    // rows in table view based on serach
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        if segmentedControl.selectedSegmentIndex == 0{
        if inSearchMode{
          return filteresUsers.count
      
        }else{
            
         return users.count
        }
        }else{
            if inSearchMode{
                return filteresgroups.count
                
            }else{
                
                return groups.count
            }

        }
       
    }
    
    
    // cell customized based on segement control
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell{
        
        if segmentedControl.selectedSegmentIndex == 0{
            if inSearchMode{
                let userF = filteresUsers[indexPath.row]
                cell.updateUI(user: userF)
            }else{
                
                let user = users[indexPath.row]
                
                cell.updateUI(user: user)
            }
            return cell
            
        } else{
            
            if inSearchMode{
                let groupF = filteresgroups[indexPath.row]
                cell.updateGroup(group: groupF)
            }else{
                
                let groupF = groups[indexPath.row]
                
                cell.updateGroup(group: groupF)
            }
            return cell
        }
        
    }
    else{
        return UITableViewCell()
    }
    
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // selected users or groups
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if segmentedControl.selectedSegmentIndex == 0{
        selectedNUser = User(uid: users[indexPath.row].uid, firstName: users[indexPath.row].firstName, profilePic: users[indexPath.row].profilePicURL)
        selectedUser.firstName = users[indexPath.row].firstName
        selectedUser.uid = users[indexPath.row].uid
        selectedUser.profilePicURL = users[indexPath.row].profilePicURL
        //performSegue(withIdentifier: "chatVC", sender: selectedUser)
       }else{
        selectedGroup = GroupContacts(groupName:  groups[indexPath.row].groupName, date:  groups[indexPath.row].date, conversionLanguage:  groups[indexPath.row].conversionLanguage, groupURL:  groups[indexPath.row].groupURL)
        selectedNGroup = GroupContacts(groupName:  groups[indexPath.row].groupName, date:  groups[indexPath.row].date, conversionLanguage:  groups[indexPath.row].conversionLanguage, groupURL:  groups[indexPath.row].groupURL)
        print(selectedGroup.conversionLanguage)
        //performSegue(withIdentifier: "chatVC", sender: selectedGroup)
        }
    }
    
  // download users data
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
  
    
  // download groups data
  func downloadGroups(){
    
   DataService.instance.mainRef.child("groups").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
    
    if let users = snapshot.value as? Dictionary<String, AnyObject> {
      for (_, value) in users {
       // print(key)
       // print(value)
        if let dict = value as? Dictionary<String, AnyObject> {
         print("here in \(value)")
           if let groupLang = dict["groupLang"] as? String {
            print("----------\(groupLang)")
               if let roupUpTo = dict["roupUpTo"] as? String {
                  print("----------\(roupUpTo)")
                    if let name = dict["name"] as? String {
                        print("----------\(name)")
                        if let picM = users["\(name)"] as? Dictionary<String, AnyObject>{
                            print("=================")
                            if let picURL = picM["groupPicURL"] as? String{
                                
                             let groupN = GroupContacts(groupName: name, date: roupUpTo, conversionLanguage: groupLang, groupURL: picURL)
                                
                                self.groups.append(groupN)
                            }
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

    //
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segmentedControl.selectedSegmentIndex == 0{
    //        if segue.identifier == "chatVC"{
    //            if let dest = segue.destination as? ChatViewController{
    //                if let present = sender as? User{
    //                    dest.selectedUser = present
    //                }
    //            }
    //        }
    //        }else{
    //            if segue.identifier == "chatVC"{
    //                if let dest = segue.destination as? ChatViewController{
    //                    if let present = sender as? GroupContacts{
    //                        dest.selectedGroup = present
    //                    }
    //                }
    //            }
    // 
    //        }
    //    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

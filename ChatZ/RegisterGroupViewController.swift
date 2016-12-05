//
//  RegisterGroupViewController.swift
//  ChatZ
//
//  Created by IOS Course Project on 12/5/16.
//  Copyright © 2016 IOS Course Projectvb. All rights reserved.
//

import UIKit

class RegisterGroupViewController: UIViewController {

    var dateSelected: String = ""
    
    var group:Group!
    
    @IBOutlet weak var groupName: UITextField!
    
    
    @IBOutlet weak var datePIcker: UIDatePicker!
    

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var toGetDateBtn: UIButton!
    
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBAction func selectDate(_ sender: UIButton) {
        groupName.isHidden = true
        toGetDateBtn.isHidden = true
        datePIcker.isHidden = false
        continueButton.isHidden = false
        createButton.isHidden = true
    }
    

    @IBAction func continuePressed(_ sender: UIButton) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = datePIcker.calendar
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        dateSelected = dateFormatter.string(from: datePIcker.date)
        print("dates ------------ s & n")
        print(dateSelected)
        print(Date())
        createButton.isHidden = false
        toGetDateBtn.isHidden = false
        groupName.isHidden = false
        datePIcker.isHidden = true
        continueButton.isHidden = true
        
        toGetDateBtn.setTitle(dateSelected, for: UIControlState.normal)

    }
   
    @IBOutlet weak var createButton: UIButton!
    
    @IBAction func createPressed(_ sender: UIButton) {
        
        group = Group(groupName: groupName.text!, date: dateSelected)
        print(group.date)
        print(group.groupName)
        
        DataService.instance.saveGroup(groupName: group.groupName, chatNumber: "1", senderID: "ChatZone", senderName: "ChatZone", message: "Welcome to \(group.groupName) club!!!")
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePIcker.isHidden = true
        continueButton.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

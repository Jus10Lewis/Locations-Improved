//
//  ChatVC.swift
//  MyLocations
//
//  Created by Justin Lewis on 6/20/19.
//  Copyright © 2019 Ray Wenderlich. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tbv: UITableView!
    
    var messageArray = [Message]()
    var names = [String]()
    let normalMessageFieldHeight = 70
    var avatarID = 1
    
    //    let messages = ["Hello",
    //                    "Yo!",
    //                    "I am Groot! \nI am Groot! \nI am Groot! \nI am Groot! \nI am Groot! \nI am Groot! \nI am Groot! \nI am Groot! \nI am Groot! \nI am Groot! \nI am Groot! \nI am Groot! \nI am Groot! \nI am Groot! \nI am Groot!",
    //                    "Hodor! Hodor! Hodor! Hodor! Hodor! Hodor! Hodor! Hodor! Hodor! Hodor! Hodor! Hodor! Hodor! "]
    
    //MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        messageTextField.delegate = self
        avatarID = UserDefaults.standard.integer(forKey: "avatarID")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        chatTableView.addGestureRecognizer(tapGesture)
        
        chatTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "CustomMessageCell")
        
        configureTableView()
        retrieveMessages()
        
        names.append("Dad")
        names.insert("Bob", at: 0)
        names[1] = "Mom"
        
    }
    
    //MARK: - Actions
    @IBAction func sendMessage(_ sender: UIButton) {
        messageTextField.endEditing(true)
        
        messageTextField.isEnabled = false
        sender.isEnabled = false
        
        let messageDB = Database.database().reference().child("Messages")
        
        let messageDict = ["Sender": Auth.auth().currentUser?.email,
                           "MessageBody": messageTextField.text]
        
        messageDB.childByAutoId().setValue(messageDict) {
            (error, reference) in
            if error != nil {
                print(error!)
            } else {
                print("Message saved succesfully")
                self.messageTextField.isEnabled = true
                sender.isEnabled = true
                self.messageTextField.text = ""
            }
        }
    }
    
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch {
            print("ERROR Signing Out")
        }
    }
    
    //MARK: - Tableview Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomMessageCell = tableView.dequeueReusableCell(withIdentifier: "CustomMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].senderName
        
        if cell.senderUsername.text == Auth.auth().currentUser!.email! as String {
            cell.messageBackground.backgroundColor = UIColor.flatBlue()
            cell.messageBody.textColor = UIColor.white
            cell.senderUsername.textColor = UIColor.lightGray
        }
        
        cell.avatarImageView.downloaded(from: "https://api.adorable.io/avatars/285/\(cell.senderUsername.text!).png")

        return cell
    }
    
    //MARK: - Helper Methods
    @objc func tableViewTapped() {
        messageTextField.endEditing(true)
    }
    
    func configureTableView() {
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.estimatedRowHeight = 120.0
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.27) {
            self.messageViewHeight.constant = CGFloat(263 + self.normalMessageFieldHeight)
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.27) {
            self.messageViewHeight.constant = CGFloat(self.normalMessageFieldHeight)
            self.view.layoutIfNeeded()
        }
    }
    
    func retrieveMessages() {
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let messageText = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            let messageObject = Message(senderName: sender, messageBody: messageText)
            self.messageArray.append(messageObject)
            self.tbv.reloadData()
            self.scrollToBottom()
        }
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messageArray.count-1, section: 0)
            self.tbv.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
    
    
}

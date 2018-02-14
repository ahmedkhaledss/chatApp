//
//  ChatViewController.swift
//  Chat
//
//  Created by Ahmed Khaled on 2/10/18.
//  Copyright © 2018 Ahmed Khaled. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var messageArray : [Message] = [Message]()
    
    @IBOutlet weak var messageTableView: UITableView!
    
    @IBOutlet weak var messageTextfield: UITextField!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sendButton: UIButton!
    
    
    @IBAction func sendPressed(_ sender: Any) {
        messageTextfield.endEditing(true)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesDB = Database.database().reference().child("Messages")
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageTextfield.text]
        messagesDB.childByAutoId().setValue(messageDictionary) {
            (error, ref) in
            if let saveError = error {
                print(saveError)
            }
            else {
                print("Message sent Successfully")
                self.messageTextfield.text = ""
            }
        }
        messageTextfield.isEnabled = true
        sendButton.isEnabled = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "avatar")
        if cell.senderUsername.text == Auth.auth().currentUser?.email {
            cell.messageBackground.backgroundColor = UIColor.init(red: 0, green: 0.4, blue: 0, alpha: 1)
            cell.avatarImageView.backgroundColor = UIColor.init(red: 0, green: 1, blue: 0, alpha : 0.6)
        }
        else {
            cell.messageBackground.backgroundColor = UIColor.init(red: 0.4, green: 0, blue: 0, alpha: 1)
            cell.avatarImageView.backgroundColor = UIColor.init(red: 1, green: 0, blue: 0, alpha : 0.6)
        }
        return cell
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        messageTextfield.delegate = self
        
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(endMessageEditing))
        messageTableView.addGestureRecognizer(tabGesture)
        retrieveMessages()
    }
    
    @IBAction func signoutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            guard (navigationController?.popToRootViewController(animated: true)) != nil
                else {
                    print("THIS IS THE ROOT VIEWCONTROLLER!!")
                    return
            }
        }
        catch {
            let alertController : UIAlertController = UIAlertController(title: "Alert", message: "There was a problem signing out", preferredStyle: .alert)
            let action : UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 322
            self.view.layoutIfNeeded()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 60
            self.view.layoutIfNeeded()
        }
    }
    

    func retrieveMessages() {
        let MessagesDB = Database.database().reference().child("Messages")
        MessagesDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary <String, String>
            let text = snapshotValue["MessageBody"]
            let sender = snapshotValue["Sender"]
            let message = Message()
            message.messageBody = text!
            message.sender = sender!
            self.messageArray.append(message)
            self.messageTableView.reloadData()
            self.scrollToBottom()
        }
    }
    
    @objc func endMessageEditing() {
    messageTextfield.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messageArray.count-1, section:0)
            self.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
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

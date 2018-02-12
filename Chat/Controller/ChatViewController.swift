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
    
    @IBOutlet weak var messageTableView: UITableView!
    
    @IBOutlet weak var messageTextfield: UITextField!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        let messageArray = ["first message", "second message", "third message"]
        cell.messageBody.text = messageArray[indexPath.row]
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
    

    @objc func endMessageEditing() {
    messageTextfield.endEditing(true)
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

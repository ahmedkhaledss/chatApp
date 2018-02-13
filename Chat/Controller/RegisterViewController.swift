//
//  RegisterViewController.swift
//  Chat
//
//  Created by Ahmed Khaled on 2/9/18.
//  Copyright © 2018 Ahmed Khaled. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Register"
    }

    @IBAction func registerPressed(_ sender: Any) {
        if let emailText = emailTextfield.text, !emailText.isEmpty, let passwordText = passwordTextfield.text, !passwordText.isEmpty {
            SVProgressHUD.show()
            Auth.auth().createUser(withEmail: emailText, password: passwordTextfield.text!) { (user, error) in
                if let registerError = error {
                    
                    SVProgressHUD.dismiss()
                    let alertController : UIAlertController = UIAlertController(title: "Error", message: registerError.localizedDescription, preferredStyle: .alert)
                    let action : UIAlertAction = UIAlertAction(title: "Got it", style: .default, handler: nil)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)

                }
                else {
                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "fromRegisterToChat", sender: self)
                }
                
            }
        }
        else {
            let alertController : UIAlertController = UIAlertController(title: "Missing Field", message: "Please enter email and password", preferredStyle: .alert)
            let action : UIAlertAction = UIAlertAction(title: "Got it", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }


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

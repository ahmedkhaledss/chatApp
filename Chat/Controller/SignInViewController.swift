//
//  SignInViewController.swift
//  Chat
//
//  Created by Ahmed Khaled on 2/9/18.
//  Copyright © 2018 Ahmed Khaled. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBAction func signinPressed(_ sender: Any) {

        if let emailText = emailTextfield.text, !emailText.isEmpty, let passwordText = passwordTextfield.text, !passwordText.isEmpty {
            SVProgressHUD.show()
            Auth.auth().signIn(withEmail: emailText, password: passwordText) { (user, error) in
                if let signInError = error {
                    SVProgressHUD.dismiss()
                    let alertController : UIAlertController = UIAlertController(title: "Error", message: signInError.localizedDescription, preferredStyle: .alert)
                    let action : UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }
                else {

                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "fromSigninToChat", sender: self)
                }
            }
        }
        else {
            let alertController : UIAlertController = UIAlertController(title: "Missing field", message: "Please, enter both email and password", preferredStyle: .alert)
            let action : UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.title = "Sign In"
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

//
//  LogInViewController.swift
//  iOS_App
//
//  Created by Ohad Brunner on 01/02/2018.
//  Copyright © 2018 Ohad Brunner. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func logInPressed(_ sender: UIButton) {
    
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            (user, error) in
            
            if error != nil {
                print(error!)
            }
            else{
                print("Login was Successful!")
                
                self.performSegue(withIdentifier: "goToMyList", sender: self)
            }
        }
 
    }
 
}

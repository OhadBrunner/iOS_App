//
//  RegisterViewController.swift
//  iOS_App
//
//  Created by Ohad Brunner on 01/02/2018.
//  Copyright © 2018 Ohad Brunner. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
       
        //TODO: Set up a new user on our Firbase database
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            (user, error) in
            
            if error != nil {
                print(error!)
            } else {
                //success
                print("Registration Successful!")
                
                self.performSegue(withIdentifier: "goToMyList", sender: self)
            }
        }
 
    }
    
 

}

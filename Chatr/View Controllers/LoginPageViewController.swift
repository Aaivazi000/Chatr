//
//  LoginPageViewController.swift
//  Chatr
//
//  Created by Andriana Aivazians on 10/28/18.
//  Copyright © 2018 Andriana Aivazians. All rights reserved.
//

import UIKit
import Parse

class LoginPageViewController: UIViewController {
    
    //UI Outlets & Variable Declarations
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var userAlertController = UIAlertController()
    
    // Action when user taps on view and keyboard closes
    @IBAction func onViewTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    // Action When user clicks Sign Up Button
    @IBAction func onSignUpTap(_ sender: Any) {
        
        //Call sign up function
        signupUser()
    }
    
    // Action when user clicks LogIn Button
    @IBAction func onLoginTap(_ sender: Any) {
        
        //Call login function
        loginUser()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // Functions Needed for View Controller BELOW
    
    func signupUser() {
        // Step 1: Initialize a new user
        let newUser = PFUser()
        
        // Step 2: Set User properties
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
        
        // Step 3: Call sign up function in background
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                
                if error._code == 202 {
                    //Alert the user that username is taken
                    self.userAlertController = UIAlertController(title: "Sign Up Error", message: "That username is taken. \n Please choose another.", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                        // do nothing to dismiss
                    }
                    self.userAlertController.addAction(cancelAction)
                    self.present(self.userAlertController, animated: true, completion: nil)
                }
                if (error._code == 200) || (error._code == 201) {
                    //Alert user that one of fields is missing
                    self.userAlertController = UIAlertController(title: "Sign Up Error", message: "One the text fields is empty. \n Please choose a username & password.", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                        // do nothing to dismiss
                    }
                    self.userAlertController.addAction(cancelAction)
                    self.present(self.userAlertController, animated: true, completion: nil)
                }
                else {
                    //Alert user that some other error happened
                    self.userAlertController = UIAlertController(title: "Sign Up Error", message: "Error message: \(error.localizedDescription)", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                        // do nothing to dismiss
                    }
                    self.userAlertController.addAction(cancelAction)
                    self.present(self.userAlertController, animated: true, completion: nil)
                }
            }
            else {
                // Alert User that they were signed up successfully
                self.userAlertController = UIAlertController(title: "Success", message: "Your account was created. \n Click Login to proceed.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                    // do nothing to dismiss
                }
                self.userAlertController.addAction(cancelAction)
                self.present(self.userAlertController, animated: true, completion: nil)
            }
        }
        
    }
    
    func loginUser() {
        
        //Step 1: set user fields to consts
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        // Step 2: Login user
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                //Alert User that something when wrong
                self.userAlertController = UIAlertController(title: "Login Error", message: "Error message: \(error.localizedDescription)", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                    // do nothing to dismiss
                }
                self.userAlertController.addAction(cancelAction)
                self.present(self.userAlertController, animated: true, completion: nil)
            
            } else {
                // display view controller that needs to shown after successful login
                //Segue to next view controller
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    

}

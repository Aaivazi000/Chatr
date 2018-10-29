//
//  ChatViewController.swift
//  Chatr
//
//  Created by Andriana Aivazians on 10/28/18.
//  Copyright © 2018 Andriana Aivazians. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController {

    //UI Outlets & variable declarations
    var chatAlertController = UIAlertController()
    
    // Action when user taps Sign Out button
    @IBAction func onsignoutTap(_ sender: Any) {
        
        //Call signout Function
        signOutUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // Functions Required for Chat View Controller
    
    func signOutUser () {
        
        PFUser.logOutInBackground { (error: Error?) in
            if let error = error {
                self.chatAlertController = UIAlertController(title: "Error", message: "Error message: \(error.localizedDescription)", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                    //do nothing to dismiss
                    })
                self.chatAlertController.addAction(cancelAction)
                self.present(self.chatAlertController, animated: true, completion: nil)
            }
            else {
                //Segue to Login Controller
                self.performSegue(withIdentifier: "signoutSegue", sender: nil)
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

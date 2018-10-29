//
//  ChatViewController.swift
//  Chatr
//
//  Created by Andriana Aivazians on 10/28/18.
//  Copyright © 2018 Andriana Aivazians. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    //UI Outlets & variable declarations
    var chatAlertController = UIAlertController()
    var messageAlertController = UIAlertController()
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    var messages: [PFObject] = []
    var currentUser = PFUser.current()
    var chatRefreshControl: UIRefreshControl!
    
    
    
    // Action when user taps Send Button
    @IBAction func onSendTap(_ sender: Any) {
        
        //Step 1: make instance of chat message
        let chatMessage = PFObject(className: "Message")
        
        // Step 2: Store the message & username of sender
        chatMessage["text"] = messageTextField.text ?? ""
        chatMessage["user"] = currentUser
        
        
        // Step 3: Save message to Parse server
        chatMessage.saveInBackground { (success, error) in
            if success == true {
                //Show alert that message was sent
                self.messageAlertController = UIAlertController(title: "Success", message: "Your message was sent!", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                    //do nothing to dismiss
                })
                self.messageAlertController.addAction(cancelAction)
                self.present(self.messageAlertController, animated: true, completion: nil)

                // Clear message text field
                self.messageTextField.text = ""
            }
            else if let error = error {
                self.messageAlertController = UIAlertController(title: "Message Error", message: "Error message: \(error.localizedDescription)", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                    //do nothing to dismiss
                })
                self.messageAlertController.addAction(cancelAction)
                self.present(self.messageAlertController, animated: true, completion: nil)
            }
        }
        
    }
    
    // Action when user taps Sign Out button
    @IBAction func onsignoutTap(_ sender: Any) {
        
        //Call signout Function
        signOutUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set table view properties
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.estimatedRowHeight = 107.5
        
        // For refresh control
        chatRefreshControl = UIRefreshControl()
        chatRefreshControl.tintColor = UIColor(red:0.22, green:0.30, blue:0.68, alpha:1.0)
        chatRefreshControl.addTarget(self, action: #selector(ChatViewController.didPulltoRefresh(_:)), for: .valueChanged)
        chatTableView.insertSubview(chatRefreshControl, at: 0)
        
        // Fetch Messages from parse server
        fetchMessages()
        
        // Refresh every 10 seconds
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.refreshchatTimer), userInfo: nil, repeats: true)
        
    }
    
    // function for refresh control
    @objc func didPulltoRefresh(_ refreshControl: UIRefreshControl) {
        fetchMessages()
    }
    
    // Functions required for table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        
        // Set Message cell UI elements to values
        cell.messageLabel.text = message["text"] as? String
        if let user = message["user"] as? PFUser {
            // Set username in UI element
            cell.usernameLabel.text = user.username
        }
        else {
            cell.usernameLabel.text = "🤖"
        }
        return cell
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
    
    @objc func refreshchatTimer () {
        
        //Run fetch Messsages function
        fetchMessages()
    }
    
    func fetchMessages () {
        
        let query = PFQuery(className: "Message")
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        
        //fetch data in background
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                //save messages from posts to messages array
                self.messages = posts
                self.chatTableView.reloadData()
                self.chatRefreshControl.endRefreshing()
            }
            else {
                print(error!.localizedDescription)
            }
        }
    }
    
    
    
}

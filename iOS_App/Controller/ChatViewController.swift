//
//  ChatViewController.swift
//  iOS_App
//
//  Created by Ohad Brunner on 05/02/2018.
//  Copyright © 2018 Ohad Brunner. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var messagesArray = [Message]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var MessageTableView: UITableView!
    @IBOutlet weak var MessageTextField: UITextField!
    @IBOutlet weak var AddButton: UIButton!
    @IBOutlet weak var CameraButton: UIButton!
    @IBOutlet weak var SendButton: UIButton!
    @IBOutlet weak var HeightConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MessageTableView.delegate = self
        MessageTableView.dataSource = self
        
        MessageTextField.delegate = self
        
        imagePicker.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        MessageTableView.addGestureRecognizer(tapGesture) // whenever the table view gets tapped anywhere, it's going to trigger the tap gesture which calls a method called tableViewTapped which calls a method called endEditing on our messageTextField, which in turn calls the method textFieldDidEndEditing and triggers it's animation.
        
        MessageTableView.register(UINib(nibName: "MyMessageCell", bundle: nil), forCellReuseIdentifier: "theMessageCell")
        
        configureTableView()
        
        retieveMessages()
        
        MessageTableView.separatorStyle = .none

    }
    
    //MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "theMessageCell", for: indexPath) as! MyMessageCell
        
        cell.MessageBody.text = messagesArray[indexPath.row].messageBody
        cell.SenderUserName.text = messagesArray[indexPath.row].sender
        cell.AvatarImageView.image = UIImage(named : "user")
        
        
        if cell.SenderUserName.text == Auth.auth().currentUser?.email as String! {
            //Messages we sent
            
            cell.AvatarImageView.backgroundColor = UIColor.clear
            cell.MessageBackground.backgroundColor = UIColor.flatPowderBlue()
        } else {
            
            cell.AvatarImageView.backgroundColor = UIColor.clear
            cell.MessageBackground.backgroundColor = UIColor.flatGray()
        }
        
        
        return cell
    }
    
    //TODO: Declare tableViewTapped here:
    
    @objc func tableViewTapped() {
        
        MessageTextField.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
    
    //this function helps us to get the cells resize depending on the content that we give it.
    func configureTableView() {
        
        MessageTableView.rowHeight = UITableViewAutomaticDimension
        MessageTableView.estimatedRowHeight = 120.0
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.2) { // the second parameter of this function is a closer and will give it the code that gets our textfield to the desire height with an animation
            
            self.HeightConstraint.constant = 325 // that way, our text field will be visible after the keyboard pops up
            self.view.layoutIfNeeded() // if something in the view has changed, redraw the all thing
        }
    }
        
        func textFieldDidEndEditing(_ textField: UITextField) { // this method gets called when the messeageTextFiels's method endEditing getting true
            
            UIView.animate(withDuration: 0.2) {
                
                self.HeightConstraint.constant = 53
                self.view.layoutIfNeeded() // if something in the view has changed, redraw the all thing
            }
        }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        MessageTextField.endEditing(true) // once the send button gets pressed we want the keyboard and the text field to go down
        
        MessageTextField.isEnabled = false //text fiels can't take any text until the current message is sent
        SendButton.isEnabled = false //this button is no longer clickable so we don't have duplicates of the same messages
        
        //TODO: Send the message to Firebase and save it in our database
        
        let messageDB = Database.database().reference().child("Messages") //a reference for our database in Firebase for the messages
        
        let messageDictionary = ["Sender" : Auth.auth().currentUser?.email, "MessageBody": MessageTextField.text!] //creating the current message details as a dictionary
        
        
        messageDB.childByAutoId().setValue(messageDictionary) { //we're saving our message dicionary inside our messages database under a random and unique key generated by childByAutoId. this key will go under our "Messages" database and under this key we'll have the message details in a form of a dictionary
            (error, reference) in
            
            if error != nil {
                print(error!)
                
            } else {
                print("Message saved successfuly!")
            }
            
            //make it possible for the user to write down new meassages
            self.MessageTextField.isEnabled = true
            self.SendButton.isEnabled = true
            self.MessageTextField.text = "" // clear the text field for new message
        }
    }
 
    func retieveMessages() {
        
        let messageDB = Database.database().reference().child("Messages") //a reference for our database in Firebase for the messages. we have to spell the name of the child exactly like it should otherwise it won't be able to get to our database
        
        messageDB.observe(.childAdded) { //when a new message added to our database we want to grab it inside the snapshot parameter
            (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String> //we know that the data we are grabbing from the database should be in a form of a dictionary so we can cast it and change the 'Any' type of the snapshot value
            
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            //let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: self.context) as! Message //saving to sql
            
            let message = Message(context: self.context)
            
            message.messageBody = text // the message body might be a picture!
            message.sender = sender
        
            self.messagesArray.append(message)
            
            self.saveMessage()
            
            self.configureTableView()
            self.MessageTableView.reloadData() //show the new message on the table view
        }
    }
    
    func saveMessage() {
        
        do {
            try context.save()
        } catch {
            print("Error saving message \(error)")
        }
        
        //MessageTableView.reloadData()
    }
    

    
    //MARK: - camera & photo library
    
    /*
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
        } else {
            print("There was an error picking the image")
        }
    }
    */
    
    @IBAction func cameraTapped(_ sender: UIButton) {
        
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false // true?
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
}

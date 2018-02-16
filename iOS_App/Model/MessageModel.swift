//
//  MessageModel.swift
//  iOS_App
//
//  Created by Ohad Brunner on 12/02/2018.
//  Copyright © 2018 Ohad Brunner. All rights reserved.
//


import Foundation
import UIKit
import Firebase

class MessageModel {
    
    //MARK: Properties
    var owner: MessageOwner
    var type: MessageType
    var content: Any
    var timestamp: Int
    var image: UIImage?
    var fromID: String
   
    
    
    //MARK: Methods

    
    func downloadImage(indexpathRow: Int, completion: @escaping (Bool, Int) -> Swift.Void)  {
        if self.type == .photo {
            let imageLink = self.content as! String
            let imageURL = URL.init(string: imageLink)
            URLSession.shared.dataTask(with: imageURL!, completionHandler: { (data, response, error) in
                if error == nil {
                    self.image = UIImage.init(data: data!)
                    completion(true, indexpathRow)
                }
            }).resume()
        }
    }

    class func send(message: MessageModel, completion: @escaping (Bool) -> Swift.Void)  {
   
         if let currentUserID = Auth.auth().currentUser?.uid {
            switch message.type {
            
            case .photo:
                let imageData = UIImageJPEGRepresentation((message.content as! UIImage), 0.5)
                let child = UUID().uuidString
                Storage.storage().reference().child("messagePics").child(child).putData(imageData!, metadata: nil, completion: { (metadata, error) in
                    if error == nil {
                        let path = metadata?.downloadURL()?.absoluteString
                        let values = ["type": "photo", "content": path!, "fromID": currentUserID, "timestamp": message.timestamp] as [String : Any]
                   
                        Database.database().reference().child("Messages").childByAutoId().setValue(values) {
                            (error, reference) in
                            
                            if error != nil {
                                print(error!)
                                
                            } else {
                                print("Message saved successfuly!")
                            }
                        }
                    }
                })
            case .text:
                let values = ["type": "text", "content": message.content, "fromID": currentUserID, "timestamp": message.timestamp]
             
                Database.database().reference().child("Messages").childByAutoId().setValue(values) {
                (error, reference) in
                    
                    if error != nil {
                        print(error!)
                        
                    } else {
                        print("Message saved successfuly!")
                    }
            }
            }
    }
    
    }


    //MARK: Inits
    init(type: MessageType, content: Any, owner: MessageOwner, fromID: String, timestamp: Int) {
        self.type = type
        self.content = content
        self.owner = owner
        self.timestamp = timestamp
        self.fromID = fromID
    }
}

//
//  UserModel.swift
//  iOS_App
//
//  Created by Ohad Brunner on 12/02/2018.
//  Copyright © 2018 Ohad Brunner. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class UserModel {
    
    //MARK: Properties
    let name: String
    let email: String
    let id: String
    var profilePic: UIImage


    //MARK: Inits
    init(name: String, email: String, id: String, profilePic: UIImage) {
        self.name = name
        self.email = email
        self.id = id
        self.profilePic = profilePic
    }


}

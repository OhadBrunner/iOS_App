//
//  MyMessageCell.swift
//  iOS_App
//
//  Created by Ohad Brunner on 05/02/2018.
//  Copyright © 2018 Ohad Brunner. All rights reserved.
//

import UIKit

class MyMessageCell: UITableViewCell {

    
    @IBOutlet weak var MessageBackground: UIView!
    
    @IBOutlet weak var AvatarImageView: UIImageView!
    
    @IBOutlet weak var SenderUserName: UILabel!
    
    @IBOutlet weak var MessageBody: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

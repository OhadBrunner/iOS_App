//
//  Model.swift
//  iOS_App
//
//  Created by Ohad Brunner on 18/02/2018.
//  Copyright © 2018 Ohad Brunner. All rights reserved.
//

import Foundation



class Model {
    
    
     static let instance = Model()
    
     lazy private var modelFirebase:ModelFirebase? = ModelFirebase()
    
    
    private init(){
    }
    
    
    
//
//    func saveImage(image:UIImage, name:String, callback:@escaping (String?)->Void){
//        //1. save image to Firebase
//        modelFirebase?.saveImageToFirebase(image: image, name: name, callback: {(url) in
//            if (url != nil){
//                //2. save image localy
//                self.saveImageToFile(image: image, name: name)
//            }
//            //3. notify the user on complete
//            callback(url)
//        })
//    }
    
}

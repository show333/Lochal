//
//  Reaction.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/12/19.
//


import Foundation
import Firebase
import FirebaseFirestore
import SwiftMoment

class Reaction {
    
    var userId: String
    var userName: String
    var userImage: String
    var userFrontId: String
    var theMessage: String
    
    var reactionImage: String
    var reactionMessage: String
    
    var createdAt: Timestamp
    var documentId : String
    var dataType: String
    
    var hexColor:String
    var textFontName:String
    var postImage:String
    
    var imageAddress:String
    var titleComment:String
    
    var releaseBool: Bool
    var acceptBool : Bool
    var admin: Bool
    var anonymous: Bool

    init(dic: [String: Any]) {
        self.userId = dic["userId"] as? String ?? ""
        self.userName = dic["userName"] as? String ?? ""
        self.userImage = dic["userImage"] as? String ?? ""
        self.userFrontId = dic["userFrontId"] as? String ?? ""
        self.theMessage = dic["theMessage"] as? String ?? ""
        
        self.reactionImage = dic["reactionImage"] as? String ?? ""
        self.reactionMessage = dic["reactionMessage"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.documentId = dic["documentId"] as? String ?? ""
        self.dataType = dic["dataType"] as? String ?? ""

        self.hexColor = dic["hexColor"] as? String ?? ""
        self.textFontName = dic["textFontName"]as? String ?? ""
        self.postImage = dic["postImage"]as? String ?? ""

        self.imageAddress = dic["imageAddress"]as? String ?? ""
        self.titleComment = dic["titleComment"]as? String ?? ""
        
        self.releaseBool = dic["releaseBool"] as? Bool ?? false
        self.acceptBool = dic["acceptBool"] as? Bool ?? false
        self.admin = dic["admin"] as? Bool ?? false
        self.anonymous = dic["admin"] as? Bool ?? false

        
    }
    
}

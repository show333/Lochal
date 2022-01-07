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
    var reaction: String
    var createdAt: Timestamp
    var documentId : String
    var admin: Bool
    var anonymous: Bool
    
    
    init(dic: [String: Any]) {
        self.userId = dic["userId"] as? String ?? ""
        self.userName = dic["userName"] as? String ?? ""
        self.userImage = dic["userImage"] as? String ?? ""
        self.userFrontId = dic["userFrontId"] as? String ?? ""
        self.theMessage = dic["theMessage"] as? String ?? ""
        self.reaction = dic["reaction"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.documentId = dic["documentId"] as? String ?? ""
        self.admin = dic["admin"] as? Bool ?? false
        self.anonymous = dic["admin"] as? Bool ?? false

        
    }
    
}

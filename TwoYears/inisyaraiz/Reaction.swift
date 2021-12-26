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
    var theMessage: String
    var reaction: String
    var createdAt: Timestamp
    var documentId : String
    var admin: Bool
    var anonymous: Bool
    
    
    init(dic: [String: Any]) {
        self.userId = dic["userId"] as? String ?? ""
        self.theMessage = dic["theMessage"] as? String ?? ""
        self.reaction = dic["reaction"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.documentId = dic["documentId"] as? String ?? ""
        self.admin = dic["admin"] as? Bool ?? false
        self.anonymous = dic["admin"] as? Bool ?? false

        
    }
    
}

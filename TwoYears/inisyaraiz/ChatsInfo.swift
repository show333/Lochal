//
//  ChatsInfo.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/12/16.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftMoment

class ChatsInfo {
    
    var message: String
    var userId: String
    var createdAt: Timestamp
    var documentId : String
    var randomUserId : String
    var admin: Bool
    var userBrands : String
    var sendImageURL: String
    
    init(dic: [String: Any]) {
        self.message = dic["message"] as? String ?? "a"
        self.userId = dic["userId"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.documentId = dic["documentId"] as? String ?? ""
        self.randomUserId = dic["randomUserId"] as? String ?? ""
        self.admin = dic["admin"] as? Bool ?? false
        self.userBrands = dic["userBrands"] as? String ?? ""
        self.sendImageURL = dic["sendImageURL"] as? String ?? ""
        
    }
    
}

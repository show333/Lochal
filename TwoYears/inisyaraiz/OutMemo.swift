//
//  OutMemo.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/12/18.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftMoment

class OutMemo {
    
    var userId: String
    var message: String
    var sendImageURL: String
    var createdAt: Timestamp
    var documentId : String
    var admin: Bool
    var anonymous: Bool
    
    
    init(dic: [String: Any]) {
        self.userId = dic["userId"] as? String ?? ""
        self.message = dic["message"] as? String ?? "a"
        self.sendImageURL = dic["sendImageURL"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.documentId = dic["documentId"] as? String ?? ""
        self.admin = dic["admin"] as? Bool ?? false
        self.anonymous = dic["admin"] as? Bool ?? false

        
    }
    
}


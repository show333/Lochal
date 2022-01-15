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
    var userImage : String
    var userName : String
    var userFrontId :String
    var message: String
    var sendImageURL: String
    var createdAt: Timestamp
    var textMask: String
    var documentId : String
    var readLog: Bool
    var admin: Bool
    var anonymous: Bool
    var delete : Bool
    
    
    init(dic: [String: Any]) {
        self.userId = dic["userId"] as? String ?? ""
        self.userImage = dic["userImage"] as? String ?? ""
        self.userName = dic["userImage"] as? String ?? ""
        self.userFrontId = dic["userFrontId"] as? String ?? ""
        self.message = dic["message"] as? String ?? "unKnown"
        self.sendImageURL = dic["sendImageURL"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.textMask = dic["textMask"] as? String ?? ""
        self.documentId = dic["documentId"] as? String ?? ""
        self.readLog = dic["readLog"] as? Bool ?? false
        self.admin = dic["admin"] as? Bool ?? false
        self.anonymous = dic["admin"] as? Bool ?? false
        self.delete = dic["delete"] as? Bool ?? false
        
    }
    
}


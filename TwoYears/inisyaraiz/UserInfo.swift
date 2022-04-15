//
//  UserInfo.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/06.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftMoment

class UserInfo {
    
    var userId: String
    var userName: String
    var userImage: String
    var userFrontId:String
    var createdAt: Timestamp
    var chatLatestedAt: Timestamp
    var messageCount:Int
    var admin: Bool
    
    
    init(dic: [String: Any],messageCount: Int,chatLatestedAt:Timestamp) {
        self.userId = dic["userId"] as? String ?? ""
        self.userName = dic["userName"] as? String ?? ""
        self.userImage = dic["userImage"] as? String ?? ""
        self.userFrontId = dic["userFrontId"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.chatLatestedAt = chatLatestedAt
        self.messageCount = messageCount
        self.admin = dic["admin"] as? Bool ?? false
    }
    
}

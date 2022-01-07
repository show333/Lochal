//
//  ReadLog.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/06.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftMoment

class ReadLog {
    
    var userId: String
    var userName: String
    var userImage: String
    var userFrontId: String
    var createdAt: Timestamp
    
    init(dic: [String: Any]) {
        self.userId = dic["userId"] as? String ?? ""
        self.userName = dic["userName"] as? String ?? ""
        self.userImage = dic["userImage"] as? String ?? ""
        self.userFrontId = dic["userFrontId"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        
    }
    
}

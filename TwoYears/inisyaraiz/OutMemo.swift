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
    
    var graffitiUserId : String
    var graffitiUserFrontId: String
    var graffitiUserName: String
    
    var graffitiUserImage: String
    var graffitiTitle: String
    var graffitiContentsImage: String
    
    var hexColor:String
    var backHexColor:String
    var textFontName:String
    
    var readLog: Bool
    var admin: Bool
    var anonymous: Bool
    var delete : Bool
    
    
    init(dic: [String: Any]) {
        self.userId = dic["userId"] as? String ?? ""
        self.userImage = dic["userImage"] as? String ?? ""
        self.userName = dic["userName"] as? String ?? ""
        self.userFrontId = dic["userFrontId"] as? String ?? ""
        self.message = dic["message"] as? String ?? "unKnown"
        self.sendImageURL = dic["sendImageURL"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.textMask = dic["textMask"] as? String ?? ""
        self.documentId = dic["documentId"] as? String ?? ""
        
        self.graffitiUserId = dic["graffitiUserId"] as? String ?? ""
        self.graffitiUserFrontId = dic["graffitiUserFrontId"] as? String ?? ""
        self.graffitiUserName = dic["graffitiUserName"] as? String ?? ""
        self.graffitiUserImage = dic["graffitiUserImage"] as? String ?? ""
        self.graffitiTitle = dic["graffitiTitle"] as? String ?? ""
        self.graffitiContentsImage = dic["graffitiContentsImage"] as? String ?? ""
        
        self.hexColor = dic["hexColor"] as? String ?? ""
        self.backHexColor = dic["backHexColor"] as? String ?? ""
        self.textFontName = dic["textFontName"] as? String ?? "Southpaw"
        
        self.readLog = dic["readLog"] as? Bool ?? false
        self.admin = dic["admin"] as? Bool ?? false
        self.anonymous = dic["anonymous"] as? Bool ?? false
        self.delete = dic["delete"] as? Bool ?? false
        
    }
    
}

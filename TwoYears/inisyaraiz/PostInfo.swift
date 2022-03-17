//
//  PostInfo.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/02/06.
//

import Foundation
import FirebaseFirestore

class PostInfo {
    
    var userId: String
    var documentId: String
    var titleComment: String
    var postImage:String
    var hexColor: String
    var textFontName: String
    var createdAt: Timestamp
    var admin: Bool
    var releaseBool: Bool
    
    init(dic: [String: Any]) {
        self.userId = dic["userId"] as? String ?? ""
        self.postImage = dic["postImage"] as? String ?? ""
        self.documentId = dic["documentId"] as? String ?? ""
        self.titleComment = dic ["titleComment"] as? String ?? ""
        self.hexColor = dic ["hexColor"] as? String ?? ""
        self.textFontName = dic ["textFontName"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.admin = dic["admin"] as? Bool ?? false
        self.releaseBool = dic["releaseBool"] as? Bool ?? true // のちに変更した方が良い
    }
}


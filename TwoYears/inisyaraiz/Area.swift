//
//  Area.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/04/22.
//

import Foundation
import Firebase

struct Area : Equatable{
    static func == (lhs: Area, rhs: Area) -> Bool {
        return lhs.areaNameEn == rhs.areaNameEn
    }
    var areaNameJa : String
    var areaNameEn : String

    var newPostCount : Int
    var addPostCount : Int
    var anonymousPostCount: Int
    var privatePostCount : Int
    var graffitiPostCount : Int
    var memberCount: Int
    var createdAt : Timestamp
    

    
    init(dic: [String: Any],addPostCount:Int){
        self.areaNameJa = dic["areaNameJa"] as? String ?? ""
        self.areaNameEn = dic["areaNameEn"] as? String ?? ""

        self.newPostCount = dic["newPostCount"] as? Int ?? 0
        self.addPostCount = addPostCount
        self.anonymousPostCount = dic["anonymousPostCount"] as? Int ?? 0
        self.privatePostCount = dic["privatePostCount"] as? Int ?? 0
        self.graffitiPostCount = dic["graffitiPostCount"] as? Int ?? 0

        self.memberCount = dic["memberCount"] as? Int ?? 0
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
    
}

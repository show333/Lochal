//
//  Animal.swift
//  protain
//
//  Created by 平田翔大 on 2021/02/01.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import SwiftMoment

struct Animal {
    public var nameJP : String
    public var documentId : String
    public var zikokudosei: Timestamp
    public var latestAt: Timestamp
    public var membersCount : Int
    public var GoodmanCount : Int
    public var messageCount : Int
    public var viewCount: Int = 0
    public var teamname : String
    public var userId : String
    public var admin : Bool
    public var userBrands : String
    public var company1 : String
    
    init(dic: [String: Any]) {
        self.nameJP = dic["message"] as? String ?? ""
        self.documentId = dic["documentId"] as? String ?? ""
        self.zikokudosei = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.membersCount = dic["memberscount"] as! Int
        self.messageCount = dic["messagecount"] as! Int
        self.GoodmanCount = dic["goodcount"] as! Int
        self.viewCount = dic["viewcount"] as? Int ?? 0
        self.teamname = dic["teamname"] as? String ?? ""
        self.userId = dic["userId"] as? String ?? ""
        self.admin = dic["admin"] as? Bool ?? false
        self.userBrands = dic["userBrands"] as? String ?? ""
        self.latestAt = dic["createdLatestAt"]  as? Timestamp ?? Timestamp()
        self.company1 = dic["company1"] as? String ?? ""
        
    }
}


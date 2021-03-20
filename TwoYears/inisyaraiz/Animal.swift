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

struct Animal {
    public var nameJP : String
    public var nameEN : String
    public var imageName : String
    var documentId : String
    var zikokudosei: Timestamp
    var membersCount : Int
    
    init(dic: [String: Any], lalaland: Int) {
        self.nameJP = dic["message"] as? String ?? ""
        self.nameEN = dic["message"] as? String ?? ""
        self.imageName = dic["message"] as? String ?? ""
        self.documentId = dic["documentId"] as? String ?? ""
        self.zikokudosei = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.membersCount = lalaland
        
    }
}


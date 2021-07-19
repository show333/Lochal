//
//  Team.swift
//  protain
//
//  Created by 平田翔大 on 2021/02/10.
//

import Foundation
import Firebase

struct Team {
    public var teamcolor : String
    var invitedId : String
    var jikan : Timestamp

    
    init(dic: [String: Any]){
        self.teamcolor = dic["teamname"] as? String ?? ""
        self.invitedId = dic["招待した人のID"] as? String ?? ""
        self.jikan = dic["jikan"] as? Timestamp ?? Timestamp()
    }
}

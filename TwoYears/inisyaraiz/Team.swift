//
//  Team.swift
//  protain
//
//  Created by 平田翔大 on 2021/02/10.
//

import Foundation
import Firebase

class Team {
    public var teamcolor : String
    
    init(dic: [String:Any]){
        self.teamcolor = dic["message"] as? String ?? ""
    }
}

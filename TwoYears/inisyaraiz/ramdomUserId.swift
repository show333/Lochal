//
//  ramdomUserId.swift
//  TwoYears
//
//  Created by 平田翔大 on 2021/03/23.
//

import Foundation


struct ramdomId {
    var ramdomUserId : String
    
    init(dic: [String: Any]){
        self.ramdomUserId = dic["招待した人のID"] as? String ?? ""
    }
}

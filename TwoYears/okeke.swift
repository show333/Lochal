//
//  okeke.swift
//  protain
//
//  Created by 平田翔大 on 2021/02/03.
//

import Foundation
import Firebase

class okeke {
    let rara: String
    
    var documentId: String?
    
    init(dic: [String: Any]){
        self.rara = dic["rara"] as? String ?? ""
    }

}

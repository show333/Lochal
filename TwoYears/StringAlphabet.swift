//
//  StringAlphabet.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/03/16.
//

import Foundation

extension String {
    // 半角数字の判定
    func isAlphanumeric() -> Bool {
        return !isEmpty && range(of: "[^a-z0-9_]", options: .regularExpression) == nil
    }
    
    // 半角数字の判定
    func isAlphanumericAll() -> Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9_!?.,~()&#$%'/ 　’\n]", options: .regularExpression) == nil
    }
    
}

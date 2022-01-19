//
//  removeString-extension.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/19.
//

import Foundation

extension StringProtocol where Self: RangeReplaceableCollection {
  var removeAllWhitespacesAndNewlines: Self {
    filter { !$0.isNewline && !$0.isWhitespace }
  }
}

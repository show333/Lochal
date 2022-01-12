//
//  CopyUILabel.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/04/17.
//
import Foundation
import UIKit
import TTTAttributedLabel

class CopyUILabel: UILabel{

    /// - Parameter recognizer: UIGestureRecognizer
    @objc func handleLongPressGesture(_ recognizer: UIGestureRecognizer)
    {
        guard recognizer.state == .recognized else { return }

        if let recognizerView = recognizer.view, let recognizerSuperView = recognizerView.superview, recognizerView.becomeFirstResponder() {
            let menuController = UIMenuController.shared
            if #available(iOS 13.0, *) {
                menuController.showMenu(from: recognizerSuperView, rect: recognizerView.frame)
            } else {
                menuController.setTargetRect(recognizerView.frame, in: recognizerSuperView)
                menuController.setMenuVisible(true, animated: true)
            }
        }
    }
}

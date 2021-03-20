//
//  ChatRoomTableViewCell.swift
//  protain
//
//  Created by 平田翔大 on 2021/02/03.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {
    
    var message: Message? {
        didSet {
//            guard let text = messageText else { return }
//            let witdh = estimateFrameForTextView(text: text).width + 10
//
//            messageTextViewWidthConstraint.constant = witdh
//            messageTextView.text = text
            
            if let message = message {
                messageTextView.text = message.message
                let witdh = estimateFrameForTextView(text: message.message).width + 10
                
                messageTextViewWidthConstraint.constant = witdh
                
            }
        }
    }
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageTextViewWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        messageTextView.layer.cornerRadius = 15
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func estimateFrameForTextView(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], context: nil)
    }
    
    
}

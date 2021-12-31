//
//  ChatRoomTableViewCell.swift
//  protain
//
//  Created by 平田翔大 on 2021/02/03.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase
import SwiftMoment
import TTTAttributedLabel


class ChatRoomTableViewCell: UITableViewCell, TTTAttributedLabelDelegate  {
    
    
    // 後で修正
    var message: Message? {
        didSet {
            if let message = message {
                messageLabel.text = message.message
            }
        }
    }
    
    @IBDesignable
    final class ImageButton: UIButton {

        @IBInspectable var unselectedImage: UIImage = UIImage()
        @IBInspectable var selectedImage: UIImage = UIImage()
        
        public var selectedStatus: Bool = false {
            didSet {
                setupImageView()
            }
        }
        override func awakeFromNib() {
            super.awakeFromNib()
            setupImageView()
        }
        override func prepareForInterfaceBuilder() {
            super.prepareForInterfaceBuilder()
            setupImageView()
            setNeedsDisplay()
        }
        private func setupImageView() {
            self.setImage(self.selectedStatus ? self.selectedImage : self.unselectedImage, for: .normal)
            self.setImage(self.selectedStatus ? self.selectedImage : self.unselectedImage, for: .highlighted)
        }
    }
    
    @IBOutlet weak var Imageheight: NSLayoutConstraint!
    @IBOutlet weak var sendImageView: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var messageLabel: TTTAttributedLabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var myBackView: UIView!
    @IBOutlet weak var myMessageLabel: UILabel!
    @IBOutlet weak var myDateLabel: UILabel!
    
    @IBOutlet weak var iineButton: UIButton!
    @IBAction func tappedIineButton(_ sender: Any) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let documentId = message?.documentId else { return }
        guard let comentId = message?.comentId else { return }
        print("部屋のID", documentId)
        print("コメントのId", comentId)
        let DB = Firestore.firestore().collection("Rooms").document("karano").collection("kokoniireru").document(documentId)
        if iineButton.tintColor == #colorLiteral(red: 0.9462587036, green: 0.3739997732, blue: 0.6042566379, alpha: 1){
            self.iineButton.tintColor = .gray
            //部屋そのものとコメントそのものに対していいねを追加
            UIView.animate(withDuration: 0.3, delay: 0, animations: {
                self.iineButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }) { bool in
                // ②アイコンを大きくする
                UIView.animate(withDuration: 0.2, delay: 0, animations: {
                    self.iineButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
            }
            DB.collection("good").document("goodman").updateData([comentId + uid: FieldValue.delete(),])
            DB.collection("messages").document(comentId).updateData([uid: FieldValue.delete(),])
            Firestore.firestore().collection("users").document(message!.uid).updateData([
                "goodcount": FieldValue.increment(Int64(-1))])
            return
        }else{
            UIView.animate(withDuration: 0.10, delay: 0, animations: {
                self.iineButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }) { bool in
            // ②アイコンを大きくする
                UIView.animate(withDuration: 0.2, delay: 0, animations: {
                    self.iineButton.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
                }) { bool in
                    UIView.animate(withDuration: 0.1, delay: 0, animations: {
                        self.iineButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                    })
                }
            }
            self.iineButton.tintColor = #colorLiteral(red: 0.9462587036, green: 0.3739997732, blue: 0.6042566379, alpha: 1)
            DB.collection("good").document("goodman").setData([comentId + uid:"good"],merge:true)
            DB.collection("messages").document(comentId).setData([uid:"good"],merge:true)
            Firestore.firestore().collection("users").document(message!.uid).updateData([
                "goodcount": FieldValue.increment(Int64(1))])
            return
        }
    }
//    コピー機能(位置がおかしいので後で修正)
    @objc func showMenu(sender:AnyObject?) {
        self.becomeFirstResponder()
        let contextMenu = UIMenuController.shared
        if !contextMenu.isMenuVisible {
            contextMenu.setTargetRect(self.bounds, in: self)
            contextMenu.setMenuVisible(true, animated: true)
        }
    }
    override func copy(_ sender: Any?) {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = messageLabel.text as? String
        let contextMenu = UIMenuController.shared
        contextMenu.setMenuVisible(false, animated: true)
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.copy)
    }
    @IBOutlet weak var messageTextViewWidthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.enabledTextCheckingTypes = NSTextCheckingResult.CheckingType.link.rawValue
        messageLabel.delegate = self
        //この機能で一をつける
        let myTap: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ChatRoomTableViewCell.showMenu(sender:)))
        self.messageLabel.addGestureRecognizer(myTap)
        backgroundColor = .clear
//        messageLabel.layer.masksToBounds = true
//        messageLabel.layer.cornerRadius = 12
        backView.layer.masksToBounds = true
        backView.layer.cornerRadius = 18
        messageLabel.backgroundColor = .clear
        
        messageLabel.numberOfLines = 0
        userIdHakkou()
    }
    //urlリンク飛ぶ
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
               if UIApplication.shared.canOpenURL(url) {
                   UIApplication.shared.open(url)
               }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func userIdHakkou()  {
        func randomString(length: Int) -> String {
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
    }
    private func estimateFrameForTextView(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], context: nil)
    }
}


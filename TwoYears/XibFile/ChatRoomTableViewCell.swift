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
    
    
    var chatRoomInfo : ChatsInfo?
    
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
    @IBOutlet weak var imageRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var messageLabel: TTTAttributedLabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageDateLabel: UILabel!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var myBackView: UIView!
    
    @IBOutlet weak var myBackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var myMessageLabel: TTTAttributedLabel!
    @IBOutlet weak var myDateLabel: UILabel!
    
    @IBOutlet weak var myImageDateLabel: UILabel!
    

//    コピー機能(位置がおかしいので後で修正)
    @objc func showMenu(sender:AnyObject?) {
        self.becomeFirstResponder()
        print("あああ")
        let contextMenu = UIMenuController.shared
        if !contextMenu.isMenuVisible {
            contextMenu.setTargetRect(self.bounds, in: self)
            contextMenu.setMenuVisible(true, animated: true)
        }
    }
    
    override func copy(_ sender: Any?) {
        let pasteBoard = UIPasteboard.general
        //このVC内では同一のためこれで
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

    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
        
        messageLabel.enabledTextCheckingTypes = NSTextCheckingResult.CheckingType.link.rawValue
        messageLabel.delegate = self
        
        myMessageLabel.enabledTextCheckingTypes = NSTextCheckingResult.CheckingType.link.rawValue
        myMessageLabel.delegate = self
        
        
        
        let safeAreaWidth = UIScreen.main.bounds.size.width
        
        backViewConstraint.constant = safeAreaWidth/4
        myBackViewConstraint.constant = safeAreaWidth/4 + 43
        
        
        
        
        
        //この機能で一をつける
        let messageTap: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ChatRoomTableViewCell.showMenu(sender:)))
        let myTap: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ChatRoomTableViewCell.showMenu(sender:)))
        self.messageLabel.addGestureRecognizer(messageTap)
        self.myMessageLabel.addGestureRecognizer(myTap)
        backgroundColor = .clear
//        messageLabel.layer.masksToBounds = true
//        messageLabel.layer.cornerRadius = 12
        backView.layer.masksToBounds = true
        backView.layer.cornerRadius = 18
        messageLabel.backgroundColor = .clear
        
        messageLabel.numberOfLines = 0
        
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = 17.5
        
        myBackView.clipsToBounds = true
        myBackView.layer.cornerRadius = 18
        
        
        
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
        let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        ProfileVC.userId = chatRoomInfo?.userId
        ProfileVC.cellImageTap = true
        ProfileVC.tabBarController?.tabBar.isHidden = true
        ViewController()?.navigationController?.navigationBar.isHidden = false
        ViewController()?.navigationController?.pushViewController(ProfileVC, animated: true)
        
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
    
    private func estimateFrameForTextView(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], context: nil)
    }
}


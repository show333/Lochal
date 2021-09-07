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
    
    
    //　後で修正
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
    @IBOutlet weak var thedayLabel: UILabel!
    @IBOutlet weak var messageLabel: TTTAttributedLabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var chatnumbers: UILabel!
    @IBOutlet weak var userrandomId: UILabel!
    @IBOutlet weak var houkokuButton: UIButton!
    @IBAction func tappedHoukokuButton(_ sender: Any) {
        
        //アラート生成
        //UIAlertControllerのスタイルがactionSheet
        let actionSheet = UIAlertController(title: "report", message: "", preferredStyle: UIAlertController.Style.actionSheet)

        // 表示させたいタイトル1ボタンが押された時の処理をクロージャ実装する
        let action1 = UIAlertAction(title: "このユーザーを非表示にする", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            //実際の処理
            let dialog = UIAlertController(title: "本当に非表示にしますか？", message: "ブロックしたユーザーのあらゆる投稿が非表示になります。", preferredStyle: .alert)
            // 選択肢(ボタン)を2つ(OKとCancel)追加します
            //   titleには、選択肢として表示される文字列を指定します
            //   styleには、通常は「.default」、キャンセルなど操作を無効にするものは「.cancel」、削除など注意して選択すべきものは「.destructive」を指定します
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler:  { [self] action in
                if UserDefaults.standard.object(forKey: "blocked") == nil{
                    let XXX = ["XX" : true]
                    UserDefaults.standard.set(XXX, forKey: "blocked")
                }
                var blockDic:[String:Bool] = UserDefaults.standard.object(forKey: "blocked") as! [String: Bool]
                blockDic[message!.uid] = true
                UserDefaults.standard.set(blockDic, forKey: "blocked")
                print(blockDic[message!.uid]! as Bool)
                let uid = Auth.auth().currentUser?.uid
                let docData = [
                    "createdAt": FieldValue.serverTimestamp(),
                    "message": "",
                    "userId": "",
                    "documentId": "",
                    "comentId" : "",
                    "randomUserId": "",
                    "admin": true
                ] as [String: Any]
                Firestore.firestore().collection("Rooms").document("karano").collection("kokoniireru").document(message!.documentId).collection("messages").document("block" + uid!).setData(docData)
                
                Firestore.firestore().collection("Rooms").document("karano").collection("kokoniireru").document(message!.documentId).collection("messages").document("block" + uid!).delete()
                print("a")
                self.ChatRoomViewController()?.navigationController?.popViewController(animated: true)
            }))
            dialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            // 生成したダイアログを実際に表示します
            self.ChatRoomViewController()?.present(dialog, animated: true, completion: nil)
            print("このユーザーを非表示にする")
        })
        // 表示させたいタイトル2ボタンが押された時の処理をクロージャ実装する
        let action2 = UIAlertAction(title: "このユーザーを報告する", style: UIAlertAction.Style.default, handler: { [self]
            (action: UIAlertAction!) in
            //実際の処理
            let uid = Auth.auth().currentUser?.uid
            let report = [
                uid: "報告者",
                "comentId": message!.comentId,
                "documentId": message!.documentId,
                "問題のコメント": message!.message,
                "問題と思われるユーザー": message!.uid,
            ] as! [String: Any]
            Firestore.firestore().collection("report").document(message!.comentId).setData(report, merge: true)
            print("このユーザーを報告する")
    
        })
        // 閉じるボタンが押された時の処理をクロージャ実装する
        //UIAlertActionのスタイルがCancelなので赤く表示される
        let close = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.destructive, handler: {
            (action: UIAlertAction!) in
            //実際の処理
            print("キャンセル")
        })
        //UIAlertControllerにタイトル1ボタンとタイトル2ボタンと閉じるボタンをActionを追加
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(close)
        
        actionSheet.popoverPresentationController?.sourceView = self.ChatRoomViewController()?.view

        let screenSize = UIScreen.main.bounds
        actionSheet.popoverPresentationController?.sourceRect=CGRect(x:screenSize.size.width/2,y:screenSize.size.height,width:0,height:0)
        //実際にAlertを表示する
        ChatRoomViewController()?.present(actionSheet, animated: true, completion: nil)

    }
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


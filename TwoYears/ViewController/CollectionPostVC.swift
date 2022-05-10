//
//  CollectionPostVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/02/04.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Nuke

class CollectionPostVC:UIViewController, UIColorPickerViewControllerDelegate{
    
    var imageString : String?
    var postDocString: String?
    var fontString : String?
    var blurTapCount = 0
    var keyBoardBool : Bool?
    var graffitiColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
    var graffitiFontName = "Southpaw"
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var backGroundImageView: UIImageView!
    
    @IBOutlet weak var imageBackLabel: UILabel!
    @IBOutlet weak var imageBackView: UIView!
    
    @IBOutlet weak var imageBackImageView: UIImageView!
    
    @IBOutlet weak var imageButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageButton: UIButton!
    @IBAction func imageTappedButton(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    @IBOutlet weak var fontBackView: UIView!
    
    @IBOutlet weak var fontBackImageView: UIImageView!
    
    @IBOutlet weak var fontButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fontButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var fontBackLabel: UILabel!
    @IBOutlet weak var fontButton: UIButton!
    @IBAction func fontTappedButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "FontCollection", bundle: nil)
        let FontCollectionVC = storyboard.instantiateViewController(withIdentifier: "FontCollectionVC") as! FontCollectionVC
        self.present(FontCollectionVC, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var sendBackView: UIView!
    
    @IBOutlet weak var sendBackImageView: UIImageView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var sendBackLabel: UILabel!
    @IBOutlet weak var sendButtonHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sendButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButtonBottomConstraint: NSLayoutConstraint!
    
    @IBAction func sendTappedButton(_ sender: Any) {
        
        print("aaa")
        if imageString != nil {
            sendImage()
        } else {
            let removeString = graffitiTextView.text.removeAllWhitespacesAndNewlines
            if removeString == "" {
                self.explainLabel.text = "画像や文字を入力してください"
                labelAnimation()
            } else {
                
                if graffitiTextView.text.isAlphanumericAll() == false {
                    self.explainLabel.text = "文字だけの場合は英数字のみ投稿が可能です"
                    labelAnimation()
                } else {
                    sendImage()
                }
            }
        }
        
        
    }
    
    
    @IBOutlet weak var graffitiImageView: UIImageView!

    @IBOutlet weak var fontedLabel: UILabel!
    
    @IBOutlet weak var fontedSecondLabel: UILabel!
    @IBOutlet weak var fontedSecondBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var wordCountLabel: UILabel!
    
    @IBOutlet weak var wordCountBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var graffitiTextView: UITextView!
    
    @IBOutlet weak var graffitiTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var graffitiTextViewBottomConstraint: NSLayoutConstraint!
    //    @IBOutlet weak var textViewConstraint: NSLayoutConstraint!

    @IBOutlet weak var graffitiBackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var graffitiBackViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var graffitiBackView: UIView!

    
    @IBOutlet weak var graffitiBackViewBottomConstraint: NSLayoutConstraint!
    
    
    
    
    
    fileprivate let placeholder: String = "" //プレイスホルダー
    
    fileprivate var maxWordCount: Int = 30 //最大文字数
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let statusBarHeight = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
       // ナビゲーションバーの高さを取得
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        
        let safeAreaWidth = UIScreen.main.bounds.size.width
        let safeAreaHeight = UIScreen.main.bounds.size.height-statusBarHeight-navigationBarHeight
        
        if keyBoardBool == true {

            UIView.animate(withDuration: 0, delay: 0, animations: {
                self.graffitiTextView.alpha = 0

            }) { bool in
                // ②アイコンを大きくする
                UIView.animate(withDuration: 0.1, delay: 0, animations: { [self] in
                    graffitiTextView.alpha = 1
                    
                    if graffitiTextViewBottomConstraint.constant != safeAreaHeight/3 {
                        graffitiTextViewBottomConstraint.constant = safeAreaHeight/3
                        wordCountBottomConstraint.constant = safeAreaHeight/15 + safeAreaHeight/3 + 5
                        keyBoardBool = nil
                        print("ass")

                    }
                })
            }
            self.view.endEditing(true)

        } else {
            self.view.endEditing(true)

        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            keyBoardBool = true
            
            let statusBarHeight = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
           // ナビゲーションバーの高さを取得
            let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
            
            let safeAreaWidth = UIScreen.main.bounds.size.width
            let safeAreaHeight = UIScreen.main.bounds.size.height-statusBarHeight-navigationBarHeight

            
            if graffitiTextViewBottomConstraint.constant == 200 {
                graffitiTextViewBottomConstraint.constant = keyboardSize.height
                print("aaa")
                wordCountBottomConstraint.constant = keyboardSize.height + safeAreaHeight/15 + 5
            } else {
                graffitiTextViewBottomConstraint.constant = keyboardSize.height
                wordCountBottomConstraint.constant = keyboardSize.height + safeAreaHeight/15 + 5

            }
            

        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let statusBarHeight = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
       // ナビゲーションバーの高さを取得
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        
        let safeAreaWidth = UIScreen.main.bounds.size.width
        let safeAreaHeight = UIScreen.main.bounds.size.height-statusBarHeight-navigationBarHeight
        
        fontedSecondBottomConstraint.constant = safeAreaHeight/2 + safeAreaHeight/3 + 10
        wordCountBottomConstraint.constant = safeAreaHeight/15 + safeAreaHeight/3 + 5
        
        graffitiBackViewWidthConstraint.constant = safeAreaHeight/3
        graffitiBackViewHeightConstraint.constant = safeAreaHeight/3
        
        graffitiBackViewBottomConstraint.constant = safeAreaHeight/2
        
        graffitiTextViewHeightConstraint.constant = safeAreaHeight/15
        graffitiTextViewBottomConstraint.constant = safeAreaHeight/3

        let secondLabelTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(secondLabelTap(_:)))
        fontedSecondLabel.addGestureRecognizer(secondLabelTapGesture)
        fontedSecondLabel.isUserInteractionEnabled = true
        
        let secondLongTapGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(secondLabellongTap(_:))
        )
        fontedSecondLabel.addGestureRecognizer(secondLongTapGesture)
//        #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        self.fontedSecondLabel.alpha = 0
        fontedSecondLabel.text = ""
        fontedLabel.textColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        fontedSecondLabel.font = UIFont(name:"Southpaw", size:20)
//        fontedSecondLabel
        
        fontedLabel.font = UIFont(name:"Southpaw", size:safeAreaHeight/20)

        fontedLabel.text = "Graffiti"
        
        
        let transScale = CGAffineTransform(rotationAngle: CGFloat(270))
        fontedLabel.transform = transScale
        
        
        graffitiTextView.delegate = self
        graffitiTextView.textColor = .gray
        graffitiTextView.text = placeholder
        wordCountLabel.text = "30文字まで"
        
        
        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/backGroound%2FwallPaper.jpg?alt=media&token=1ee6defc-2184-43d8-8232-d0f17c2dc0ee") {
            Nuke.loadImage(with: url, into: backGroundImageView)
        } else {
            backGroundImageView?.image = nil
        }
        
        
        
        graffitiImageView.alpha = 1
        
        let postTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(blurTap(_:)))
        graffitiBackView.addGestureRecognizer(postTapGesture)
        graffitiBackView.isUserInteractionEnabled = true
        
        graffitiBackView.clipsToBounds = true
        graffitiBackView.layer.cornerRadius = 16
        
        let longTapGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(longBlurTap(_:))
        )
        
        graffitiBackView.addGestureRecognizer(longTapGesture)
        
        graffitiTextView.clipsToBounds = true
        graffitiTextView.layer.cornerRadius = 10
        
        fontBackLabel.text = "フォント"
        fontBackLabel.font =  UIFont(name:"03SmartFontUI", size:safeAreaWidth/30)

        

        fontButtonHeightConstraint.constant = safeAreaHeight/14
        fontButtonWidthConstraint.constant = safeAreaHeight/12
        
        fontBackView.clipsToBounds = true
        fontBackView.layer.cornerRadius = safeAreaHeight/48
        fontBackView.layer.masksToBounds = false
        fontBackView.layer.shadowColor = UIColor.black.cgColor
        fontBackView.layer.shadowOffset = CGSize(width: 0, height: 3)
        fontBackView.layer.shadowOpacity = 0.7
        fontBackView.layer.shadowRadius = 5

        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/graffiti_Icons%2FgraffitiIcons.001.png?alt=media&token=94ce8480-0af3-43b8-8280-a8e71815ec87") {
            Nuke.loadImage(with: url, into: fontBackImageView)
        } else {
            fontBackImageView?.image = nil
        }
        
        imageBackLabel.text = "画像"
        imageBackLabel.font =  UIFont(name:"03SmartFontUI", size:safeAreaWidth/30)

        imageBackView.clipsToBounds = true
        imageBackView.layer.cornerRadius = safeAreaHeight/48
        imageBackView.layer.masksToBounds = false
        imageBackView.layer.shadowColor = UIColor.black.cgColor
        imageBackView.layer.shadowOffset = CGSize(width: 0, height: 3)
        imageBackView.layer.shadowOpacity = 0.7
        imageBackView.layer.shadowRadius = 5
        
        
        imageButtonHeightConstraint.constant = safeAreaHeight/14
        imageButtonWidthConstraint.constant = safeAreaHeight/12
        imageButton.clipsToBounds = true
        imageButton.layer.cornerRadius = 16
        imageButton.layer.masksToBounds = false
        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/graffiti_Icons%2FgraffitiIcons.002.png?alt=media&token=a60b7375-be6e-4877-b82f-3048350489d5") {
            Nuke.loadImage(with: url, into: imageBackImageView)
        } else {
            imageBackImageView?.image = nil
        }
        
        sendBackLabel.text = "投稿"
        sendBackLabel.font =  UIFont(name:"03SmartFontUI", size:safeAreaWidth/30)
        
        sendButtonHeightConstraint.constant = safeAreaHeight/12
        sendButtonWidthConstraint.constant = safeAreaHeight/10
        
        sendButtonBottomConstraint.constant = safeAreaHeight/6
        
        
        sendBackView.clipsToBounds = true
        sendBackView.layer.cornerRadius = safeAreaHeight/40
        sendBackView.layer.masksToBounds = false
        sendBackView.layer.shadowColor = UIColor.black.cgColor
        sendBackView.layer.shadowOffset = CGSize(width: 0, height: 3)
        sendBackView.layer.shadowOpacity = 0.7
        sendBackView.layer.shadowRadius = 5
        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/graffiti_Icons%2FgraffitiIcons.003.png?alt=media&token=d47629d5-299d-4f9d-984b-e8be311c71c4") {
            Nuke.loadImage(with: url, into: sendBackImageView)
        } else {
            sendBackImageView?.image = nil
        }
        
        explainLabel.alpha = 0
                
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    
    @objc private func secondLabelTap(_ sender: UITapGestureRecognizer) {
            colorChange()
        print("aaa")
    }
    
    @objc private func secondLabellongTap(_ sender: UILongPressGestureRecognizer) {
        showColorPicker()
    }
    
    
    @objc private func blurTap(_ sender: UITapGestureRecognizer) {
        if imageString != nil {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            colorChange()
        }
    }
    
    @objc private func longBlurTap(_ sender: UILongPressGestureRecognizer) {
        if imageString != nil {
            
        } else {
            showColorPicker()
        }
    }
    
    
    func showColorPicker(){
        let colorPicker = UIColorPickerViewController()
        colorPicker.selectedColor = UIColor.black // 初期カラー
        colorPicker.delegate = self
        colorPicker.supportsAlpha = false
        self.present(colorPicker, animated: true, completion: nil)
    }
    
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        // 色を選択したときの処理
        print("選択した色: \(viewController.selectedColor)")
        fontedLabel.textColor = viewController.selectedColor
        fontedSecondLabel.textColor = viewController.selectedColor
        graffitiColor = viewController.selectedColor
    }
    func colorChange() {
        blurTapCount += 1
        
        let surplusCount = blurTapCount % 9
        
        switch surplusCount {
        case 1 :
            fontedLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            fontedSecondLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            graffitiColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case 2 :
            fontedLabel.textColor = #colorLiteral(red: 0.1397110427, green: 0.1396122622, blue: 0.1522482646, alpha: 1)
            fontedSecondLabel.textColor = #colorLiteral(red: 0.1397110427, green: 0.1396122622, blue: 0.1522482646, alpha: 1)

            graffitiColor = #colorLiteral(red: 0.1397110427, green: 0.1396122622, blue: 0.1522482646, alpha: 1)
        case 3 :
            fontedLabel.textColor = #colorLiteral(red: 0.8549019694, green: 0.1938080545, blue: 0.2193125394, alpha: 1)
            fontedSecondLabel.textColor = #colorLiteral(red: 0.8549019694, green: 0.1938080545, blue: 0.2193125394, alpha: 1)

            graffitiColor = #colorLiteral(red: 0.8549019694, green: 0.1938080545, blue: 0.2193125394, alpha: 1)
        case 4 :
            fontedLabel.textColor = #colorLiteral(red: 1, green: 0.5444763979, blue: 0.09583910595, alpha: 1)
            fontedSecondLabel.textColor = #colorLiteral(red: 1, green: 0.5444763979, blue: 0.09583910595, alpha: 1)

            graffitiColor = #colorLiteral(red: 1, green: 0.5444763979, blue: 0.09583910595, alpha: 1)
        case 5 :
            fontedLabel.textColor = #colorLiteral(red: 0.9607843161, green: 0.8782094742, blue: 0.1591694472, alpha: 1)
            fontedSecondLabel.textColor = #colorLiteral(red: 0.9607843161, green: 0.8782094742, blue: 0.1591694472, alpha: 1)

            graffitiColor = #colorLiteral(red: 0.9607843161, green: 0.8782094742, blue: 0.1591694472, alpha: 1)
        case 6 :
            fontedLabel.textColor = #colorLiteral(red: 0.9095779891, green: 0.3351947527, blue: 0.8762235135, alpha: 1)
            fontedSecondLabel.textColor = #colorLiteral(red: 0.9095779891, green: 0.3351947527, blue: 0.8762235135, alpha: 1)

            graffitiColor = #colorLiteral(red: 0.9095779891, green: 0.3351947527, blue: 0.8762235135, alpha: 1)
        case 7 :
            fontedLabel.textColor = #colorLiteral(red: 0.6157082599, green: 0.4595190551, blue: 0.9686274529, alpha: 1)
            fontedSecondLabel.textColor = #colorLiteral(red: 0.6157082599, green: 0.4595190551, blue: 0.9686274529, alpha: 1)

            graffitiColor = #colorLiteral(red: 0.6157082599, green: 0.4595190551, blue: 0.9686274529, alpha: 1)
        case 8 :
            fontedLabel.textColor = #colorLiteral(red: 0.3766358496, green: 0.9686274529, blue: 0.2729547503, alpha: 1)
            fontedSecondLabel.textColor = #colorLiteral(red: 0.3766358496, green: 0.9686274529, blue: 0.2729547503, alpha: 1)

            graffitiColor = #colorLiteral(red: 0.3766358496, green: 0.9686274529, blue: 0.2729547503, alpha: 1)
        default :
            fontedLabel.textColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
            fontedSecondLabel.textColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
            graffitiColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
            
        }
    }
    
    func labelAnimation(){
        DispatchQueue.main.async(execute: { () -> Void in
            UIView.animate(withDuration: 0.4, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.explainLabel.alpha = 1
                
            }) {(completed) in
                
                UIView.animate(withDuration: 0.2, delay: 2.5, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                    self.explainLabel.alpha = 0
                })
            }
        })
    
    }
    
    
    func randomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in characters.randomElement()! })
    }
    
    func sendImage(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docString = randomString(length: 20)
        
        
        if imageString != nil {
            print("あいえ",imageString)
            let storageRef = Storage.storage().reference().child("Unit_Post_Image").child(imageString!)
            guard let image = graffitiImageView.image  else { return }
            guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }
            
            storageRef.putData(uploadImage, metadata: nil) { ( matadata, err) in
                if let err = err {
                    print("firestrageへの情報の保存に失敗、、\(err)")
                    return
                }
                print("storageへの保存に成功!!")
                storageRef.downloadURL { [self](url, err) in
                    if let err = err {
                        print("firestorageからのダウンロードに失敗\(err)")
                        return
                    }
                    guard let urlString = url?.absoluteString else { return }
                    print("urlString:", urlString)
                    
                    if uid == postDocString {
                        setImage(userId: uid, postImage: urlString, docString:docString, imageString:imageString!, releaseBool: true)
                    } else {
                        setImage(userId: uid, postImage: urlString, docString:docString, imageString:imageString!, releaseBool: false)
                        setNotification(userId: uid, postImage: urlString,docString:docString,imageString: imageString!)
                    }
                }
            }
        } else {
            if uid == postDocString {
                setImage(userId: uid, postImage: "",docString:docString,imageString: "", releaseBool: true)
            } else {
                setImage(userId: uid, postImage: "",docString:docString,imageString: "", releaseBool: false)
                setNotification(userId: uid, postImage: "",docString:docString,imageString: "")
            }
        }
        
        
        guard let tabcon = presentingViewController as? TabbarController else {
            print("Could not find tabbar Controller")
            return
        }
        guard let navigation = tabcon.selectedViewController as? UINavigationController else {
            print("Could not find avigation nController")
            return
        }
        guard let prevView = navigation.topViewController as? ProfileVC else {
              print("Could not find previous viewController")
              return
        }
        if uid == postDocString {
        } else {
            prevView.dismissBool = true

        }
        self.dismiss(animated: true, completion: nil)
        
    }
    func setImage(userId:String,postImage:String,docString:String,imageString:String,releaseBool:Bool){
        
        let hexColor = graffitiColor.toHexString()
        let textFontName = graffitiFontName
        
        let postDoc = [
            "userId":userId,
            "postImage":postImage,
            "documentId":docString,
            "titleComment":graffitiTextView.text ?? "",
            "imageAddress":imageString,
            "hexColor":hexColor,
            "textFontName":textFontName,
            "releaseBool": releaseBool,
            "createdAt": FieldValue.serverTimestamp(),
            "admin":false
        ] as [String:Any]
        
        db.collection("users").document(postDocString ?? "").collection("SendedPost").document(docString).setData(postDoc,merge: true)
        
    }
    
    func setNotification(userId: String, postImage: String,docString:String,imageString:String) {
        
        db.collection("users").document(postDocString ?? "").getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                let notificationNum = document["notificationNum"] as? Int ?? 0
                let hexColor = graffitiColor.toHexString()
                let textFontName = graffitiFontName
                
                
                let docData = [
                    "createdAt": FieldValue.serverTimestamp(),
                    "userId": userId,
                    "userName":UserDefaults.standard.string(forKey: "userName") ?? "unKnown",
                    "userImage":UserDefaults.standard.string(forKey: "userImage") ?? "unKnown",
                    "userFrontId":UserDefaults.standard.string(forKey: "userFrontId") ?? "unKnown",
                    "documentId" : docString,
                    "reactionImage": "",
                    "hexColor":hexColor,
                    "textFontName":textFontName,
                    "reactionMessage":"さんから投稿を受けました",
                    "postImage":postImage,
                    "imageAddress":imageString,
                    "titleComment":graffitiTextView.text ?? "",
                    "theMessage":"",
                    "dataType": "ConnectersPost",
                    "notificationNum": notificationNum+1,
                    "releaseBool":false,
                    "acceptBool":false,
                    "anonymous":false,
                    "admin": false,
                ] as [String: Any]
                
                db.collection("users").document(postDocString ?? "").collection("Notification").document(docString).setData(docData)
                db.collection("users").document(postDocString ?? "").setData(["notificationNum": FieldValue.increment(1.0)], merge: true)
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
}

extension CollectionPostVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            graffitiImageView.image = editImage
            backGroundImageView.image = editImage

            print(editImage)
            
            imageString = NSUUID().uuidString
            
        } else if let originalImage = info[.originalImage] as? UIImage {
            graffitiImageView.image = originalImage
            backGroundImageView.image = originalImage
            print(originalImage)
            print("アイウエオあきくこ")
            
            imageString = NSUUID().uuidString
        }
        
//        graffitiImageView.image?.contentMode = .scaleAspectFit
        
        self.fontedLabel.alpha = 0
        self.fontedSecondLabel.alpha = 1
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CollectionPostVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let existingLines = textView.text.components(separatedBy: .newlines)//既に存在する改行数
        let newLines = text.components(separatedBy: .newlines)//新規改行数
        let linesAfterChange = existingLines.count + newLines.count - 1 //最終改行数。-1は編集したら必ず1改行としてカウントされるから。
        return linesAfterChange <= 3 && textView.text.count + (text.count - range.length) <= maxWordCount
    }
    func textViewDidChange(_ textView: UITextView) {
        let existingLines = textView.text.components(separatedBy: .newlines)//既に存在する改行数
        let textwhite = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)//空白、改行のみを防ぐ
//        if textwhite.isEmpty {
//            sinkiButton.isEnabled = false
//            sinkiButton.backgroundColor = .gray
//        } else {
//            sinkiButton.isEnabled = true
//            sinkiButton.backgroundColor = #colorLiteral(red: 0, green: 0.9052245021, blue: 0.6851730943, alpha: 1)
//        }
        if existingLines.count <= 3 {
            self.wordCountLabel.text = "残り\(maxWordCount - textView.text.count)文字"
            self.fontedLabel.text = textView.text
            if imageString != nil {
            self.fontedSecondLabel.text = textView.text
            }
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = nil
            textView.textColor = .darkText
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .darkGray
            textView.text = placeholder
        }
    }
}


extension CollectionPostVC {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}

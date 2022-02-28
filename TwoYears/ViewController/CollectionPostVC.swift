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


class CollectionPostVC:UIViewController{
    
    var imageString : String?
    var postDocString: String?
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var imageButton: UIButton!
    @IBAction func imageTappedButton(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func sendTappedButton(_ sender: Any) {
        if imageString != nil {
            sendImage()
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
                self.explainLabel.text = "画像が選択されていません"

                UIView.animate(withDuration: 0.4, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                    self.explainLabel.alpha = 1

                }) {(completed) in

                    UIView.animate(withDuration: 0.2, delay: 2.5, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                        self.explainLabel.alpha = 0
                    })
                }
            })
        }
    }
    
    
    @IBOutlet weak var wordCountLabel: UILabel!
    
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var bottomTextView: UITextView!
    
    @IBOutlet weak var textViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var backView: UIView!

    
    func randomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in characters.randomElement()! })
    }
    
    func sendImage(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("Unit_Post_Image").child(imageString!)
        guard let image = imageButton.imageView?.image  else { return }
        guard let uploadImage = image.jpegData(compressionQuality: 0.2) else { return }
        
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
                
                let docString = randomString(length: 20)
                
                setImage(userId: uid, postImage: urlString,docString:docString)
                setNotification(userId: uid, postImage: urlString,docString:docString)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func setImage(userId:String,postImage:String,docString:String){
        

        let postDoc = [
            "userId":userId,
            "postImage":postImage,
            "documentId":docString,
            "titleComment":bottomTextView.text ?? "",
            "createdAt": FieldValue.serverTimestamp(),
            "admin":false
        ] as [String:Any]
        
        db.collection("users").document(postDocString ?? "").collection("SendedPost").document(docString).setData(postDoc,merge: true)
        
    }
    
    func setNotification(userId: String, postImage: String,docString:String) {
        
        db.collection("users").document(postDocString ?? "").getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                let notificationNum = document["notificationNum"] as? Int ?? 0

                
                
                let docData = [
                    "createdAt": FieldValue.serverTimestamp(),
                    "userId": userId,
                    "userName":UserDefaults.standard.string(forKey: "userName") ?? "unKnown",
                    "userImage":UserDefaults.standard.string(forKey: "userImage") ?? "unKnown",
                    "userFrontId":UserDefaults.standard.string(forKey: "userFrontId") ?? "unKnown",
                    "documentId" : docString,
                    "reactionImage": "",
                    "reactionMessage":"さんから投稿を受けました",
                    "theMessage":"",
                    "dataType": "ConnectersPost",
                    "notificationNum": notificationNum+1,
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
    

    
    
    fileprivate let placeholder: String = "" //プレイスホルダー
    
    fileprivate var maxWordCount: Int = 30 //最大文字数

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
        
        bottomTextView.delegate = self
        
        bottomTextView.textColor = .gray
        bottomTextView.text = placeholder
        wordCountLabel.text = "30文字まで"
                
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 16
        backView.layer.masksToBounds = false
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize(width: 0, height: 3)
        backView.layer.shadowOpacity = 0.7
        backView.layer.shadowRadius = 5
        
        imageButton.clipsToBounds = true
        imageButton.layer.cornerRadius = 16
        imageButton.layer.masksToBounds = false

        
        bottomTextView.clipsToBounds = true
        bottomTextView.layer.cornerRadius = 10
        
        sendButton.clipsToBounds = true
        sendButton.layer.cornerRadius = 10
        sendButton.layer.masksToBounds = false
        sendButton.layer.shadowColor = UIColor.black.cgColor
        sendButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        sendButton.layer.shadowOpacity = 0.7
        sendButton.layer.shadowRadius = 5
        
        explainLabel.alpha = 0

        
        
//        backView.alpha = 0
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            } else {
                let suggestionHeight = self.view.frame.origin.y + keyboardSize.height
                self.view.frame.origin.y -= suggestionHeight
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    
}

extension CollectionPostVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            imageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
            print(editImage)
            
            imageString = NSUUID().uuidString
            
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            print(originalImage)
            print("アイウエオあきくこ")
            
            imageString = NSUUID().uuidString
        }
        
        imageButton.imageView?.contentMode = .scaleAspectFit
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

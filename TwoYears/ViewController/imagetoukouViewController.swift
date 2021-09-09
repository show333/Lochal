//
//  imagetoukouViewController.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/05/03.
//

import UIKit
import Firebase
import FirebaseStorage

class imagetoukouViewController: UIViewController {
    var roomId: String?
    let DB = Firestore.firestore().collection("Rooms").document("karano").collection("kokoniireru")
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBAction func sendTappedButton(_ sender: Any) {
        guard let image = imageButton.imageView?.image  else { return }
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("ChatRoom_image").child(fileName)
        storageRef.putData(uploadImage, metadata: nil) { ( matadata, err) in
            if let err = err {
                print("firestrageへの情報の保存に失敗、、\(err)")
                return
            }
            print("storageへの保存に成功!!")
            storageRef.downloadURL { [self] (url, err) in
                if let err = err {
                    print("firestorageからのダウンロードに失敗\(err)")
                    return
                }
                guard let urlString = url?.absoluteString else { return }
                print("urlString:", urlString)
                addMessageToFirestore(urlString: urlString)
            }
        }
    }
    func addMessageToFirestore(urlString: String) {
        let chatRoomDocId =  UserDefaults.standard.string(forKey: "documentId")
        let userMyBrands = UserDefaults.standard.string(forKey: "userBrands")
        let teamname = UserDefaults.standard.string(forKey: "color")
        func randomString(length: Int) -> String {
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
        let randomUserId = randomString(length: 8)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        func comment(randomuserId: String,commentId: String) {
            let docData = [
                "createdAt": FieldValue.serverTimestamp(),
                "message": "",
                "userId": uid,
                "documentId": chatRoomDocId!,
                "comentId" : commentId,
                "admin": false,
                "randomUserId": randomuserId,
                "userBrands": userMyBrands!,
                "sendImageURL": urlString,
                "teamname" : teamname!,
                "company1":""
            ] as [String: Any]
            DB.document(chatRoomDocId!).collection("messages").document(commentId).setData(docData) { (err) in
                if let err = err {
                    print("メッセージ情報の保存に失敗しました。ss\(err)")
                    return
                }
                print("成功！")
            }
        }
        let commentId = uid+"comentId"
        self.DB.document(chatRoomDocId!).collection("messages").whereField("userId", isEqualTo: uid).getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("クエリースナップショットカウント！",querySnapshot!.documents.count)
                if querySnapshot!.documents.count == 0 {
                    comment(randomuserId: "",commentId: commentId)
                    DB.document(chatRoomDocId!).collection("members").document(uid).setData(["randomUserId": randomUserId], merge: true)
                    DB.document(chatRoomDocId!).setData([uid: true], merge: true)
                } else if querySnapshot!.documents.count == 1 {
                    DB.document(chatRoomDocId!).collection("members").document(uid).getDocument { (document, error) in
                        if let document = document, document.exists {
                            let randomUserId = document["randomUserId"] as? String ?? "unknown"
                            let comentId = randomString(length: 15)
                            comment(randomuserId: randomUserId, commentId: comentId)
                            DB.document(chatRoomDocId!).collection("messages").document(uid+"comentId").updateData(["randomUserId":randomUserId])
                        }
                    }
                } else  {
                    DB.document(chatRoomDocId!).collection("members").document(uid).getDocument { (document, error) in
                        if let document = document, document.exists {
                            let randomUserId = document["randomUserId"] as? String ?? "unknown"
                            let comentId = randomString(length: 15)
                            comment(randomuserId: randomUserId, commentId: comentId)
                        }
                    }
                }
            }
            self.DB.document(chatRoomDocId!).collection("messages").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    print(querySnapshot!.documents.count)
                    self.DB.document(chatRoomDocId!).updateData(["messagecount":querySnapshot!.documents.count as Int])
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func imageTappedButton(_ sender: Any) {
        print("aaa")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.layer.cornerRadius = 20
        sendButton.clipsToBounds = true
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
}

extension imagetoukouViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[.originalImage] as? UIImage {
            imageButton.setImage(originalImage, for: .normal)
            imageButton.imageView?.contentMode = .scaleAspectFit
            print(originalImage)
            print("aaa")
        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

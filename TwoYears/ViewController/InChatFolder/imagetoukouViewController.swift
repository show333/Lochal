//
//  imagetoukouViewController.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/05/03.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Nuke

class imagetoukouViewController: UIViewController {
    
    var roomId: String?
    
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    
    
    @IBAction func sendTappedButton(_ sender: Any) {
        guard let image = imageButton.imageView?.image  else { return }
        guard let uploadImage = image.jpegData(compressionQuality: 0.2) else { return }
        
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
    
    private func addMessageToFirestore(urlString: String) {
        let userId = UserDefaults.standard.string(forKey: "chatRoomUserId")


        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        func randomString(length: Int) -> String {
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
        let documentId = randomString(length: 20)
                    let docData = [
                        "createdAt": FieldValue.serverTimestamp(),
                        "message": "",
                        "userId": uid,
                        "documentId" : documentId,
                        "admin": false,
                        "sendImageURL": urlString,
                    ] as [String: Any]
        
        let upDateDoc = [
            "chatLatestedAt": FieldValue.serverTimestamp(),
            "messageCount": FieldValue.increment(1.0),
        ] as [String: Any]
        
        db.collection("users").document(uid).collection("ChatRoom").document(userId ?? "").collection("Messages").document(documentId).setData(docData)
        db.collection("users").document(userId ?? "").collection("ChatRoom").document(uid).collection("Messages").document(documentId).setData(docData)
        db.collection("users").document(userId ?? "").collection("Connections").document(uid).setData(upDateDoc, merge: true)
        db.collection("users").document(userId ?? "").setData(["messageNum": FieldValue.increment(1.0)], merge: true)
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

//
//  UserImageSet.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/06/18.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Firebase
import Nuke

class UserImageSetVC : UIViewController {
    
    let uid = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    var imageString : String?
    
    @IBOutlet weak var imageBackView: UIView!
    
    @IBOutlet weak var explainLabel: UILabel!
    
    @IBOutlet weak var imageButton: UIButton!
    @IBAction func imageTappedButton(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
    }

    @IBOutlet weak var kakuteiButton: UIButton!
    
    @IBAction func kakuteiTappedButton(_ sender: Any) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if imageString != nil {
            getUserImageAddress(userId:uid)
            
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
    
    func getUserImageAddress(userId:String) {
        
        db.collection("users").document(userId).collection("Profile").document("profile").getDocument { [self](document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                let pastUserImageAddress = document["userImageAddress"] as? String ?? ""
                let storageRefImage = Storage.storage().reference().child("User_Image").child(pastUserImageAddress)
                // Delete the file
                storageRefImage.delete { [self] error in
                    if let error = error {
                        // Uh-oh, an error occurred!
                        print(error)
                        print("愛せjfおい")
                        sendImage()
                    } else {
                        // File deleted successfully
                        sendImage()
                    }
                }

            } else {
                print("Document does not exist")
                
            }
        }
    }
    
    func sendImage(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("User_Image").child(imageString!)
        guard let image = imageButton.imageView?.image  else { return }
        guard let uploadImage = image.jpegData(compressionQuality: 0.1) else { return }
        
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
                
                UserDefaults.standard.set(urlString, forKey: "userImage")
                setImage(userId: uid, userImage: urlString, userImageAddress: imageString!)
                fetchMyPost(userId: uid, userImage: urlString)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func setImage(userId:String,userImage:String,userImageAddress:String){
        let imageInfo = [
            "userImage":userImage,
            "userImageAddress":userImageAddress,
        ] as [String : Any]
        db.collection("users").document(userId).collection("Profile").document("profile").setData(imageInfo,merge: true)
        db.collection("users").document(userId).setData(imageInfo,merge: true)
    }
    
    func fetchMyPost(userId:String,userImage:String){
        db.collection("users").document(userId).collection("MyPost").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot!.documents.count == 0 {
                } else {
                    for document in querySnapshot!.documents {
//                        print("\(document.documentID) => \(document.data())")
                        let myPostDocId =  document.data()["documentId"] as? String ?? "unKnown"
                        self.db.collection("users").document(userId).collection("MyPost").document(myPostDocId).setData(["userImage":userImage] as [String : Any],merge: true)
                    }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let safeArea = UIScreen.main.bounds.size.width
        
        
        setSwipeBack()

        explainLabel.alpha = 0
        
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
        
        imageButton.clipsToBounds = true
        imageButton.layer.cornerRadius = 75
        
        imageBackView.clipsToBounds = true
        imageBackView.layer.masksToBounds = false
        imageBackView.layer.cornerRadius =  75
        imageBackView.layer.shadowColor = UIColor.black.cgColor
        imageBackView.layer.shadowOffset = CGSize(width: 0, height: 3)
        imageBackView.layer.shadowOpacity = 0.7
        imageBackView.layer.shadowRadius = 5

        kakuteiButton.clipsToBounds = true
        kakuteiButton.layer.masksToBounds = false
        kakuteiButton.layer.cornerRadius = 10
        kakuteiButton.layer.shadowColor = UIColor.black.cgColor
        kakuteiButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        kakuteiButton.layer.shadowOpacity = 0.7
        kakuteiButton.layer.shadowRadius = 5
        
        
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
extension UserImageSetVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            imageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
            print(editImage)
            print("キシン！")
            
            imageString = NSUUID().uuidString
            
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            print(originalImage)
            print("アイウエオあきくこ")
            
            imageString = NSUUID().uuidString
            
        }
        
        print("aaa")
        
        
        imageButton.imageView?.contentMode = .scaleAspectFit
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

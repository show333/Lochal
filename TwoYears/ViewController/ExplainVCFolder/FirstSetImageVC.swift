//
//  FirstSetImageVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/22.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Firebase
import Nuke

class FirstSetImageVC : UIViewController {
    
    let uid = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    var imageString : String?
    var pastUserImageAddress:String = ""
    
    let skipImageArray = [
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/skipUserLogo%2Fundraw_refreshing_beverage_blue.png?alt=media&token=c45c9978-6c0e-481c-98f3-2493ac67d5fe",
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/skipUserLogo%2Fundraw_refreshing_beverage_graypng.png?alt=media&token=3b5c4178-d1f5-4c48-aa1a-fb33730342e0",
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/skipUserLogo%2Fundraw_refreshing_beverage_green.png?alt=media&token=c1e66255-6c0b-4156-86e0-d95f2acb4d75",
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/skipUserLogo%2Fundraw_refreshing_beverage_purple.png?alt=media&token=929a9404-a62e-4e2a-a804-3daa193d41c1",
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/skipUserLogo%2Fundraw_refreshing_beverage_redr.png?alt=media&token=2b84aa67-abb3-4de2-9eb5-263ee8380e03",
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/skipUserLogo%2Fundraw_refreshing_beverage_td3r.png?alt=media&token=f2ea21ef-f532-4029-92d7-62c02a975431",
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/skipUserLogo%2Fundraw_refreshing_beverage_yellowr.png?alt=media&token=f74d54f3-a7e6-4f5c-8170-b991d1d72555"
    ]
    
    @IBOutlet weak var imageBackView: UIView!
        
    @IBOutlet weak var imageConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageButton: UIButton!
    @IBAction func imageTappedButton(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var skipButton: UIButton!
    
    @IBAction func skipTappedButton(_ sender: Any) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let skipImageString = skipImageArray.randomElement()
        
        UserDefaults.standard.set(skipImageString, forKey: "userImage")

        let storageRefImage = Storage.storage().reference().child("User_Image").child(pastUserImageAddress)
        // Delete the file
        storageRefImage.delete { [self] error in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error)
                setImage(userId: uid, userImage: skipImageString ?? "", userImageAddress: "")
                fetchMyPost(userId: uid, userImage: skipImageString ?? "")
            } else {
                // File deleted successfully
                setImage(userId: uid, userImage: skipImageString ?? "", userImageAddress: "")
                fetchMyPost(userId: uid, userImage: skipImageString ?? "")
            }
        }
  
        
        let storyboard = UIStoryboard.init(name: "FirstSetId", bundle: nil)
        let FirstSetIdVC = storyboard.instantiateViewController(withIdentifier: "FirstSetIdVC") as! FirstSetIdVC
        navigationController?.pushViewController(FirstSetIdVC, animated: true)
    }
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var kakuteiButton: UIButton!
    
    @IBAction func kakuteiTappedButton(_ sender: Any) {
        
        if imageString != nil {
            let storageRefImage = Storage.storage().reference().child("User_Image").child(pastUserImageAddress)
            // Delete the file
            storageRefImage.delete { [self] error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    print(error)
                    sendImage()

                } else {
                    // File deleted successfully
                    sendImage()
                }
            }

        } else {
            labelAnimation()
        }
    }
    
    func getUserImageAddress(userId:String) {
        
        db.collection("users").document(userId).collection("Profile").document("profile").getDocument { [self](document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                pastUserImageAddress = document["userImageAddress"] as? String ?? ""
                

            } else {
                print("Document does not exist")
                
            }
        }
    }
    
    
    func sendImage() {
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
                setImage(userId: uid, userImage: urlString, userImageAddress: imageString ?? "")
                fetchMyPost(userId: uid, userImage: urlString)
            }
        }
        let storyboard = UIStoryboard.init(name: "FirstSetId", bundle: nil)
        let FirstSetIdVC = storyboard.instantiateViewController(withIdentifier: "FirstSetIdVC") as! FirstSetIdVC
        navigationController?.pushViewController(FirstSetIdVC, animated: true)
    }
    
    func labelAnimation(){
        UIView.animate(withDuration: 0.2, delay: 0.1, animations: {
            self.warningLabel.alpha = 1
//
//
        }) { bool in
        // ②アイコンを大きくする
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.warningLabel.alpha = 1

        }) { bool in
            // ②アイコンを大きくする
            UIView.animate(withDuration: 0.2, delay: 2, animations: {
                self.warningLabel.alpha = 0

            })
            }
        }
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
        
        warningLabel.alpha = 0
                
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
        
        let safeAreaWidth = UIScreen.main.bounds.size.width
        
        imageButton.clipsToBounds = true
        imageButton.layer.cornerRadius = safeAreaWidth/4
        
        
        imageConstraint.constant = safeAreaWidth/2
        imageBackView.clipsToBounds = true
        imageBackView.layer.masksToBounds = false
        imageBackView.layer.cornerRadius = safeAreaWidth/4
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
extension FirstSetImageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            imageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
            print(editImage)
            imageString = NSUUID().uuidString
            
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            print(originalImage)
            imageString = NSUUID().uuidString
        }
        imageButton.imageView?.contentMode = .scaleAspectFit
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

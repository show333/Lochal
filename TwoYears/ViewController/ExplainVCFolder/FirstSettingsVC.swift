//
//  FirstSettingsVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/05/18.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

//機能的にはほとんど完成(画像削除機能以外)しているけれど使うのやめる
class FirstSettingsVC:UIViewController {
    var imageString : String?

    let db = Firestore.firestore()
    
    let skipImageArray = [
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/skipUserLogo%2Fundraw_refreshing_beverage_blue.png?alt=media&token=c45c9978-6c0e-481c-98f3-2493ac67d5fe",
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/skipUserLogo%2Fundraw_refreshing_beverage_graypng.png?alt=media&token=3b5c4178-d1f5-4c48-aa1a-fb33730342e0",
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/skipUserLogo%2Fundraw_refreshing_beverage_green.png?alt=media&token=c1e66255-6c0b-4156-86e0-d95f2acb4d75",
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/skipUserLogo%2Fundraw_refreshing_beverage_purple.png?alt=media&token=929a9404-a62e-4e2a-a804-3daa193d41c1",
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/skipUserLogo%2Fundraw_refreshing_beverage_redr.png?alt=media&token=2b84aa67-abb3-4de2-9eb5-263ee8380e03",
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/skipUserLogo%2Fundraw_refreshing_beverage_td3r.png?alt=media&token=f2ea21ef-f532-4029-92d7-62c02a975431",
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/skipUserLogo%2Fundraw_refreshing_beverage_yellowr.png?alt=media&token=f74d54f3-a7e6-4f5c-8170-b991d1d72555"
    ]
    
    @IBOutlet weak var imageLabel: UILabel!
    
    @IBOutlet weak var imageBackView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func presentImagePicker(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
        print("アセオフィj")
        
    }
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBAction func confirmTappedButton(_ sender: Any) {
        let idText = idTextField.text
        let removeIdText = idText?.removeAllWhitespacesAndNewlines
        let sendUserId = removeIdText?.lowercased() ?? ""
        let sendUserIdBool = sendUserId.count
        
        let nameText = nameTextField.text
        let sendUserName = nameText?.removeWhitespacesAndNewlines ?? ""
        let sendUserNameBool = sendUserName.count
        
        print("亜教えfじょs",sendUserNameBool)
        
        if sendUserIdBool<2 || sendUserIdBool>30 || sendUserNameBool<2 || sendUserNameBool>30 {
            warningLabel.text = "IDや名前は\n2~30文字で入力してください"
            labelAnimation()
        } else {
            if sendUserId.isAlphanumeric() == false {
                warningLabel.text = "IDに使用できない文字が含まれています"
                labelAnimation()
            } else {
                guard let uid = Auth.auth().currentUser?.uid else {return}
                getAccount(userId:uid,userFrontId:sendUserId,userName:sendUserName)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainBoundSize = UIScreen.main.bounds.size.height
        let statusBarHeight = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

        let screenHeight = mainBoundSize - statusBarHeight
        
        imageViewHeightConstraint.constant = screenHeight/8
        
        imageBackView.backgroundColor = .white

        imageBackView.clipsToBounds = true
        imageBackView.layer.masksToBounds = false
        imageBackView.layer.cornerRadius = screenHeight/16
        imageBackView.layer.shadowColor = UIColor.black.cgColor
        imageBackView.layer.shadowOffset = CGSize(width: 0, height: 3)
        imageBackView.layer.shadowOpacity = 0.3
        imageBackView.layer.shadowRadius = 5
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = screenHeight/16
        
        idTextField.clipsToBounds = true
        idTextField.layer.masksToBounds = false
        idTextField.layer.cornerRadius = 8
        idTextField.layer.shadowColor = UIColor.black.cgColor
        idTextField.layer.shadowOffset = CGSize(width: 0, height: 3)
        idTextField.layer.shadowOpacity = 0.1
        idTextField.layer.shadowRadius = 5
        
        nameTextField.clipsToBounds = true
        nameTextField.layer.masksToBounds = false
        nameTextField.layer.cornerRadius = 8
        nameTextField.layer.shadowColor = UIColor.black.cgColor
        nameTextField.layer.shadowOffset = CGSize(width: 0, height: 3)
        nameTextField.layer.shadowOpacity = 0.1
        nameTextField.layer.shadowRadius = 5

        
        confirmButton.backgroundColor = .white
        confirmButton.clipsToBounds = true
        confirmButton.layer.masksToBounds = false
        confirmButton.layer.cornerRadius = 10
        confirmButton.layer.shadowColor = UIColor.black.cgColor
        confirmButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        confirmButton.layer.shadowOpacity = 0.6
        confirmButton.layer.shadowRadius = 5
        
        
        imageLabel.text = "アイコンを設定してください"
        nameLabel.text = "お友達にわかりやすい名前を\n入力してください"
        idLabel.text = "半角英数字でIDを入力してください"
        
        warningLabel.alpha = 0
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    
    
    func getAccount(userId:String,userFrontId:String,userName:String){
        db.collection("users").whereField("userFrontId", isEqualTo: userFrontId)
            .getDocuments() { [self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot!.documents.count == 0{
                        
                        
                        let storageRefImage = Storage.storage().reference().child("User_Image").child(imageString!)
                        // Delete the file
                        storageRefImage.delete { [self] error in
                            if let error = error {
                                // Uh-oh, an error occurred!
                                print(error)
                            } else {
                                // File deleted successfully
                                if imageString != nil {
                                    //画像と名前とIDがある場合
                                    sendImage(userId: userId, userFrontId: userFrontId, userName: userName)
                                } else {
                                    //画像がなくて名前とIDがある場合
                                    let userImage = skipImageArray.randomElement() ?? "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/skipUserLogo%2Fundraw_refreshing_beverage_yellowr.png?alt=media&token=f74d54f3-a7e6-4f5c-8170-b991d1d72555"
                                    
                                    setIdAccount(userId: userId, userFrontId: userFrontId, userName: userName, userImage: userImage, userImageAddress: "")
                                    fetchMyPost(userId:userId,userFrontId:userFrontId,userName:userName,userImage:userImage)

                                    UserDefaults.standard.set(userImage, forKey: "userImage")
                                    
                                }
                            }
                        }
                        
                        let storyboard = UIStoryboard.init(name: "AgeSelect", bundle: nil)
                        let AgeSelectVC = storyboard.instantiateViewController(withIdentifier: "AgeSelectVC") as! AgeSelectVC
                        navigationController?.pushViewController(AgeSelectVC, animated: true)
                        
                    } else {
                        warningLabel.text = "このアカウントはすでに使用されています"
                        labelAnimation()
                    }
                }
        }
    }
    
    
    func sendImage(userId:String,userFrontId:String,userName:String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("User_Image").child(imageString!)
        guard let image = imageView?.image  else { return }
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
                setIdAccount(userId: userId, userFrontId: userFrontId, userName: userName, userImage: urlString, userImageAddress: imageString ?? "")
                fetchMyPost(userId:userId,userFrontId:userFrontId,userName:userName,userImage:urlString)
                
            }
        }
        let storyboard = UIStoryboard.init(name: "FirstSetId", bundle: nil)
        let FirstSetIdVC = storyboard.instantiateViewController(withIdentifier: "FirstSetIdVC") as! FirstSetIdVC
        navigationController?.pushViewController(FirstSetIdVC, animated: true)
    }
    
    func setIdAccount(userId:String,userFrontId:String,userName:String,userImage:String,userImageAddress:String){
        let settingsInfo = [
            "userName":userName,
            "userImage":userImage,
            "userFrontId":userFrontId,
            "userImageAddress":userImageAddress
        ] as [String:Any]
        
        let settingsProfile = [
            "userName":userName,
            "userImage":userImage,
            "userFrontId":userFrontId
        ] as [String:Any]
        
        UserDefaults.standard.set(userFrontId, forKey: "userFrontId")
        UserDefaults.standard.set(userName, forKey: "userName")

        
        db.collection("users").document(userId).collection("Profile").document("profile").setData(settingsProfile,merge: true)
        db.collection("users").document(userId).setData(settingsInfo,merge: true)
    }
    
    func fetchMyPost(userId:String,userFrontId:String,userName:String,userImage:String){
        db.collection("users").document(userId).collection("MyPost").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot!.documents.count == 0 {
                } else {
                    for document in querySnapshot!.documents {
//                        print("\(document.documentID) => \(document.data())")
                        let myPostDocId =  document.data()["documentId"] as? String ?? "unKnown"
                        print("ハングリー",myPostDocId)
                        let outMemoProfile = [
                            "userName":userName,
                            "userImage":userImage,
                            "userFrontId":userFrontId
                        ] as [String:Any]
                        self.db.collection("users").document(userId).collection("MyPost").document(myPostDocId).setData(outMemoProfile,merge: true)
                    }
                }
            }
        }
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
    

    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
extension FirstSettingsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            imageView.image = editImage


            imageString = NSUUID().uuidString

        } else if let originalImage = info[.originalImage] as? UIImage {
            imageView.image = originalImage

            imageString = NSUUID().uuidString

        }


        imageView?.contentMode = .scaleAspectFit
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}


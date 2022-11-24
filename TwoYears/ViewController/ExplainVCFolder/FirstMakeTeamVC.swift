//
//  FirstMakeTeamVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/23.
//

import UIKit
import Nuke
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Firebase

class FirstMakeTeamVC: UIViewController, UIGestureRecognizerDelegate {
    
    var imageString : String?
    var companynameString : String?
    var UserId : String?
    
    var randamUserImageInt: Int?
    
    let db = Firestore.firestore()
    


    
    @IBOutlet weak var companyImageView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    @IBAction func imageTappedButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var kakteiButton: UIButton!
    
    
    @IBAction func bubuButton(_ sender: Any) {
        
        if let teamNameString = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if imageString == nil || companynameString == "" {
                UIView.animate(withDuration: 0.5, delay: 0, animations: {
                    self.tyuuiLabel.alpha = 1
                }) { bool in
                    UIView.animate(withDuration: 0.5, delay: 3, animations: {
                        self.tyuuiLabel.alpha = 0
                    })}
                
            } else {
                
                setTeam(teamName: teamNameString)
                
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    
    func setTeam(teamName:String){
        let storageRef = Storage.storage().reference().child("Team_Image").child(imageString!)
        
        guard let image = imageButton.imageView?.image  else { return }
        guard let uploadImage = image.jpegData(compressionQuality: 0.1) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        func randomString(length: Int) -> String {
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
        let randomId = randomString(length: 16)
        let chatFirstId = randomString(length: 20)
        let chatSecondId = randomString(length: 20)
        let chatThirdId = randomString(length: 20)
        
        
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
                
                let teamDic = [
                    "createdAt": FieldValue.serverTimestamp(),
                    "documentId": randomId,
                    "teamId":randomId,
                    "teamName": teamName,
                    "teamImage": urlString,
                    "Founder": uid,
                    "membersCount": FieldValue.increment(1.0)
                ] as [String: Any]
                
                db.collection("Team").document(randomId).setData(teamDic)
                db.collection("Team").document(randomId).collection("MembersId").document("membersId").setData(["userId": FieldValue.arrayUnion([uid])], merge: true)
                db.collection("users").document(uid).collection("belong_Team").document("teamId").setData([
                    "teamId": FieldValue.arrayUnion([randomId]) ], merge: true)
                //                setChatDic(randomId: randomId, chatId: chatId)
                let firstChatDic = [
                    "createdAt": FieldValue.serverTimestamp(),
                    "userId":"gBD75KJjTSPcfZ6TvbapBgTqpd92",
                    "documentId": chatFirstId,
                    "message":randomId,
                    "sendImageURL": "",
                    "teamId":randomId,
                    "admin":false,
                ] as [String : Any]
                db.collection("Team").document(randomId).collection("ChatRoom").document(chatFirstId).setData(firstChatDic)
                
                print("1番目")
       
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let secondChatDic = [
                        "createdAt": FieldValue.serverTimestamp(),
                        "userId":"gBD75KJjTSPcfZ6TvbapBgTqpd92",
                        "documentId": chatSecondId,
                        "message":"上記のIDを親しい人に招待IDとして送ってください",
                        "sendImageURL": "",
                        "teamId":randomId,
                        "admin":false,
                    ] as [String : Any]
                    db.collection("Team").document(randomId).collection("ChatRoom").document(chatSecondId).setData(secondChatDic)
                    print("2番目")
                }
                

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let thirdChatDic = [
                        "createdAt": FieldValue.serverTimestamp(),
                        "userId":"gBD75KJjTSPcfZ6TvbapBgTqpd92",
                        "documentId": chatThirdId,
                        "message":"このチャット内は招待された方のみ閲覧,投稿が可能です.",
                        "sendImageURL": "",
                        "teamId":randomId,
                        "admin":false,
                    ] as [String : Any]
                    db.collection("Team").document(randomId).collection("ChatRoom").document(chatThirdId).setData(thirdChatDic)
                    print("３番目")
                }
            }
        }
    }
    
    @IBOutlet weak var tyuuiLabel: UILabel!
    
    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                
        tyuuiLabel.text = "チームロゴと名前のの\n両方を入力してください"
        tyuuiLabel.alpha = 0
        
        
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "戻る",
            style: .plain,
            target: nil,
            action: nil
        )
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        imageButton.clipsToBounds = true
        imageButton.layer.cornerRadius = 100
        
        companyImageView.clipsToBounds = true
        companyImageView.layer.cornerRadius = 100
        companyImageView.layer.masksToBounds = false
        companyImageView.layer.shadowColor = UIColor.black.cgColor
        companyImageView.layer.shadowOffset = CGSize(width: 0, height: 3)
        companyImageView.layer.shadowOpacity = 0.7
        companyImageView.layer.shadowRadius = 5
        
        
        nameTextField.clipsToBounds = true
        nameTextField.layer.cornerRadius = 10
        nameTextField.layer.masksToBounds = false
        nameTextField.layer.shadowColor = UIColor.black.cgColor
        nameTextField.layer.shadowOffset = CGSize(width: 0, height: 3)
        nameTextField.layer.shadowOpacity = 0.7
        nameTextField.layer.shadowRadius = 5
        
        kakteiButton.clipsToBounds = true
        kakteiButton.layer.masksToBounds = false
        kakteiButton.layer.cornerRadius = 10
        kakteiButton.layer.shadowColor = UIColor.black.cgColor
        kakteiButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        kakteiButton.layer.shadowOpacity = 0.7
        kakteiButton.layer.shadowRadius = 5
        setSwipeBack()

    }

    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
//
extension FirstMakeTeamVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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


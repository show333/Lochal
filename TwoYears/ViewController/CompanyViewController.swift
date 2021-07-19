//
//  CompanyViewController.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/06/15.
//

import UIKit
import Nuke
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Firebase

class CompanyViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var imageString : String?
    var companynameString : String?
    var CompanyId : String?
    var UserId : String?
    
    var randamUserImageInt: Int?
    
    let userImage : Array = ["https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA11gusya.png?alt=media&token=fc744cee-7365-441c-81d4-8f877076ec13",
    "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB2hyokkori.png?alt=media&token=13eb5fa7-d790-451b-a7a2-43c1b1b532f8",
    "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB3korede.png?alt=media&token=70a31f21-728b-4339-93f1-7984ac7f635a",
    "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB4ha-to.png?alt=media&token=22cb5c5e-d4f1-4a46-be32-5c708f669473",
    "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FC12flag.png?alt=media&token=e55ae578-4826-4bd8-962a-b989f61b736d",
    "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FD2kondru.png?alt=media&token=3566e4ce-6102-4735-a553-d973b70509d9",
    "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF1burebure.png?alt=media&token=6ef860dc-4669-4abd-bfbe-acccfada72d4",
    "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF18gojou.png?alt=media&token=0ce25eb8-9048-482e-a9fd-4faf593c28a2",
    "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FG2nemasu.png?alt=media&token=a03da529-c8c6-4f8e-94b8-39fefd8de034",
    "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FG8dog.png?alt=media&token=3755a316-e21a-491c-b050-267d5c9a9e8f",]
    
    
    let firebaseCompany = Firestore.firestore().collection("Company1").document("Company1_document").collection("Company2").document("Company2_document").collection("Company3")
    


    
    @IBOutlet weak var companyImageView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    @IBAction func imageTappedButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        print("bbbbb")
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var kakteiButton: UIButton!
    
    @IBOutlet var companyTap: UITapGestureRecognizer!
    
    @IBAction func companyTap(_ sender: Any) {
  
    }

    @IBAction func bubuButton(_ sender: Any) {
        
        if let companynameString = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if imageString == nil || companynameString == "" {
                UIView.animate(withDuration: 0.5, delay: 0, animations: {
                    self.tyuuiLabel.alpha = 1
                }) { bool in
                    UIView.animate(withDuration: 0.5, delay: 3, animations: {
                        self.tyuuiLabel.alpha = 0

                    })}
                
            } else {
                
                if CompanyId != nil {
                    firebaseUpdate(companyName: companynameString)
                } else{
                    if  UserId == "none"{
                        firebaseSet(companyName: companynameString)
                    } else {
                        firebaseHadUser(companyName: companynameString)
                    }
                }
                
                self.navigationController?.popViewController(animated: true)
                
            }
        }
    }
    
    
    func firebaseUpdate(companyName: String?) {
        
        let storageRef = Storage.storage().reference().child("Campany_Logo").child(imageString!)
        
        guard let image = imageButton.imageView?.image  else { return }
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }
        
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
                
                let companyData = [
                    "createdLatestAt": FieldValue.serverTimestamp(),
                    "companyLogoImage": urlString,
                    "companyName": companyName!,
                    
                ] as [String: Any]

                firebaseCompany.document(CompanyId!).setData(companyData,merge: true)
            }
        }
        
    }
    
    func firebaseHadUser(companyName: String?) {
        
        let storageRef = Storage.storage().reference().child("Campany_Logo").child(imageString!)
        let teamname = UserDefaults.standard.string(forKey: "color")
        
        func randomString(length: Int) -> String {
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
        
        let randomCompanyId = randomString(length: 20)
  

        guard let image = imageButton.imageView?.image  else { return }
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
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
                
                let companyData = [
                    "createdAt": FieldValue.serverTimestamp(),
                    "createdLatestAt": FieldValue.serverTimestamp(),
                    "Founder": uid,
                    "companyId": randomCompanyId,
                    "companyLogoImage": urlString,
                    "companyName": companyName!,
                    "FounderColor": teamname!,
                    
                ] as [String: Any]
                

                
                firebaseCompany.document(randomCompanyId).setData(companyData)
                firebaseCompany.document(randomCompanyId).collection("userColor").document("company_1_Color").setData([teamname! + "User" : 1])
                Firestore.firestore().collection("users").document(uid).setData(["company1": randomCompanyId,"Founder":true],merge: true)
            }
        }
    }
    
    func firebaseSet(companyName: String?) {
        
        let storageRef = Storage.storage().reference().child("Campany_Logo").child(imageString!)
        let teamname = UserDefaults.standard.string(forKey: "color")
        let userMyBrands = UserDefaults.standard.string(forKey: "userBrands")
        
        func randomString(length: Int) -> String {
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
        

        
        let randomCompanyId = randomString(length: 20)
        let randamUserName = "初期name-" + randomString(length: 15)
  

        guard let image = imageButton.imageView?.image  else { return }
        guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
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
                
                let companyData = [
                    "createdAt": FieldValue.serverTimestamp(),
                    "createdLatestAt": FieldValue.serverTimestamp(),
                    "Founder": uid,
                    "companyId": randomCompanyId,
                    "companyLogoImage": urlString,
                    "companyName": companyName!,
                    "FounderColor": teamname!,
                    "companyViewCount": 0,
                    "companyGoodCount": 0,
                    
                ] as [String: Any]
                
                let userDate = [
                    "JoindTime": FieldValue.serverTimestamp(),
                    "uid":uid,
                    "userColor": teamname!,
                    "userBrands": userMyBrands!,
                    "userImage1": self.userImage[self.randamUserImageInt!],
                    "userName1": randamUserName,
                    "belong": true,
                    
                ] as [String: Any]
                
                firebaseCompany.document(randomCompanyId).setData(companyData)
                firebaseCompany.document(randomCompanyId).collection("members").document(uid).setData(userDate)
                firebaseCompany.document(randomCompanyId).collection("userColor").document("company_1_Color").setData([teamname! + "User" : 1])
                Firestore.firestore().collection("users").document(uid).setData(["userImage1":self.userImage[self.randamUserImageInt!],"userName1":randamUserName] as [String : Any] , merge: true)
                
                
                Firestore.firestore().collection("users").document(uid).setData(["company1": randomCompanyId,"Founder":true],merge: true)
            }
        }
    }
    
    
  
    
    @IBOutlet weak var tyuuiLabel: UILabel!
    
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func randomString(length: Int) -> String {
            let characters = "0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
        randamUserImageInt = Int(randomString(length: 1))
        print(randamUserImageInt!)
        
        
        companyTap.delegate = self
        
        tyuuiLabel.text = "カンパニーロゴとカンパニー名の\n両方を入力してください"
        tyuuiLabel.alpha = 0
        

        
        guard let uid = Auth.auth().currentUser?.uid else { return }

        
        Firestore.firestore().collection("users").document(uid).getDocument{ (document, error) in
          if let document = document {
//            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"

            self.CompanyId = document.data()?["company1"] as? String
            
          } else {
            print("Document does not exist in cache")
          }
        }
        
        
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "戻る",
            style: .plain,
            target: nil,
            action: nil
        )
        
        self.navigationController?.navigationBar.isHidden = true
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
//        kakteiButton.layer.cornerRadius = 10
                
        kakteiButton.layer.masksToBounds = false
        kakteiButton.layer.cornerRadius = 10
        kakteiButton.layer.shadowColor = UIColor.black.cgColor
        kakteiButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        kakteiButton.layer.shadowOpacity = 0.7
        kakteiButton.layer.shadowRadius = 5
        
    }

    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
//
extension CompanyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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

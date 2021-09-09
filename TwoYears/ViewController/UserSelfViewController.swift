//
//  UserSelfViewController.swift
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

class UserSelfViewController : UIViewController {
    
    let uid = Auth.auth().currentUser?.uid
    var companyId : String?
    var imageString : String?
    let firebaseCompany = Firestore.firestore().collection("Company1").document("Company1_document").collection("Company2").document("Company2_document").collection("Company3")
    @IBOutlet weak var imageBackView: UIView!
    @IBOutlet weak var imageButton: UIButton!
    @IBAction func imageTappedButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        print("bbbbb")
        self.present(imagePickerController, animated: true, completion: nil)
    }
    @IBOutlet weak var BackButton: UIButton!
    @IBAction func BackTappedButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var nameField: UITextField!
    @IBAction func nameTextField(_ sender: Any) {
    }
    @IBOutlet weak var kakuteiButton: UIButton!
    @IBAction func kakuteiTappedButton(_ sender: Any) {
        if let userNameString = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if imageString == nil || userNameString == "" {
                UIView.animate(withDuration: 0.5, delay: 0, animations: {
                    self.tyuuiLabel.alpha = 1
                }) { bool in
                    UIView.animate(withDuration: 0.5, delay: 3, animations: {
                        self.tyuuiLabel.alpha = 0
                })}
            } else {
                    let storageRef = Storage.storage().reference().child("Campany_Logo").child(imageString!)
                    let teamname = UserDefaults.standard.string(forKey: "color")
                    let userMyBrands = UserDefaults.standard.string(forKey: "userBrands")
                
                    guard let image = imageButton.imageView?.image  else { return }
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
                            let userDate = [
                                "JoindTime": FieldValue.serverTimestamp(),
                                "uid":uid!,
                                "userColor": teamname!,
                                "userBrands": userMyBrands!,
                                "userImage1": urlString,
                                "userName1": userNameString,
                                "belong": true,
                            ] as [String: Any]
                            Firestore.firestore().collection("users").document(uid!).setData(["userImage1": urlString,"userName1": userNameString,],merge: true)
                            if companyId != "none" {
                                firebaseCompany.document(companyId!).collection("members").document(uid!).setData(userDate)
                            }
                        }
                    }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBOutlet weak var tyuuiLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tyuuiLabel.text = "ユーザーロゴと名前の両方を入力してください"
        tyuuiLabel.alpha = 0
        
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
        
        imageButton.clipsToBounds = true
        imageButton.layer.cornerRadius = 100
        
        imageBackView.clipsToBounds = true
        imageBackView.layer.masksToBounds = false
        imageBackView.layer.cornerRadius = 100
        imageBackView.layer.shadowColor = UIColor.black.cgColor
        imageBackView.layer.shadowOffset = CGSize(width: 0, height: 3)
        imageBackView.layer.shadowOpacity = 0.7
        imageBackView.layer.shadowRadius = 5
        
        nameField.clipsToBounds = true
        nameField.layer.masksToBounds = false
        nameField.layer.cornerRadius = 30
        nameField.layer.shadowColor = UIColor.black.cgColor
        nameField.layer.shadowOffset = CGSize(width: 0, height: 3)
        nameField.layer.shadowOpacity = 0.7
        nameField.layer.shadowRadius = 5
        
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
extension UserSelfViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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

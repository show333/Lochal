//
//  backGroundSettingsVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/02/26.
//

import UIKit
import CropViewController
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Nuke

class backGroundSettingsVC:UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, CropViewControllerDelegate {
    
    var image:UIImage?
    var imageString:String?
    let db = Firestore.firestore()
    
    //imageViewをストーリーボード上に配置（適当なsize）
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var explainImageView: UIImageView!
    
    @IBOutlet weak var imageButton: UIButton!
    
    @IBAction func tappedImageButton(_ sender: Any) {
        setImagePicker()

    }
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func tappedSendButton(_ sender: Any) {
        if imageString != nil {
            backGroundFirestore()
            
        } else {
            labelAnimation()
        }
    }
    
    
    
  
    func backGroundFirestore() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(uid).collection("Profile").document("profile").getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                let ChildUserBackGround = document["ChildUserBackGround"] as? String ?? ""


                // Create a reference to the file to delete
                let storageRef = Storage.storage().reference()
                let desertRef = storageRef.child("User_BackGround").child(ChildUserBackGround)

//                 Delete the file
                desertRef.delete { error in
                  if let error = error {
                    // Uh-oh, an error occurred!
                  } else {
                    // File deleted successfully
                  }
                    
                }
                sendImage(userId:uid)


            } else {
                print("Document does not exist")
                
            }
        }
    }
    
    func sendImage(userId:String) {
        
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("User_BackGround").child(imageString!)
        guard let image = imageView.image else { return }
        guard let uploadImage = image.jpegData(compressionQuality: 0.5) else { return }
        
        
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
                
                UserDefaults.standard.set(urlString, forKey: "userBackGround")
                UserDefaults.standard.set(imageString, forKey: "ChildUserBackGround")

                db.collection("users").document(uid).collection("Profile").document("profile").setData(["userBackGround":urlString,"ChildUserBackGround":imageString ?? ""] as [String : Any],merge: true)
                db.collection("users").document(uid).setData(["userBackGround":urlString,"ChildUserBackGround":imageString ?? ""] as [String : Any],merge: true)
                
                
            }
        }
        self.navigationController?.popViewController(animated: true)

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
    
    func setImagePicker(){
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let pickerImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        print("トリトン")
        
        //CropViewControllerを初期化する。pickerImageを指定する。
        let cropController = CropViewController(croppingStyle: .default, image: pickerImage)
        
        cropController.delegate = self
        
        //AspectRatioのサイズをimageViewのサイズに合わせる。
        cropController.customAspectRatio = imageView.frame.size
        
        //今回は使わない、余計なボタン等を非表示にする。
        cropController.aspectRatioPickerButtonHidden = true
        cropController.resetAspectRatioEnabled = false
        cropController.rotateButtonsHidden = true
        
        //cropBoxのサイズを固定する。
        cropController.cropView.cropBoxResizeEnabled = false
        
        //pickerを閉じたら、cropControllerを表示する。
        picker.dismiss(animated: true) {
            self.present(cropController, animated: true, completion: nil)
        }
    }
    
    // メソッドの引数が、”didCropToImage”という方のDelegateメソッドを利用する様に変更する
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        //トリミング編集が終えたら、呼び出される。
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        //トリミングした画像をimageViewのimageに代入する。
        self.imageView.image = image
        imageString = NSUUID().uuidString

        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10

        setSwipeBack()

        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FbackGroundIcon.001.png?alt=media&token=080d7c22-2653-4a81-a810-e3e6490b72ad") {
            Nuke.loadImage(with: url, into: explainImageView)
        } else {
            explainImageView?.image = nil
        }
        explainImageView.clipsToBounds = true
        explainImageView.layer.cornerRadius = 20
        
        sendButton.backgroundColor = .white
        sendButton.clipsToBounds = true
        sendButton.layer.masksToBounds = false
        sendButton.layer.cornerRadius = 10
        sendButton.layer.shadowColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        sendButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        sendButton.layer.shadowOpacity = 0.7
        sendButton.layer.shadowRadius = 5
        
        self.warningLabel.alpha = 0
    }
}

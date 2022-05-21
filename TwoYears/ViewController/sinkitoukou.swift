//
//  sinkitoukou.swift
//  protain
//
//  Created by 平田翔大 on 2021/01/29.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import SwiftMoment
import Nuke
import Instructions
import ImageViewer
import AVFoundation
import AVKit

class sinkitoukou: UIViewController {
    
    let uid = UserDefaults.standard.string(forKey: "userId")
    let areaNameEn:String? = UserDefaults.standard.object(forKey: "areaNameEn") as? String
    let areaNameJa:String? = UserDefaults.standard.object(forKey: "areaNameJa") as? String
    let areaBlock:String? = UserDefaults.standard.object(forKey: "areaBlock") as? String
    let db = Firestore.firestore()
    
    var followerId : [String] = []
    var assetsType : String?
    var postType : String?
    var mediaUrl: URL?
    var durationTime:TimeInterval?
    var assetData: NSData?
    
    var userName: String? =  UserDefaults.standard.object(forKey: "userName") as? String
    var userImage: String? = UserDefaults.standard.object(forKey: "userImage") as? String
    var userFrontId: String? = UserDefaults.standard.object(forKey: "userFrontId") as? String
    
    var imagePC: UIImagePickerController! = UIImagePickerController()
    var imageString: String?
    var movieString: String?
    
    var alertController: UIAlertController!

    
    let coachMarksController = CoachMarksController()

    let textMask : Array = [
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth1.001.png?alt=media&token=bae3c928-485e-464f-ac00-35a97e03d681",//1
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth2.001.png?alt=media&token=8dab1e72-f1d7-4636-b203-37085b6a1a02",//2
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth3.001.png?alt=media&token=453af75e-4578-4fbd-abe7-cc0686a694ee",//3
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth4.001.png?alt=media&token=ffe5efc4-af99-423f-85e9-943c7ed00674",//4
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth5.001.png?alt=media&token=79a71066-96fb-42d0-a6b9-88a9edaea762",//5
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth6.001.png?alt=media&token=0a7254d8-01fd-4db0-82dd-573caecd3be7",//6
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth7.001.png?alt=media&token=6ec61c57-c5f2-4182-b81f-1c94e5830c01",//7
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth8.001.png?alt=media&token=894a2dc4-c3c8-4fe3-94c9-632a76921ad4",//8
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth10.001.png?alt=media&token=bc4d5271-11b0-499b-ad1e-88788329d417",//10
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth12.001.png?alt=media&token=5dd3e8a6-d265-4b1c-92ca-7de64c549de4",//12
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth13.001.png?alt=media&token=a875740c-c522-4087-8b7e-1e4d03ee392c",//13
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth14.001.png?alt=media&token=b73e6cb2-63f7-419a-bca9-4e79255c8cdf",//14
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth15.001.png?alt=media&token=46d8f2b2-feaa-4c38-ad5b-cd7924cf88f7",//15
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth16.001.png?alt=media&token=c5a3ea4a-59aa-41b4-9726-5453e19eca59",//16
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth17.001.png?alt=media&token=486ad9c8-f4ac-441f-ab70-b43feff85d99",//17
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth18.001.png?alt=media&token=b4a4525b-38ee-4842-a191-3fb49ec3b8e0",//18
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/TextMask%2Fmouth20.001.png?alt=media&token=e0693059-4e99-4378-a5cf-1b19854f30e0",//20
    ]
    
    @IBOutlet weak var confirmBackView: UIView!
    
    @IBOutlet weak var confirmBackButton: UIButton!
    
    @IBAction func confirmBackTappedButton(_ sender: Any) {
        confirmBackView.alpha = 0
    }
    
    @IBOutlet weak var recomendLabel: UILabel!
    @IBOutlet weak var confirmFrontView: UIView!
    
    @IBOutlet weak var confirmFrontViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmFrontImageView: UIImageView!
    
    @IBOutlet weak var confirmFrontButton: UIButton!
    
    @IBAction func confirmFrontTappedButton(_ sender: Any) {
        switch postType {
        case "newPost":
            sendFirestore(tapButton: "newPost")
            let vc = self.presentingViewController as! ViewController
            vc.lottieBool = true
            self.dismiss(animated: true, completion: nil)
        case "anonymous" :
            sendFirestore(tapButton: "anonymous")
            let vc = self.presentingViewController as! ViewController
            vc.lottieBool = true
            self.dismiss(animated: true, completion: nil)
        case "private" :
            sendFirestore(tapButton: "private")
            self.dismiss(animated: true, completion: nil)
        default :
            confirmBackView.alpha = 0
        }
    }
    @IBOutlet weak var confirmNameLabel: UILabel!
    
    @IBOutlet weak var confirmExplainLabel: UILabel!
    
    @IBOutlet weak var confirmPromoteLabel: UILabel!
    
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var ongakuLabel: UILabel!
    @IBOutlet weak var newPostButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var setImageView: UIImageView!
    
    @IBOutlet weak var setImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageSelectButton: UIButton!
    
    @IBAction func imageSelectTappedButton(_ sender: Any) {
        
        
        imagePC.sourceType = .photoLibrary
        imagePC.delegate = self
        imagePC.mediaTypes = ["public.image","public.movie"]
        present(imagePC, animated: true, completion: nil)
        
    }
    @IBOutlet weak var stampButton: UIButton!
    
    @IBAction func stampTappedButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "stampCollection", bundle: nil)
        let stampViewController = storyboard.instantiateViewController(withIdentifier: "stampViewController") as! stampViewController
        stampViewController.presentationController?.delegate = self
        stampViewController.transitionNewPostBool = true
        self.present(stampViewController, animated: true, completion: nil)
    }
    @IBOutlet weak var newPostBackView: UIView!
    @IBOutlet weak var newPostWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var newPostImageView: UIImageView!
    
    @IBOutlet weak var newPostLabel: UILabel!
    @IBAction func tappedSinkiButton(_ sender: Any) {
        
        if durationTime ?? 0 > 180.0 {
            alert(title: "動画の時間が長すぎます",
                  message: "180秒以下の動画のみアップロードできます")
            
        } else {
            
            if setImageView.image != nil {
                postType = "newPost"
                confirmStatus()
                
            } else {
                print("aaaa")
                self.coachMarksController.start(in: .currentWindow(of: self))
            }
        }
    }
    
    @IBOutlet weak var anonymousBackView: UIView!
    @IBOutlet weak var anonymousWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var annoymousImageView: UIImageView!
    
    @IBOutlet weak var anonymousLabel: UILabel!
    
    @IBOutlet weak var anonymousButton: UIButton!
    @IBAction func anonymousTappedButton(_ sender: Any) {
        
        if durationTime ?? 0 > 180.0 {
            alert(title: "動画の時間が長すぎます",
                  message: "180秒以下の動画のみアップロードできます")
            
        } else {
            if setImageView.image != nil {
                postType = "anonymous"
                confirmStatus()
                
            } else {
                print("aaaa")
                self.coachMarksController.start(in: .currentWindow(of: self))
            }
        }
    }
    
    @IBOutlet weak var privateBackView: UIView!
    @IBOutlet weak var privateWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var privateLabel: UILabel!
    @IBOutlet weak var privateImageView: UIImageView!
    @IBOutlet weak var privateButton: UIButton!
    
    @IBAction func privateTappedButton(_ sender: Any) {
        
        if durationTime ?? 0 > 180.0 {
            alert(title: "動画の時間が長すぎます",
                  message: "180秒以下の動画のみアップロードできます")
            
        } else {
            postType = "private"
            confirmStatus()
        }
    }
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBAction func closeTappedButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func confirmStatus() {
        confirmBackView.alpha = 0.95
        switch postType {
        case "newPost":
            confirmNameLabel.text = "newPost"
            confirmExplainLabel.text = "コネクトまたは近くにいる人に投稿します"
            confirmPromoteLabel.text = "↑タップで投稿"
            
            if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Settings%2FnewPost_Assets%2F_i_icon_02398_icon_023989_256.png?alt=media&token=e88ea22e-0d00-47f3-bce1-bcb9c41cfbb9") {
                Nuke.loadImage(with: url, into: confirmFrontImageView)
            } else {
                confirmFrontImageView?.image = nil
            }

        case "anonymous" :
            confirmNameLabel.text = "anonymous"
            confirmExplainLabel.text = "コネクトしているユーザーを優先して投稿します"
            confirmPromoteLabel.text = "↑タップで投稿"
            
            if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Settings%2FnewPost_Assets%2F_i_icon_03868_icon_0386810_256.png?alt=media&token=3bbd52c2-115d-481e-bb4a-e5a5b3da5723") {
                Nuke.loadImage(with: url, into: confirmFrontImageView)
            } else {
                confirmFrontImageView?.image = nil
            }
            
            
        case "private" :
            confirmNameLabel.text = "private"
            confirmExplainLabel.text = "コネクトしているユーザーに投稿します"
            confirmPromoteLabel.text = "↑タップで投稿"
            
            if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Settings%2FnewPost_Assets%2F_i_icon_05350_icon_053504_256.png?alt=media&token=e0a2936c-2e75-47b5-a6d2-1c944954828e") {
                Nuke.loadImage(with: url, into: confirmFrontImageView)
            } else {
                confirmFrontImageView?.image = nil
            }
            
        default :
            confirmBackView.alpha = 0
        }
    }
    
    func sendFirestore(tapButton:String) {
        if assetsType == "image" {
            
            guard let image = setImageView?.image  else { return }
            guard let uploadImage = image.jpegData(compressionQuality: 0.2) else { return }
            
            let fileName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("OutMemo_Post_Image").child(fileName)
            
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
                    imageString = urlString
                    print("urlString:", urlString)
                    switch tapButton {
                    case "newPost" :
                        sendMemoFireStore(imageAddress: fileName, movieAddress: "")
                        print("newPost")
                        
                    case "private":
                        privateSendMemo(imageAddress: fileName, movieAddress: "")
                        print("private")
                        
                    case "anonymous":
                        anonymousSendMemo(imageAddress: fileName, movieAddress: "")
                        print("anonymous")
                    default :
                        print("a")
                    }
                }
            }
        } else if assetsType == "movie" {
            
            guard let image = setImageView?.image  else { return }
            guard let uploadImage = image.jpegData(compressionQuality: 0.2) else { return }
            
            let imageFileName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("OutMemo_Post_Image").child(imageFileName)
            
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
                    imageString = urlString
                    
                    let movieFileName = NSUUID().uuidString + ".mp4"
                    let storageReference = Storage.storage().reference().child("OutMemo_Post_Image").child(movieFileName)
                    
                    
                    storageReference.putData(assetData! as Data, metadata: nil) { ( matadata, err) in
                        if let err = err {
                            print("firestrageへの情報の保存に失敗、、\(err)")
                            return
                        }
                        print("storageへの保存に成功!!")
                        storageReference.downloadURL { [self] (url, err) in
                            if let err = err {
                                print("firestorageからのダウンロードに失敗\(err)")
                                return
                            }
                            guard let urlString = url?.absoluteString else { return }
                            movieString = urlString
                            print("urlString:", urlString)
                            switch tapButton {
                            case "newPost" :
                                sendMemoFireStore(imageAddress: imageFileName, movieAddress: movieFileName)
                                print("newPost")
                                
                            case "private":
                                privateSendMemo(imageAddress: imageFileName, movieAddress: movieFileName)
                                print("private")
                                
                            case "anonymous":
                                anonymousSendMemo(imageAddress: imageFileName, movieAddress: movieFileName)
                                print("anonymous")
                            default :
                                print("a")
                            }
                        }
                    }
                }
            }
            
        }else {
            switch tapButton {
            case "newPost" :
                sendMemoFireStore(imageAddress:"", movieAddress: "")
                print("newPost")
                
            case "private":
                privateSendMemo(imageAddress:"", movieAddress: "")
                print("private")
                
            case "anonymous":
                anonymousSendMemo(imageAddress:"", movieAddress: "")
                print("anonymous")
                
            default :
                print("a")
                
            }
        }
    }

    private func sendMemoFireStore(imageAddress:String,movieAddress:String) {
        
        func randomString(length: Int) -> String {
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let memoId = randomString(length: 20)
        let thisisMessage = self.textView.text.trimmingCharacters(in: .newlines)
        
        let memoInfoDic = [
            "message" : thisisMessage as Any,
            "sendImageURL": imageString ?? "",
            "sendMovieURL": movieString ?? "",
            "documentId": memoId,

            "createdAt": FieldValue.serverTimestamp(),
            "textMask":textMask.randomElement() ?? "",
            "userId":uid,
            "imageAddress":imageAddress,
            "movieAddress":movieAddress,
            "assetsType": assetsType ?? "",
            "readLog": false,
            "privateBool":false,
            "anonymous":false,
            "admin": false,
            "delete": false,
        ] as [String: Any]
        
        let myPost = [
            "message" : thisisMessage as Any,
            "sendImageURL": imageString ?? "",
            "sendMovieURL": movieString ?? "",
            "documentId": memoId,
            "createdAt": FieldValue.serverTimestamp(),
            "textMask":textMask.randomElement() ?? "",
            "areaNameEn":areaNameEn ?? "",
            "areaNameJa":areaNameJa ?? "",
            "areaBlock":areaBlock ?? "",
            "userName":userName ?? "",
            "userImage":userImage ?? "",
            "userFrontId":userFrontId ?? "",
            "userId":uid,
            "imageAddress":imageAddress,
            "movieAddress":movieAddress,
            "assetsType": assetsType ?? "",
            "privateBool":false,
            "anonymous":false,
            "admin": false,
            "delete": false,
        ] as [String: Any]
        
        
        db.collection("users").document(uid).collection("MyPost").document(memoId).setData(myPost)
        
        db.collection("users").whereField("UEnterdBool", isEqualTo: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {

                if querySnapshot?.documents.count ?? 0 >= 1{
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let userId = document.data()["userId"] as? String ?? ""
                        db.collection("users").document(userId).collection("TimeLine").document(memoId).setData(memoInfoDic)

                    }
                }
            }
        }
        db.collection("AllOutMemo").document(memoId).setData(memoInfoDic)
    }
    
    private func privateSendMemo(imageAddress:String,movieAddress:String) {
        
        func randomString(length: Int) -> String {
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let memoId = randomString(length: 20)
        let thisisMessage = self.textView.text.trimmingCharacters(in: .newlines)
        let memoInfoDic = [
            "message" : thisisMessage as Any,
            "sendImageURL": imageString ?? "",
            "sendMovieURL": movieString ?? "",
            "documentId": memoId,
            "createdAt": FieldValue.serverTimestamp(),
            "textMask":textMask.randomElement() ?? "",
            "userId":uid,
            "imageAddress":imageAddress,
            "movieAddress":movieAddress,
            "assetsType": assetsType ?? "",
            "privateBool":true,
            "readLog": false,
            "anonymous":false,
            "admin": false,
            "delete": false,
        ] as [String: Any]
        
        let myPost = [
            "message" : thisisMessage as Any,
            "sendImageURL": imageString ?? "",
            "sendMovieURL": movieString ?? "",
            "documentId": memoId,
            "createdAt": FieldValue.serverTimestamp(),
            "textMask":textMask.randomElement() ?? "",
            "areaNameEn":areaNameEn ?? "",
            "areaNameJa":areaNameJa ?? "",
            "areaBlock":areaBlock ?? "",

            "userName":userName ?? "",
            "userImage":userImage ?? "",
            "userFrontId":userFrontId ?? "",
            "userId":uid,
            "imageAddress":imageAddress,
            "movieAddress":movieAddress,
            "assetsType": assetsType ?? "",
            "privateBool":true,
            "anonymous":false,
            "admin": false,
            "delete": false,
            
        ] as [String: Any]
        
        db.collection("users").document(uid).collection("TimeLine").document(memoId).setData(memoInfoDic)
        
        
        db.collection("users").document(uid).collection("Connections").whereField("status", isEqualTo: "accept").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if querySnapshot?.documents.count ?? 0 >= 1{
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let userId = document.data()["userId"] as? String ?? ""
                        db.collection("users").document(userId).collection("TimeLine").document(memoId).setData(memoInfoDic)
                    }
                }
            }
        }
        
        db.collection("AllOutMemo").document(memoId).setData(memoInfoDic)
        db.collection("users").document(uid).collection("TimeLine").document(memoId).setData(memoInfoDic)
        db.collection("users").document(uid).collection("MyPost").document(memoId).setData(myPost)
    }
    
    private func anonymousSendMemo(imageAddress:String,movieAddress:String) {
        
        func randomString(length: Int) -> String {
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let memoId = randomString(length: 20)
        let thisisMessage = self.textView.text.trimmingCharacters(in: .newlines)
        let memoInfoDic = [
            "message" : thisisMessage as Any,
            "sendImageURL": imageString ?? "",
            "sendMovieURL": movieString ?? "",
            "documentId": memoId,
            "createdAt": FieldValue.serverTimestamp(),
            "textMask":textMask.randomElement() ?? "",
            "userId":uid,
            "imageAddress":imageAddress,
            "movieAddress":movieAddress,
            "assetsType": assetsType ?? "",
            "privateBool":false,
            "readLog": false,
            "anonymous":true,
            "admin": false,
            "delete": false,
        ] as [String: Any]
        db.collection("users").document(uid).collection("TimeLine").document(memoId).setData(memoInfoDic)
        
        let myPost = [
            "message" : thisisMessage as Any,
            "sendImageURL": imageString ?? "",
            "sendMovieURL": movieString ?? "",
            "documentId": memoId,
            "createdAt": FieldValue.serverTimestamp(),
            "textMask":textMask.randomElement() ?? "",
            "areaNameEn":areaNameEn ?? "",
            "areaNameJa":areaNameJa ?? "",
            "areaBlock":areaBlock ?? "",
            "userName":userName ?? "",
            "userImage":userImage ?? "",
            "userFrontId":userFrontId ?? "",
            "userId":uid,
            "imageAddress":imageAddress,
            "movieAddress":movieAddress,
            "assetsType": assetsType ?? "",
            "privateBool":false,
            "anonymous":true,
            "admin": false,
            "delete": false,
        ] as [String: Any]
        
        db.collection("users").document(uid).collection("MyPost").document(memoId).setData(myPost)
        
        db.collection("users").whereField("UEnterdBool", isEqualTo: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {

                if querySnapshot?.documents.count ?? 0 >= 1{
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let userId = document.data()["userId"] as? String ?? ""
                        db.collection("users").document(userId).collection("TimeLine").document(memoId).setData(memoInfoDic)

                    }
                }
            }
        }
        db.collection("AllOutMemo").document(memoId).setData(memoInfoDic)
    }
    
    
    
    
    fileprivate let placeholder: String = "ポテチ食べたい\nコンビニの新作アイスめっちゃ美味い\nうちの猫めっちゃ可愛い\n授業,会社だるい\n布団から出られない\nなど" //プレイスホルダー
    fileprivate var maxWordCount: Int = 300 //最大文字数
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newPostLabel.font = UIFont(name: "03SmartFontUI", size: 14)
        anonymousLabel.font = UIFont(name: "03SmartFontUI", size: 14)
        privateLabel.font = UIFont(name: "03SmartFontUI", size: 14)
        recomendLabel.font = UIFont(name: "03SmartFontUI", size: 12)

        
        confirmBackView.alpha = 0

        self.coachMarksController.dataSource = self
        
        let statusBarHeight = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
       // ナビゲーションバーの高さを取得
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        
        let height = UIScreen.main.bounds.size.height - navigationBarHeight - statusBarHeight
        let width = UIScreen.main.bounds.size.width
        let widthConstraint = width/3 - 10
        
        privateWidthConstraint.constant = widthConstraint
        anonymousWidthConstraint.constant = widthConstraint
        newPostWidthConstraint.constant = widthConstraint
        
        confirmFrontViewWidthConstraint.constant = width/3
        confirmFrontView.clipsToBounds = true
        confirmFrontView.layer.cornerRadius = width/24
        
//        confirmFrontView.backgroundColor = .gray
           confirmFrontView.clipsToBounds = true
//           confirmFrontView.layer.cornerRadius = 10
           confirmFrontView.layer.masksToBounds = false
           confirmFrontView.layer.shadowColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
           confirmFrontView.layer.shadowOffset = CGSize(width: 0, height: 3)
           confirmFrontView.layer.shadowOpacity = 0.7
           confirmFrontView.layer.shadowRadius = 5
        
//        setImageView = scalea
        
        // newPostViewHeight = 60 + 10
        // close 25 + 30
        // explain label 20 + 20
        // count 20 + 20
        
        let editHeight = height - 215
        
        textViewHeightConstraint.constant = editHeight/3.5
        setImageViewHeightConstraint.constant = editHeight/3
        
        setImageView.isUserInteractionEnabled = true
        setImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setImageViewTapped(_:))))
        
        newPostBackView.backgroundColor = .gray
        newPostBackView.clipsToBounds = true
        newPostBackView.layer.cornerRadius = 10
        newPostBackView.layer.masksToBounds = false
        newPostBackView.layer.shadowColor = UIColor.clear.cgColor
        newPostBackView.layer.shadowOffset = CGSize(width: 0, height: 3)
        newPostBackView.layer.shadowOpacity = 0.7
        newPostBackView.layer.shadowRadius = 5

        
        anonymousBackView.backgroundColor = .gray
        anonymousBackView.clipsToBounds = true
        anonymousBackView.layer.cornerRadius = 10
        anonymousBackView.layer.masksToBounds = false
        anonymousBackView.layer.shadowColor = UIColor.clear.cgColor
        anonymousBackView.layer.shadowOffset = CGSize(width: 0, height: 3)
        anonymousBackView.layer.shadowOpacity = 0.7
        anonymousBackView.layer.shadowRadius = 5

        privateBackView.backgroundColor = .gray
        privateBackView.clipsToBounds = true
        privateBackView.layer.cornerRadius = 10
        privateBackView.layer.masksToBounds = false
        privateBackView.layer.shadowColor = UIColor.clear.cgColor
        privateBackView.layer.shadowOffset = CGSize(width: 0, height: 3)
        privateBackView.layer.shadowOpacity = 0.7
        privateBackView.layer.shadowRadius = 5

                
        //ポスト
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Settings%2FnewPost_Assets%2F_i_icon_02398_icon_023989_256.png?alt=media&token=e88ea22e-0d00-47f3-bce1-bcb9c41cfbb9") {
            Nuke.loadImage(with: url, into: newPostImageView)
        } else {
            newPostImageView?.image = nil
        }

        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Settings%2FnewPost_Assets%2F_i_icon_03868_icon_0386810_256.png?alt=media&token=3bbd52c2-115d-481e-bb4a-e5a5b3da5723") {
            Nuke.loadImage(with: url, into: annoymousImageView)
        } else {
            annoymousImageView?.image = nil
        }
        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Settings%2FnewPost_Assets%2F_i_icon_05350_icon_053504_256.png?alt=media&token=e0a2936c-2e75-47b5-a6d2-1c944954828e") {
            Nuke.loadImage(with: url, into: privateImageView)
        } else {
            privateImageView?.image = nil
        }

        
        if UserDefaults.standard.bool(forKey: "OutMemoInstract") != true{
            ongakuLabel.text = "初めての投稿をしてみましょう！\n投稿はコネクトをしたユーザーに\n公開されます"


        } else {
            ongakuLabel.text = "だらけてるほど良き"
        }
        
        self.textView.delegate = self
        newPostButton.isEnabled = false
        anonymousButton.isEnabled = false
        privateButton.isEnabled = false
        newPostButton.backgroundColor = .clear
        textView.textColor = .gray
        textView.text = placeholder
        textView.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 8
        newPostButton.clipsToBounds = true
        newPostButton.layer.cornerRadius = 5
        wordCountLabel.text = "300文字まで"
    }
    
    @objc func setImageViewTapped(_ sender: UITapGestureRecognizer) {
        
        if assetsType == "image" {
        let viewController = GalleryViewController(
            startIndex: 0,
            itemsDataSource: self,
            displacedViewsDataSource: self,
            configuration: [
                .deleteButtonMode(.none),
                .thumbnailsButtonMode(.none)
            ])
            self.presentImageGallery(viewController)
        } else if assetsType == "movie" {
            
            playMovieFromUrl(movieUrl: mediaUrl)
        }
    }
    
    func playMovieFromUrl(movieUrl: URL?) {
        if let movieUrl = movieUrl {
            let videoPlayer = AVPlayer(url: movieUrl)
            let playerController = AVPlayerViewController()
            playerController.player = videoPlayer
            self.present(playerController, animated: true, completion: {
                videoPlayer.play()
            })
        } else {
            print("cannot play")
        }
    }
    
    func playMovieFromPath(moviePath: String?) {
        if let moviePath = moviePath {
            self.playMovieFromUrl(movieUrl: URL(fileURLWithPath: moviePath))
        } else {
            print("no such file")
        }
    }
    
    func alert(title:String, message:String) {
        alertController = UIAlertController(title: title,
                                   message: message,
                                   preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                       style: .default,
                                       handler: nil))
        present(alertController, animated: true)
    }
}
extension sinkitoukou: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let existingLines = textView.text.components(separatedBy: .newlines)//既に存在する改行数
        let newLines = text.components(separatedBy: .newlines)//新規改行数
        let linesAfterChange = existingLines.count + newLines.count - 1 //最終改行数。-1は編集したら必ず1改行としてカウントされるから。
        return linesAfterChange <= 30 && textView.text.count + (text.count - range.length) <= maxWordCount
    }
    func textViewDidChange(_ textView: UITextView) {
        let existingLines = textView.text.components(separatedBy: .newlines)//既に存在する改行数
        let textwhite = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)//空白、改行のみを防ぐ
        if textwhite.isEmpty {
            newPostBackView.backgroundColor = .gray
            newPostButton.isEnabled = false
            newPostBackView.layer.shadowColor = UIColor.clear.cgColor
            
            anonymousBackView.backgroundColor = .gray
            anonymousButton.isEnabled = false
            anonymousBackView.layer.shadowColor = UIColor.clear.cgColor
            
            privateBackView.backgroundColor = .gray
            privateButton.isEnabled = false
            privateBackView.layer.shadowColor = UIColor.clear.cgColor
            
        } else {
            newPostButton.isEnabled = true
            newPostBackView.backgroundColor = #colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 1)

            newPostBackView.layer.shadowColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
 
            
            anonymousButton.isEnabled = true
            anonymousBackView.backgroundColor = #colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 1)
            anonymousBackView.layer.shadowColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
     
            
            privateButton.isEnabled = true
            privateBackView.backgroundColor = #colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 1)
            privateBackView.layer.shadowColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
            
            
            if setImageView.image != nil {
                anonymousBackView.backgroundColor = #colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 1)
                newPostBackView.backgroundColor = #colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 1)

            } else {
                anonymousBackView.backgroundColor = .gray
                newPostBackView.backgroundColor = .gray

            }
        }
        if existingLines.count <= 30 {
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


extension sinkitoukou: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        anonymousBackView.backgroundColor = .gray
    
        
        let textwhite = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)//空白、改行のみを防ぐ
        if textwhite == "" || textwhite == "ポテチ食べたい\nコンビニの新作アイスめっちゃ美味い\nうちの猫めっちゃ可愛い\n授業,会社だるい\n布団から出られない\nなど" {
            anonymousBackView.backgroundColor = .gray
        } else {
            if setImageView.image != nil {
                anonymousBackView.backgroundColor = #colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 1)
                newPostBackView.backgroundColor = #colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 1)

            }
        }
        
        if let url = URL(string:imageString ?? "") {
            Nuke.loadImage(with: url, into: setImageView)
        } else {
            setImageView?.image = nil
        }
    }
}
//            .scaleAspectFit
extension sinkitoukou: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.mediaType] as! String == "public.image" {
            assetsType = "image"
            let originalImage = info[.originalImage] as? UIImage
            setImageView.image = originalImage
        } else if info[.mediaType] as! String == "public.movie" {
            assetsType = "movie"
            let mediaURL = info[.mediaURL] as? URL
            self.mediaUrl = mediaURL
            assetData = NSData(contentsOf: mediaURL!)
            
            let video = AVURLAsset(url: mediaURL!)
            durationTime = TimeInterval(round(Float(video.duration.value) / Float(video.duration.timescale)))
            print("お合いsjエフォイアジェsf",durationTime ?? 0)
            thumnailImageForFileUrl(fileUrl:mediaURL!)
        }
        
        let mediaURL = info[.mediaURL] as? URL
        print(mediaURL ?? "")
        
        imagePC.dismiss(animated: true)
        
        let textwhite = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let textHolder = "ポテチ食べたい\nコンビニの新作アイスめっちゃ美味い\nうちの猫めっちゃ可愛い\n授業,会社だるい\n布団から出られない\nなど"
        print("おいさジェフォイじゃせ",textwhite)

        if textwhite == "" || textwhite == textHolder{
            print("おいfjアセおい")
        } else {
            
            anonymousBackView.backgroundColor = #colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 1)
            newPostBackView.backgroundColor = #colorLiteral(red: 0.9999018312, green: 1, blue: 0.9998798966, alpha: 1)
        }
    }
    
    func generateDuration(timeInterval: TimeInterval) -> String {
        
        let min = Int(timeInterval / 60)
        let sec = Int(round(timeInterval.truncatingRemainder(dividingBy: 60)))
        let duration = String(format: "%02d:%02d", min, sec)
        return duration
    }
    
    func thumnailImageForFileUrl(fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do {
            let thumnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1,timescale: 60), actualTime: nil)
            print("サムネイルの切り取り成功！")
            let uiImage = UIImage(cgImage: thumnailCGImage)
            setImageView.image = uiImage
            return UIImage(cgImage: thumnailCGImage, scale: 0, orientation: .right)
        }catch let err{
            print("エラー\(err)")
        }
        return nil
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
//MARK: Instructions
extension sinkitoukou: CoachMarksControllerDataSource, CoachMarksControllerDelegate {

    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        //基本的にはチュートリアルの対象にしたいボタンやビューをチュートリアルの順にArrayに入れ、indexで指定する形がいいかなと思います(もっといい方法があったら教えてください)
        let highlightViews: Array<UIView> = [stampButton]
        //(hogeLabelが最初、次にfugaButton,最後にpiyoSwitchという流れにしたい)

        //チュートリアルで使うビューの中からindexで何ステップ目かを指定
        return coachMarksController.helper.makeCoachMark(for: highlightViews[index])
    }
    
    //ここにはあとで色々追加していく
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        /// 自分の設定したいステップ数に合わせて変更してください
        return 1
    }
    
    func coachMarksController(
        _ coachMarksController: CoachMarksController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMark
    ) -> (bodyView: UIView & CoachMarkBodyView, arrowView: (UIView & CoachMarkArrowView)?) {

        //吹き出しのビューを作成します
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true,    //三角の矢印をつけるか
            arrowOrientation: coachMark.arrowOrientation    //矢印の向き(吹き出しの位置)
        )

        //index(ステップ)によって表示内容を分岐させます
        switch index {
        case 0:    //hogeLabel
            coachViews.bodyView.hintLabel.text = "この投稿をするには\nスタンプや画像を一緒にしてください"
            coachViews.bodyView.nextLabel.text = "OK!"
        
        default:
            break
        
        }
        
        //その他の設定が終わったら吹き出しを返します
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }

}
extension sinkitoukou: GalleryItemsDataSource {
    func itemCount() -> Int {
        return 1
    }

    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return GalleryItem.image { $0(self.setImageView.image!) }
    }
}

// MARK: GalleryDisplacedViewsDataSource
extension sinkitoukou: GalleryDisplacedViewsDataSource {
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        return setImageView
    }
}

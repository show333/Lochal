//
//  detailPostVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/02/06.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import ImageViewer
import Nuke

class detailPostVC:UIViewController {
    
//    var postInfo: PostInfo?
    var sendedBool:Bool?
    var postInfoTitle: String?
    var postInfoImage: String?
    var postInfoDoc: String?
    var profileUserId:String?
    var userId: String?
    var userName: String?
    var userImage: String?
    var userFrontId: String?
    let db = Firestore.firestore()
    let filterArray = ["CIPhotoEffectMono",
                       "CIPhotoEffectChrome",
                       "CIPhotoEffectFade",
                       "CIPhotoEffectInstant",
                       "CIPhotoEffectNoir",
                       "CIPhotoEffectProcess",
                       "CIPhotoEffectTonal",
                       "CIPhotoEffectTransfer",
                       "CISepiaTone",
                       "original"
     ]
//    CIPhotoEffectInstant
    var filterNumber = 0
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var userFrontIdLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
//    @IBOutlet weak var userImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var effectButton: UIButton!
    
    @IBAction func effectTappedButton(_ sender: Any) {
        
        //UIImageViewのimageをオプショナルバインディングでアンラップし、imageに代入
              if let image = postImageView.image {
                 //フィルター名を指定
                 let filterName = filterArray[filterNumber]
                  //ボタンを押すたびにフィルター内容が変わるように設定
                  filterNumber += 1
      //配列内の要素数とSelectNumberの値が等しければ、0を代入して初期化
                  if filterNumber == filterArray.count {
                      filterNumber = 0
                  }
      //画像の回転角度をを取得
                  let rotate = image.imageOrientation
                 //UIImage形式の画像をCIImage形式に変更し、加工可能な状態にする。
                  let inputImage = CIImage(image: image)
                 //フィルターの種類を引数で指定された種類を指定してCIFilterのインスタンスを取得
                  guard let effectFilter = CIFilter(name: filterName) else{
                      return
                  }
      //エフェクトのパラメータを初期化
                  effectFilter.setDefaults()
                 //インスタンスにエフェクトする画像を指定
                  effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
      //エフェクト後のCIImage形式の画像を取り出す
                  guard let outputImage = effectFilter.outputImage else{
                      return
                  }
                // CIContextのインスタンスを取得
                  let ciContext = CIContext(options: nil)
                // エフェクト後の画像をCIContext上に描画し、結果をcgImageとしてCGImage形式の画像を取得
                  guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else {
                      return
                  }
      //エフェクト後の画像をCGImage形式からUIImage形式に変更、回転角度を指定、ImageViewに表示
                  
                  if let url = URL(string:postInfoImage ?? "") {
                      Nuke.loadImage(with: url, into: postImageView)
                  } else {
                      postImageView.image = nil
                  }
                  DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                      self.postImageView.image = UIImage(cgImage: cgImage, scale: 1.0, orientation: rotate)
                  }
              }
    }

    @IBOutlet weak var TPButton: UIButton!
    
    @IBAction func TPTappedButton(_ sender: Any) {
        alertAction()
    }
    
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var transitionReMemoBackView: UIView!
    @IBOutlet weak var transitionReMemoConstraint: NSLayoutConstraint!
    @IBOutlet weak var transitionReMemoWidth: NSLayoutConstraint!
    @IBOutlet weak var trainsitionReMemoButton: UIButton!
    
    @IBAction func transitionTappedReMemoButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "ReMemoPost", bundle: nil)
        let ReMemoPostVC = storyboard.instantiateViewController(withIdentifier: "ReMemoPostVC") as! ReMemoPostVC
        ReMemoPostVC.postInfoTitle = postInfoTitle
        ReMemoPostVC.postInfoImage = postInfoImage
        ReMemoPostVC.userId = self.userId
        ReMemoPostVC.userFrontId = self.userFrontId
        ReMemoPostVC.userName = self.userName
        ReMemoPostVC.userImage = self.userImage

        self.present(ReMemoPostVC, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var storyShareLabel: UILabel!
    @IBOutlet weak var storyShareBackView: UIView!
    @IBOutlet weak var storyShareImageView: UIImageView!
    @IBOutlet weak var storyShareConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var storyShareWidth: NSLayoutConstraint!
    @IBOutlet weak var storyShareButton: UIButton!
    
    @IBAction func tappedStoryShareButton(_ sender: Any) {
        TPButton.alpha = 0
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        shareStickerImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        effectButton.alpha = 0
        
        let safeAreaWidth = UIScreen.main.bounds.size.width

        backGroundView.clipsToBounds = true
        backGroundView.layer.cornerRadius = 15
        backGroundView.backgroundColor = .clear
        
        titleLabel.font = UIFont(name:"03SmartFontUI", size:22)
        
        transitionReMemoBackView.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        transitionReMemoBackView.clipsToBounds = true
        transitionReMemoBackView.layer.masksToBounds = false
        transitionReMemoBackView.layer.cornerRadius = safeAreaWidth/12
        transitionReMemoBackView.layer.shadowColor = UIColor.black.cgColor
        transitionReMemoBackView.layer.shadowOffset = CGSize(width: 0, height: 3)
        transitionReMemoBackView.layer.shadowOpacity = 0.7
        transitionReMemoBackView.layer.shadowRadius = 5
        
        storyShareBackView.backgroundColor = .clear
        storyShareBackView.clipsToBounds = true
        storyShareBackView.layer.masksToBounds = false
        storyShareBackView.layer.cornerRadius = 10
        storyShareBackView.layer.shadowColor = #colorLiteral(red: 1, green: 0.2916699052, blue: 0.7794274092, alpha: 1)
        storyShareBackView.layer.shadowOffset = CGSize(width: 0, height: 3)
        storyShareBackView.layer.shadowOpacity = 0.7
        storyShareBackView.layer.shadowRadius = 5
        

        transitionReMemoWidth.constant = safeAreaWidth/6
        transitionReMemoConstraint.constant = safeAreaWidth/4
        storyShareWidth.constant = safeAreaWidth/6
        storyShareConstraint.constant = safeAreaWidth/4
        
//        trainsitionReMemoButton.titleLabel?.adjustsFontSizeToFitWidth = true
        memoLabel.font = UIFont(name: "03SmartFontUI", size: 13)
//        storyShareButton.titleLabel?.adjustsFontSizeToFitWidth = true
        storyShareLabel.font = UIFont(name: "03SmartFontUI", size: 11)


        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
//        if uid == profileUserId {
            trainsitionReMemoButton.alpha = 1
            storyShareButton.alpha = 1
//        } else {
//            trainsitionReMemoButton.alpha = 0
//            storyShareButton.alpha = 0
//        }
        
        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FInstagram_Glyph_Gradient_RGB.png?alt=media&token=3d86956e-4d3e-46c3-9777-891495f5cf84") {
            Nuke.loadImage(with: url, into: storyShareImageView)
        } else {
            storyShareImageView.image = nil
        }
        
        if uid == userId || uid == profileUserId {
             TPButton.alpha = 1

         } else {
             TPButton.alpha = 0
         }
        backGroundView.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 0.9)

        
        setSwipeBack()
        if let url = URL(string:postInfoImage ?? "") {
            Nuke.loadImage(with: url, into: postImageView)
        } else {
            postImageView.image = nil
        }
        
        let postTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(postTap(_:)))
        postImageView.addGestureRecognizer(postTapGesture)
        postImageView.isUserInteractionEnabled = true
        
        postImageView.clipsToBounds = true
        postImageView.layer.cornerRadius = 16
        
        
        
        let userTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(userTap(_:)))
        
        userImageView.addGestureRecognizer(userTapGesture)
        userImageView.isUserInteractionEnabled = true

        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 30
        
        titleLabel.text = postInfoTitle
        getUserInfo()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("aaa")
    }
    
    
    
    func shareStickerImage() {
        if UIApplication.shared.canOpenURL(URL(string: "instagram-stories://share")!) {
            // xxxアプリがインストールされている
            let image = backGroundView.asImage()
            let backGroundImage:UIImage = UIImage(url:UserDefaults.standard.string(forKey: "userBackGround") ?? "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/backGroound%2FstoryBackGroundView.png?alt=media&token=0daf6ab0-0a44-4a65-b3aa-68058a70085d")
            let url = URL(string: "instagram-stories://share")
            let items: NSArray = [["com.instagram.sharedSticker.stickerImage": image,
                                   "com.instagram.sharedSticker.backgroundImage": backGroundImage,
                                   "com.instagram.sharedSticker.backgroundTopColor": "#00ffdf",
                                   "com.instagram.sharedSticker.backgroundBottomColor": "#ff00ff"]]
            UIPasteboard.general.setItems(items as! [[String : Any]], options: [:])
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            // xxxアプリがインストールされていない
            // ボタンを押下した時にアラートを表示するメソッド

                // ① UIAlertControllerクラスのインスタンスを生成
                // タイトル, メッセージ, Alertのスタイルを指定する
                // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
            let alert: UIAlertController = UIAlertController(title: "Instagram", message: "をインストールしてください", preferredStyle:  UIAlertController.Style.alert)

                // ② Actionの設定
                // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
                // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
                // OKボタン
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    print("OK")
                })

                // ③ UIAlertControllerにActionを追加
                alert.addAction(defaultAction)

                // ④ Alertを表示
            present(alert, animated: true, completion: nil)
            }
        
        

    }
    
    func getUserInfo(){
        db.collection("users").document(userId ?? "").collection("Profile").document("profile").getDocument { [self](document, error) in
            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                

                
                let userNameString = document["userName"] as? String ?? ""
                let userImageString = document["userImage"] as? String ?? ""
                let userFrontIdString = document["userFrontId"] as? String ?? ""
                
                userName = userNameString
                userImage = userImageString
                userFrontId = userFrontIdString
                
                
                
                userNameLabel.text = userNameString
                userFrontIdLabel.text = userFrontIdString
                if let url = URL(string:userImageString) {
                    Nuke.loadImage(with: url, into: userImageView)
                } else {
                    userImageView.image = nil
                }
                
            }
        }
    }
    @objc private func postTap(_ sender: UITapGestureRecognizer) {
        let viewController = GalleryViewController(
            startIndex: 0,
            itemsDataSource: self,
            displacedViewsDataSource: self,
            configuration: [
                .deleteButtonMode(.none),
                .thumbnailsButtonMode(.none)
            ])
        presentImageGallery(viewController)
    }
    
    @objc private func userTap(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
        let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        
        ProfileVC.userId = userId
        ProfileVC.userName = userName
        ProfileVC.userImage = userImage
        ProfileVC.userFrontId = userFrontId
        ProfileVC.cellImageTap = true
        
        navigationController?.pushViewController(ProfileVC, animated: true)
        
    }
    
    func alertAction() {
        let alertController:UIAlertController =
        UIAlertController(title:"削除しますか？",
                          message: "投稿をしたユーザーと受け付けたユーザーのみ選択可能です",
                          preferredStyle: .actionSheet)

        
        // Destructive のaction
        let destructiveAction:UIAlertAction =
        UIAlertAction(title: "削除",
                      style: .destructive,
                      handler:{
            (action:UIAlertAction!) -> Void in
            self.deleteDoc()
        })
        
        // Cancel のaction
        let cancelAction:UIAlertAction =
        UIAlertAction(title: "Cancel",
                      style: .cancel,
                      handler:{
            (action:UIAlertAction!) -> Void in
            // 処理
        })
        
        // actionを追加
        alertController.addAction(cancelAction)
        alertController.addAction(destructiveAction)
    

        alertController.popoverPresentationController?.sourceView = self.view

        let screenSize = UIScreen.main.bounds
        alertController.popoverPresentationController?.sourceRect=CGRect(x:screenSize.size.width/2,y:screenSize.size.height,width:0,height:0)
        
        // UIAlertControllerの起動
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteDoc(){
        db.collection("users").document(profileUserId ?? "").collection("SendedPost").document(postInfoDoc ?? "").delete()
        self.navigationController?.popToRootViewController(animated: true)
//        // Create a reference to the file to delete
//        let storageRef = Storage.storage().reference().child("Unit_Post_Image").child(postInfo?.postImage ?? "")
//        // Delete the file
//        storageRef.delete { error in
//          if let error = error {
//            // Uh-oh, an error occurred!
//              print(error)
//          } else {
//            // File deleted successfully
//          }
//        }
            
    }
    
}
extension detailPostVC: GalleryItemsDataSource {
    func itemCount() -> Int {
        return 1
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return GalleryItem.image { $0(self.postImageView.image!) }
    }
}
extension detailPostVC: GalleryDisplacedViewsDataSource {
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        return postImageView
    }
}
extension UIView {
    //UIViewをUIImageに変換するコード
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

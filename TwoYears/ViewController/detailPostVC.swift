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
    
    var postInfo: PostInfo?
    
    var sendedBool:Bool?
    var postInfoTitle: String?
    var postInfoImage: String?
    var postInfoDoc: String?
    var profileUserId:String?
    var postUserId: String?
    var postTextFontName: String?
    var postHexColor: String?
    var userName: String?
    var userImage: String?
    var userFrontId: String?
    var originImage : UIImage?
    var backHexColor : String?
    var imageAddress:String?
    var backTapCount = 0

    
    let db = Firestore.firestore()
    let filterArray = [
        "CIPhotoEffectInstant",
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTransfer",
        "CIPhotoEffectMono",
        "CIPhotoEffectNoir",
        "CIPhotoEffectTonal",
        "CISepiaTone",
        "original",
    ]
    
    let filterNameArray = [
        "Instant",
        "Chrome",
        "Fade",
        "Process",
        "Transfer",
        "Mono",
        "Noir",
        "Tonal",
        "SepiaTone",
        "original",
    ]
    
    //    CIPhotoEffectInstant
    var filterNumber = 0
    
    
    @IBOutlet weak var backGroundImageView: UIImageView!
    
    
    @IBOutlet weak var backGroundView: UIView!
    
    
    @IBOutlet weak var backGroundViewUpConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backGroundViewDownConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var userFrontIdLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    //    @IBOutlet weak var userImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var postImageViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var postImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleWithFontLabel: UILabel!

    @IBOutlet weak var TPButton: UIButton!
    
    @IBAction func TPTappedButton(_ sender: Any) {
        alertAction()
    }
    
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var transitionReMemoBackView: UIView!
    
    @IBOutlet weak var transitionReMemoFrontView: UIView!
    @IBOutlet weak var transitionReMemoFrontViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var transitionReMemoConstraint: NSLayoutConstraint!
    @IBOutlet weak var transitionReMemoWidth: NSLayoutConstraint!
    @IBOutlet weak var trainsitionReMemoButton: UIButton!
    
    @IBAction func transitionTappedReMemoButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "ReMemoPost", bundle: nil)
        let ReMemoPostVC = storyboard.instantiateViewController(withIdentifier: "ReMemoPostVC") as! ReMemoPostVC
        ReMemoPostVC.postInfoTitle = postInfoTitle
        ReMemoPostVC.postInfoImage = postInfoImage
        ReMemoPostVC.userId = self.postUserId
        ReMemoPostVC.userFrontId = self.userFrontId
        ReMemoPostVC.userName = self.userName
        ReMemoPostVC.userImage = self.userImage
        ReMemoPostVC.hexColor = self.postHexColor
        ReMemoPostVC.fontName = self.postTextFontName
        ReMemoPostVC.backHexColor = self.backHexColor

        self.present(ReMemoPostVC, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var storyShareLabel: UILabel!
    @IBOutlet weak var storyShareBackView: UIView!
    @IBOutlet weak var storyShareImageView: UIImageView!
    @IBOutlet weak var storyShareImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var storyShareConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var storyShareWidth: NSLayoutConstraint!
    @IBOutlet weak var storyShareButton: UIButton!
    
    @IBAction func tappedStoryShareButton(_ sender: Any) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        shareStickerImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterLabel.alpha = 0
        
        let safeAreaWidth = UIScreen.main.bounds.size.width
        
        backGroundView.clipsToBounds = true
        backGroundView.layer.cornerRadius = 15
        backGroundView.backgroundColor = .clear
        
        let storyboard = UIStoryboard.init(name: "FontCollection", bundle: nil)
        let FontCollectionVC = storyboard.instantiateViewController(withIdentifier: "FontCollectionVC") as! FontCollectionVC
        
        let fontBool = FontCollectionVC.fontArray.contains(postTextFontName ?? "")
        let removeSpacePostTitle = postInfoTitle?.removeAllWhitespacesAndNewlines
        
        if removeSpacePostTitle?.isAlphanumericAll() == false {
            titleLabel.font = UIFont(name:"03SmartFontUI", size:safeAreaWidth/18)
            titleWithFontLabel.font = UIFont(name:"03SmartFontUI", size:safeAreaWidth/5)
            
        } else {
            if fontBool == false {
                titleLabel.font = UIFont(name:"Southpaw", size:safeAreaWidth/18)
                titleWithFontLabel.font = UIFont(name:"Southpaw", size:safeAreaWidth/5)
                
            } else {
                titleLabel.font = UIFont(name:postTextFontName ?? "", size:safeAreaWidth/18)
                titleWithFontLabel.font = UIFont(name:postTextFontName ?? "", size:safeAreaWidth/5)
                
            }
        }
        
        
        titleLabel.text = postInfoTitle
        titleWithFontLabel.text = postInfoTitle
        let transScale = CGAffineTransform(rotationAngle: CGFloat(270))
        titleWithFontLabel.transform = transScale
        
        
        
        if postHexColor == "" {
            titleLabel.textColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        } else {
            let UITextColor = UIColor(hex: postHexColor ?? "")
            titleLabel.textColor = UITextColor
            titleWithFontLabel.textColor = UITextColor
        }
        
        
        transitionReMemoBackView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        transitionReMemoBackView.clipsToBounds = true
        transitionReMemoBackView.layer.masksToBounds = false
        transitionReMemoBackView.layer.cornerRadius = safeAreaWidth/16
        transitionReMemoBackView.layer.shadowColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        transitionReMemoBackView.layer.shadowOffset = CGSize(width: 0, height: 3)
        transitionReMemoBackView.layer.shadowOpacity = 0.7
        transitionReMemoBackView.layer.shadowRadius = 5
        
        transitionReMemoFrontView.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        transitionReMemoFrontView.clipsToBounds = true
        transitionReMemoFrontView.layer.cornerRadius = safeAreaWidth/18
        
        
        storyShareBackView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        storyShareBackView.clipsToBounds = true
        storyShareBackView.layer.masksToBounds = false
        storyShareBackView.layer.cornerRadius = safeAreaWidth/16
        storyShareBackView.layer.shadowColor = #colorLiteral(red: 0.8880136013, green: 0.1003531218, blue: 0.6296043992, alpha: 1)
        storyShareBackView.layer.shadowOffset = CGSize(width: 0, height: 3)
        storyShareBackView.layer.shadowOpacity = 0.7
        storyShareBackView.layer.shadowRadius = 5
        
        transitionReMemoFrontViewConstraint.constant = safeAreaWidth/9
        transitionReMemoWidth.constant = safeAreaWidth/5
        transitionReMemoConstraint.constant = safeAreaWidth/4.5
        storyShareWidth.constant = safeAreaWidth/5
        storyShareConstraint.constant = safeAreaWidth/4.5
        storyShareImageConstraint.constant = safeAreaWidth/10
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        //        if uid == profileUserId {
        trainsitionReMemoButton.alpha = 1
        storyShareButton.alpha = 1
        //        } else {
        //            trainsitionReMemoButton.alpha = 0
        //            storyShareButton.alpha = 0
        //        }
        
        let backGroundString = UserDefaults.standard.string(forKey: "userBackGround") ?? "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/backGroound%2FstoryBackGroundView.png?alt=media&token=0daf6ab0-0a44-4a65-b3aa-68058a70085d"
        if let url = URL(string:backGroundString) {
            Nuke.loadImage(with: url, into: backGroundImageView)
        } else {
            backGroundImageView?.image = nil
        }
        
        if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FInstagram_Glyph_Gradient_RGB.png?alt=media&token=3d86956e-4d3e-46c3-9777-891495f5cf84") {
            Nuke.loadImage(with: url, into: storyShareImageView)
        } else {
            storyShareImageView.image = nil
        }
        
        if uid == postUserId || uid == profileUserId {
            TPButton.alpha = 1
            transitionReMemoBackView.alpha = 1
            storyShareBackView.alpha = 1
            
        } else {
            TPButton.alpha = 0
            transitionReMemoBackView.alpha = 0
            storyShareBackView.alpha = 0
        }
        
        setSwipeBack()
        
        backGroundView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.900812162)
        backHexColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.900812162).toHexString()
        userFrontIdLabel.textColor = .lightGray
        userFrontIdLabel.font = UIFont.italicSystemFont(ofSize: safeAreaWidth/20)
        
        
        if let url = URL(string:postInfoImage ?? "") {
            Nuke.loadImage(with: url, into: postImageView)
            originImage = UIImage(url: postInfoImage ?? "")
            
            titleLabel.alpha = 1
            titleWithFontLabel.alpha = 0
            
            backGroundViewUpConstraint.constant = 20
            backGroundViewDownConstraint.constant = safeAreaWidth/5 + 20
            
            if safeAreaWidth > 500 {
                postImageViewWidthConstraint.constant = 500
                postImageViewHeightConstraint.constant = 500
            } else {
                postImageViewWidthConstraint.constant = safeAreaWidth - 100
                postImageViewHeightConstraint.constant = safeAreaWidth - 100
            }
            
        } else {
            postImageView.image = nil
            titleLabel.alpha = 0
            titleWithFontLabel.alpha = 1
            
            backGroundViewUpConstraint.constant = safeAreaWidth/4
            backGroundViewDownConstraint.constant = safeAreaWidth/5 + 20
            
            if safeAreaWidth > 500 {
                postImageViewWidthConstraint.constant = 500
                postImageViewHeightConstraint.constant = 0
            } else {
                postImageViewWidthConstraint.constant = safeAreaWidth - 80
                postImageViewHeightConstraint.constant = 0
            }
            
        }
        
        let backGroundTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(backGroundTap(_:)))
        backGroundView.addGestureRecognizer(backGroundTapGesture)
        backGroundView.isUserInteractionEnabled = true
        
        
        let postTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(postTap(_:)))
        postImageView.addGestureRecognizer(postTapGesture)
        postImageView.isUserInteractionEnabled = true
        
        postImageView.clipsToBounds = true
        postImageView.layer.cornerRadius = 16
        
        let longTapGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(longPostTap(_:))
        )
        postImageView.addGestureRecognizer(longTapGesture)
        
        
        
        let userTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(userTap(_:)))
        
        userImageView.addGestureRecognizer(userTapGesture)
        userImageView.isUserInteractionEnabled = true
        
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 25
        
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
  
            let alert: UIAlertController = UIAlertController(title: "Instagram", message: "をインストールしてください", preferredStyle:  UIAlertController.Style.alert)

            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                    (action: UIAlertAction!) -> Void in
                    print("OK")
                })

                alert.addAction(defaultAction)

            present(alert, animated: true, completion: nil)
            }
    }
    
    func getUserInfo(){
        db.collection("users").document(postUserId ?? "").collection("Profile").document("profile").getDocument { [self](document, error) in
            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                

                
                let userNameString = document["userName"] as? String ?? ""
                let userImageString = document["userImage"] as? String ?? ""
                let userFrontIdString = document["userFrontId"] as? String ?? ""
                
                userName = userNameString
                userImage = userImageString
                userFrontId = userFrontIdString
                
                
                
//                userNameLabel.text = userNameString
                userFrontIdLabel.text = userFrontIdString
                if let url = URL(string:userImageString) {
                    Nuke.loadImage(with: url, into: userImageView)
                } else {
                    userImageView.image = nil
                }
                
            }
        }
    }
    
    @objc private func backGroundTap(_ sender: UITapGestureRecognizer) {
        print(backTapCount)
        backTapCount += 1
        
        let surplusCount = backTapCount % 5
        
        switch surplusCount{
        case 1:
            backGroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8974241918)
            userFrontIdLabel.textColor = .darkGray
            backHexColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8974241918).toHexString()

            
        case 2 :
            backGroundView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 0.8966493152)
            userFrontIdLabel.textColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
            backHexColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 0.8966493152).toHexString()

        case 3 :
            backGroundView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.9457381246, blue: 0.7684240747, alpha: 0.9)
            userFrontIdLabel.textColor = .white
            backHexColor = #colorLiteral(red: 0.9764705896, green: 0.9457381246, blue: 0.7684240747, alpha: 0.9).toHexString()

        case 4 :
            backGroundView.backgroundColor = .clear
            userFrontIdLabel.textColor = .white
            backHexColor = UIColor.clear.toHexString()


        default:
            backGroundView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.900812162)
            userFrontIdLabel.textColor = .lightGray
            backHexColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7973026613).toHexString()


        }
        
    }
    
    @objc private func postTap(_ sender: UITapGestureRecognizer) {
        //UIImageViewのimageをオプショナルバインディングでアンラップし、imageに代入
        if let image = originImage {
            //フィルター名を指定
            //ボタンを押すたびにフィルター内容が変わるように設定
            filterLabel.text = filterNameArray[filterNumber]
            let filterName = filterArray[filterNumber]
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
                self.postImageView.image = UIImage(url: postInfoImage ?? "")
                
                animationLabel()
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
            
            self.postImageView.image = UIImage(cgImage: cgImage, scale: 1.0, orientation: rotate)
            animationLabel()
        }
    }
    
    @objc private func longPostTap(_ sender: UILongPressGestureRecognizer) {
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
    
    func animationLabel(){
        UIView.animate(withDuration: 0.1, delay: 0, animations: {
            self.filterLabel.alpha = 1
            //
            //
        }) { bool in
            // ②アイコンを大きくする
            UIView.animate(withDuration: 0.4, delay: 0.6, animations: {
                self.filterLabel.alpha = 0

            })
        }
        
    }
    
    @objc private func userTap(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
        let ProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        
        ProfileVC.userId = postUserId
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
        self.navigationController?.popViewController(animated: true)
//        // Create a reference to the file to delete
        let storageRef = Storage.storage().reference().child("Unit_Post_Image").child(imageAddress ?? "")
        // Delete the file
        storageRef.delete { error in
          if let error = error {
            // Uh-oh, an error occurred!
              print(error)
          } else {
            // File deleted successfully
          }
        }
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

//
//  ViewController.swift
//  protain
//
//  Created by 平田翔大 on 2021/01/29.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import BATabBarController
import GuillotineMenu
import SwiftMoment
import Nuke
import DZNEmptyDataSet
import Instructions
import ImageViewer
import Lottie
import AVKit
import AVFoundation

class ViewController: UIViewController, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource{
    private let cellId = "cellId"
    private var prevContentOffset: CGPoint = .init(x: 0, y: 0)
    private let headerMoveHeight: CGFloat = 5
    
    var outMemo: [OutMemo] = []
    var teamInfo : [Team] = []
    var userName: String? =  UserDefaults.standard.object(forKey: "userName") as? String
    var userImage: String? = UserDefaults.standard.object(forKey: "userImage") as? String
    var userFrontId: String? = UserDefaults.standard.object(forKey: "userFrontId") as? String
    var animationView = AnimationView()
    let db = Firestore.firestore()
    let blockList:[String:Bool] = UserDefaults.standard.object(forKey: "blocked") as! [String:Bool]
    let uid = Auth.auth().currentUser?.uid
    let coachMarksController = CoachMarksController()
    
    fileprivate let cellHeight: CGFloat = 210
    fileprivate let cellSpacing: CGFloat = 20
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    
    
    @IBAction func tappedBubuButton(_ sender: Any) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storyboard = UIStoryboard.init(name: "sinkitoukou", bundle: nil)
        let sinkitoukou = storyboard.instantiateViewController(withIdentifier: "sinkitoukou")
        sinkitoukou.modalPresentationStyle = .fullScreen
        self.present(sinkitoukou, animated: true, completion: nil)
        db.collection("users").document(uid).setData(["currentTime": FieldValue.serverTimestamp()], merge: true)
        //        try? Auth.auth().signOut()
    }
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerhightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headertopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.prevContentOffset = scrollView.contentOffset
        }
        guard let presentIndexPath = chatListTableView.indexPathForRow(at: scrollView.contentOffset) else { return }
        if scrollView.contentOffset.y < 0 { return }
        if presentIndexPath.row >= outMemo.count - 6 { return }
        
        let alphaRatio = 1 / headerhightConstraint.constant
        
        if self.prevContentOffset.y < scrollView.contentOffset.y {
            if headertopConstraint.constant <= -headerhightConstraint.constant { return }
            headertopConstraint.constant -= headerMoveHeight
            headerView.alpha -= alphaRatio * headerMoveHeight
        } else if self.prevContentOffset.y > scrollView.contentOffset.y {
            if headertopConstraint.constant >= 0 {return}
            headertopConstraint.constant += headerMoveHeight
            headerView.alpha += alphaRatio * headerMoveHeight
        }
        
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            headerViewEndAnimation()
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        headerViewEndAnimation()
    }
    private func headerViewEndAnimation() {
        if headertopConstraint.constant < -headerhightConstraint.constant / 2 {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: [], animations:{ [self] in
                headertopConstraint.constant = -headerhightConstraint.constant
                headerView.alpha = 0
                view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: [], animations:{ [self] in
                headertopConstraint.constant = 0
                headerView.alpha = 1
                view.layoutIfNeeded()
            })
        }
    }
    
    @IBOutlet weak var bubuButton: UIButton!
    @IBOutlet weak var chatListTableView: UITableView!
    @IBOutlet var backView: UIView!
    @IBOutlet weak var backGroundImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        addAnimationView()
        //        if UserDefaults.standard.bool(forKey: "FirstPost") != true{
        //            guard let uid = Auth.auth().currentUser?.uid else { return }
        //            UserDefaults.standard.set(true, forKey: "FirstPost")
        //            let storyboard = UIStoryboard.init(name: "sinkitoukou", bundle: nil)
        //            let sinkitoukou = storyboard.instantiateViewController(withIdentifier: "sinkitoukou") as! sinkitoukou
        //            sinkitoukou.modalPresentationStyle = .fullScreen
        //            self.present(sinkitoukou, animated: true, completion: nil)
        //            Firestore.firestore().collection("users").document(uid).setData(["currentTime": FieldValue.serverTimestamp()], merge: true)
        //        } else {
        if UserDefaults.standard.bool(forKey: "OutMemoInstract") != true{
            UserDefaults.standard.set(true, forKey: "OutMemoInstract")
            self.coachMarksController.start(in: .currentWindow(of: self))
        } else {
            let areaName = UserDefaults.standard.object(forKey: "areaNameEn") as? String
            
            //                if areaName == nil {
            
            //                let storyboard = UIStoryboard.init(name: "selectArea", bundle: nil)
            //                let vc = storyboard.instantiateViewController(identifier: "selectAreaVC") as! selectAreaVC
            //                let nav = UINavigationController(rootViewController: vc)
            //                nav.modalPresentationStyle = .fullScreen
            //                self.present(nav, animated: true, completion: nil)
            //                }
        }
        //        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.coachMarksController.dataSource = self
        
        
        //        //        テスト ca-app-pub-3940256099942544/2934735716
        //        //        本番 ca-app-pub-9686355783426956/8797317880
        //        self.bannerView.adUnitID = "ca-app-pub-9686355783426956/8797317880"
        //        self.bannerView.rootViewController = self
        //        self.bannerView.load(GADRequest())
        
        //navigationbarのやつ
        //        let navBar = self.navigationController?.navigationBar
        //        navBar?.barTintColor = #colorLiteral(red: 0.03921568627, green: 0.007843137255, blue: 0, alpha: 1)
        
        chatListTableView.register(UINib(nibName: "OutMemoCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        //        self.chatListTableView.rowHeight = 100
        self.chatListTableView.estimatedRowHeight = 40
        self.chatListTableView.rowHeight = UITableView.automaticDimension
        //Pull To Refresh
        chatListTableView.refreshControl = UIRefreshControl()
        chatListTableView.refreshControl?.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
        chatListTableView.separatorStyle = .none
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        chatListTableView.emptyDataSetDelegate = self
        chatListTableView.emptyDataSetSource = self
        
        bubuButton.layer.cornerRadius = 30
        bubuButton.clipsToBounds = true
        bubuButton.layer.masksToBounds = false
        bubuButton.layer.shadowColor = UIColor.black.cgColor
        bubuButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        bubuButton.layer.shadowOpacity = 1
        bubuButton.layer.shadowRadius = 5
        //        fetchFireStore(userId: uid)
        getFirestore(userId: uid)
        fetchNotification(userId: uid)
    }
    
    func addAnimationView() {
        
        
        //アニメーションファイルの指定
        animationView = AnimationView(name: "mapAnimation") //ここに先ほどダウンロードしたファイル名を記述（拡張子は必要なし）
        
        //アニメーションの位置指定（画面中央）
        animationView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        
        //アニメーションのアスペクト比を指定＆ループで開始
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.play()
        
        //ViewControllerに配置
        animationView.alpha = 0
        
        view.addSubview(animationView)
        
        UIView.animate(withDuration: 0.175, delay: 0, animations: { [self] in
            animationView.alpha = 1
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            UIView.animate(withDuration: 0.2, delay: 0, animations: { [self] in
                self.animationView.alpha = 0
            }){ bool in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.animationView.removeFromSuperview()
                }
            }
            
            
        }
    }
    //Pull to Refresh
    @objc func onRefresh(_ sender: AnyObject) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.outMemo.removeAll()
            self?.chatListTableView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // 0.5秒後に実行したい処理
                guard let uid = Auth.auth().currentUser?.uid else { return }
                self?.getFirestore(userId: uid)
            }
            
            self?.chatListTableView.refreshControl?.endRefreshing()
        }
    }
    
    
    // blankword for tableview
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "データがありません")
    }
    
    func fetchNotification(userId:String){
        
        db.collection("users").document(userId).addSnapshotListener { [self] documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            print("Current data: \(data)")
            let notificationNum = data["notificationNum"] as? Int ?? 0
            let messageNum = data["messageNum"] as? Int ?? 0
            
            print(notificationNum)
            
            if notificationNum >= 1 {
                self.tabBarController?.viewControllers?[2].tabBarItem.badgeValue = String(notificationNum)
            } else {
            }
            
            if messageNum >= 1 {
                self.tabBarController?.viewControllers?[1].tabBarItem.badgeValue = String(messageNum)
                
            } else {
            }
            //                notificationNumber.text =
            //                self.teamInfo.removeAll()
            //                self.teamCollectionView.reloadData()
        }
    }
    
    private func getFirestore(userId:String) {
        db.collection("users").document(userId).collection("TimeLine").whereField("admin", isEqualTo: false).getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let dic = document.data()
                    let rarabai = OutMemo(dic: dic)
                    let date: Date = rarabai.createdAt.dateValue()
                    let momentType = moment(date)
                    let docUserId = rarabai.userId
                    
                    self.outMemo.append(rarabai)
                    
                    //                    switch rarabai.anonymous {
                    //                    case true:
                    //                        let anonymousId = rarabai.userId + "anonymous"
                    //                        if blockList[anonymousId] == true {
                    //                        } else {
                    //                            if rarabai.delete == true {
                    //                            } else {
                    //                                if docUserId == userId {
                    //                                    self.outMemo.append(rarabai)
                    //                                } else {
                    //                                    if momentType >= moment() - 30.days {
                    //                                        self.outMemo.append(rarabai)
                    //                                    }
                    //                                }
                    //                            }
                    //                        }
                    //                    default :
                    //                        if blockList[rarabai.userId] == true {
                    //
                    //                        } else {
                    //                            if rarabai.delete == true {
                    //                            } else {
                    //
                    //
                    //                                if docUserId == userId {
                    //                                    self.outMemo.append(rarabai)
                    //                                } else {
                    //
                    //                                    if momentType >= moment() - 30.days {
                    //                                        self.outMemo.append(rarabai)
                    //                                    }
                    //                                }
                    //                            }
                    //                        }
                    //                    }
                    self.outMemo.sort { (m1, m2) -> Bool in
                        let m1Date = m1.createdAt.dateValue()
                        let m2Date = m2.createdAt.dateValue()
                        return m1Date > m2Date
                    }
                    self.chatListTableView.reloadData()
                }
            }
        }
    }
    
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        chatListTableView.estimatedRowHeight = 20
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outMemo.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OutmMemoCellVC
        
        cell.backBack.backgroundColor = .clear
        cell.backgroundColor = .clear
        tableView.backgroundColor = .clear
        
        let safeAreaWidth = UIScreen.main.bounds.size.width
        var safeAreaWidthPad:CGFloat = 500
        
        if safeAreaWidth < 500 {
            safeAreaWidthPad = safeAreaWidth
        }
        
        cell.messageLabel.text = outMemo[indexPath.row].message
        
        cell.graffitiUserImageView.image = nil
        if let url = URL(string:outMemo[indexPath.row].graffitiUserImage) {
            Nuke.loadImage(with: url, into: cell.graffitiUserImageView)
        } else {
            cell.graffitiUserImageView?.image = nil
        }
        
        cell.graffitiUserImageView.clipsToBounds = true
        cell.graffitiUserImageView.layer.cornerRadius = 25
        
        cell.graffitiContentsImageView.clipsToBounds = true
        cell.graffitiContentsImageView.layer.cornerRadius = 10
        
        cell.graffitiContentsImageView.image = nil
        cell.sendImageView.image = nil
        cell.playCircleImageView.alpha = 0

        
        cell.graffitiUserFrontIdLabel.text = outMemo[indexPath.row].graffitiUserFrontId
        
        cell.graffitiTitleLabel.text = outMemo[indexPath.row].graffitiTitle
        cell.graffitiLabel.text = outMemo[indexPath.row].graffitiTitle
        cell.graffitiLabel.font = UIFont(name:outMemo[indexPath.row].textFontName, size:safeAreaWidth/6)
        
        cell.graffitiLabel.textColor = UIColor(hex: outMemo[indexPath.row].hexColor)
        cell.graffitiTitleLabel.textColor = UIColor(hex: outMemo[indexPath.row].hexColor)
        cell.graffitiBackGroundView.backgroundColor = UIColor(hex: outMemo[indexPath.row].backHexColor)
        
        //        cell.userFrontIdLabel.textColor = .lightGray
        //        cell.userFrontIdLabel.font = UIFont.italicSystemFont(ofSize: safeAreaWidth/20)
        
        cell.graffitiBackGroundView.clipsToBounds = true
        cell.graffitiBackGroundView.layer.cornerRadius = 10
        
        //        #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        
        cell.coverView.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
        cell.messageBottomConstraint.constant =  105
        
        //        cell.graffitiImageViewWidthConstraint.constant = safeAreaWidth/1.5
        //        cell.graffitiImageViewHeightConstraint.constant = safeAreaWidth/1.5
        
        let transScale = CGAffineTransform(rotationAngle: CGFloat(270))
        cell.graffitiLabel.transform = transScale
        
        //        cell.graffitiImageView.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        
        
        if  outMemo[indexPath.row].readLog == true {
            cell.coverView.backgroundColor = .clear
            cell.coverViewConstraint.constant = 0
            cell.messageBottomConstraint.constant = 20
            cell.messageLabel.numberOfLines = 0
            cell.coverImageView.alpha = 0
            cell.textMaskLabel.alpha = 0
            cell.sendImageConstraintHeight.constant = 150
            
            let assetsType = outMemo[indexPath.row].assetsType
            cell.sendImageConstraintHeight.constant = 0
            
            switch assetsType {
            case "image":
                cell.sendImageConstraintHeight.constant = safeAreaWidthPad
                cell.sendImageViewWidth.constant = safeAreaWidthPad
                cell.sendImageView.contentMode = .scaleAspectFill
                cell.playCircleImageView.alpha = 0
                
                if let url = URL(string:outMemo[indexPath.row].sendImageURL) {
                    Nuke.loadImage(with: url, into: cell.sendImageView)
                    
                    cell.sendImageView.alpha = 1
                } else {
                    cell.sendImageView?.image = nil
                    cell.sendImageView.alpha = 0
                    cell.sendImageConstraintHeight.constant = 0
                }
            case "stamp":
                cell.sendImageConstraintHeight.constant = safeAreaWidthPad/2
                cell.sendImageViewWidth.constant = safeAreaWidthPad/2
                cell.sendImageView.contentMode = .scaleAspectFit
                cell.playCircleImageView.alpha = 0

                if let url = URL(string:outMemo[indexPath.row].sendImageURL) {
                    Nuke.loadImage(with: url, into: cell.sendImageView)
                    cell.sendImageView.alpha = 1
                } else {
                    cell.sendImageView?.image = nil
                    cell.sendImageView.alpha = 0
                    cell.sendImageConstraintHeight.constant = 0
                }
            case "movie":
                cell.sendImageConstraintHeight.constant = safeAreaWidthPad
                cell.sendImageViewWidth.constant = safeAreaWidthPad
                cell.sendImageView.contentMode = .scaleAspectFill
                cell.sendImageView.alpha = 1
                cell.playCircleImageView.alpha = 1
                
                if let url = URL(string:outMemo[indexPath.row].sendImageURL) {
                    Nuke.loadImage(with: url, into: cell.sendImageView)
                    cell.sendImageView.alpha = 1
                } else {
                    cell.sendImageView?.image = nil
                    cell.sendImageView.alpha = 0
                    cell.sendImageConstraintHeight.constant = 0
                }
                
            default:
                cell.sendImageConstraintHeight.constant = 0
                cell.sendImageView?.image = nil
                cell.sendImageView.alpha = 0
                cell.playCircleImageView.alpha = 0
                
            }
                        
            if outMemo[indexPath.row].graffitiUserId != "" {
                
                if outMemo[indexPath.row].delete == true {
                    cell.graffitiBackGroundConstraint.constant = 0
                    cell.graffitiBackGroundView.alpha = 0
                    cell.graffitiUserFrontIdLabel.alpha = 0
                    cell.graffitiTitleLabel.alpha = 0
                    cell.graffitiUserImageView.alpha = 0
                    cell.graffitiContentsImageView.alpha = 0
                    //                    cell.sendImageConstraintHeight.constant = 0
                } else {
                    
                    if let url = URL(string:outMemo[indexPath.row].graffitiContentsImage) {
                        Nuke.loadImage(with: url, into: cell.graffitiContentsImageView)
                        
                        cell.graffitiImageViewWidthConstraint.constant = safeAreaWidth/1.5
                        cell.graffitiImageViewHeightConstraint.constant = safeAreaWidth/1.5
                        cell.graffitiTitleLabel.alpha = 1
                        cell.graffitiLabel.alpha = 0
                        
                        let titleLabelHeight = cell.graffitiTitleLabel.intrinsicContentSize.height
                        let imageHeight = safeAreaWidth/1.5
                        let graffitiBackSendHeight = imageHeight + 70 + 70 + titleLabelHeight
                        cell.sendImageConstraintHeight.constant = graffitiBackSendHeight
                        cell.sendImageView.image = nil
                        
                    } else {
                        cell.graffitiContentsImageView?.image = nil
                        cell.graffitiImageViewWidthConstraint.constant = 0
                        cell.graffitiImageViewHeightConstraint.constant = 0
                        cell.graffitiTitleLabel.alpha = 0
                        cell.graffitiLabel.alpha = 1
                        
                        let titleLabelHeight = cell.graffitiLabel.intrinsicContentSize.height
                        let graffitiBackSendHeight = 70 + 20 + titleLabelHeight
                        cell.sendImageConstraintHeight.constant = graffitiBackSendHeight
                        cell.sendImageView.image = nil
                    }
                    
                    cell.graffitiBackGroundConstraint.constant = 700
                    cell.graffitiBackGroundView.alpha = 1
                    cell.graffitiUserFrontIdLabel.alpha = 1
                    
                    cell.graffitiUserImageView.alpha = 1
                    cell.graffitiContentsImageView.alpha = 1
                }
                
            } else {
                //                cell.sendImageConstraintHeight.constant = 0
                cell.graffitiBackGroundConstraint.constant = 0
                cell.graffitiBackGroundView.alpha = 0
                cell.graffitiUserFrontIdLabel.alpha = 0
                cell.graffitiTitleLabel.alpha = 0
                cell.graffitiUserImageView.alpha = 0
                cell.graffitiContentsImageView.alpha = 0
            }
            
        } else {
            cell.coverView.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)
            cell.coverViewConstraint.constant = 100
            cell.messageBottomConstraint.constant =  105
            cell.messageLabel.numberOfLines = 1
            cell.coverImageView.alpha = 0.8
            cell.textMaskLabel.alpha = 1
            
            cell.sendImageView.image = nil
            cell.sendImageView.alpha = 0
            cell.sendImageConstraintHeight.constant = 0
            
            cell.sendImageConstraintHeight.constant = 0
            cell.graffitiBackGroundConstraint.constant = 0
            cell.graffitiBackGroundView.alpha = 0
            cell.graffitiUserFrontIdLabel.alpha = 0
            cell.graffitiTitleLabel.alpha = 0
            cell.graffitiUserImageView.alpha = 0
            cell.graffitiContentsImageView.alpha = 0
        }
        //
        if let url = URL(string:outMemo[indexPath.row].textMask) {
            Nuke.loadImage(with: url, into: cell.coverImageView)
        } else {
            cell.coverImageView?.image = nil
        }
        
        if uid == outMemo[indexPath.row].userId {
            cell.flagButton.isHidden = true
        } else {
            cell.flagButton.isHidden = false
        }
        cell.flagButton.tag = indexPath.row
        cell.flagButton.addTarget(self, action: #selector(flagButtonEvemt), for: UIControl.Event.touchUpInside)
        
        cell.shareButton.tag = indexPath.row
        cell.shareButton.addTarget(self, action: #selector(shareStickerImage), for: UIControl.Event.touchUpInside)
        cell.shareButton.alpha = 0
        
        cell.userImageView.image = nil
        
        //↓tableviewのunit表示
        //        fetchDocContents(userId: outMemo[indexPath.row].userId, cell: cell,documentId: outMemo[indexPath.row].documentId)
        
        //↓と↑交換
        fetchMypostData(userId: outMemo[indexPath.row].userId, cell: cell, documentId: outMemo[indexPath.row].documentId)
        
        let date: Date = outMemo[indexPath.row].createdAt.dateValue()
        
        cell.dateLabel.text = date.agoText()
        //
        cell.userImageView.layer.cornerRadius = 30
        cell.mainBackground.layer.cornerRadius = 8
        cell.mainBackground.layer.masksToBounds = true
        cell.outMemo = outMemo[indexPath.row]
        cell.messageLabel.clipsToBounds = true
        cell.messageLabel.layer.cornerRadius = 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.chatListTableView.cellForRow(at:indexPath) as! OutmMemoCellVC
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        if outMemo[indexPath.row].readLog == true{
            
            if outMemo[indexPath.row].userId != uid {
                
                let storyboard = UIStoryboard.init(name: "Reaction", bundle: nil)
                let ReactionVC = storyboard.instantiateViewController(withIdentifier: "ReactionVC") as! ReactionVC
                
                ReactionVC.message = outMemo[indexPath.row].message
                ReactionVC.userId = outMemo[indexPath.row].userId
                ReactionVC.userImage  = cell.userImageView.image
                
                self.present(ReactionVC, animated: true, completion: nil)
            } else {
                let storyboard = UIStoryboard.init(name: "ReadLog", bundle: nil)
                let ReadLogVC = storyboard.instantiateViewController(withIdentifier: "ReadLogVC") as! ReadLogVC
                
                ReadLogVC.documentId=outMemo[indexPath.row].documentId
                
                self.present(ReadLogVC, animated: true, completion: nil)
            }
            
        } else {
            
            print("outmemo",outMemo[indexPath.row].readLog)
            
            let readLogDic = [
                "userId":uid,
                "userName":userName ?? "unKnown",
                "userImage":userImage ?? "",
                "userFrontId":userFrontId ?? "unKnown",
                "createdAt": FieldValue.serverTimestamp(),
            ] as [String:Any]
            
            outMemo[indexPath.row].readLog = true
            db.collection("users").document(uid).collection("TimeLine").document(outMemo[indexPath.row].documentId).setData(["readLog":true],merge: true)
            db.collection("users").document(outMemo[indexPath.row].userId).collection("MyPost").document(outMemo[indexPath.row].documentId).collection("Readlog").document(uid).setData(readLogDic)
            cell.coverView.backgroundColor = .clear
            cell.coverImageView.alpha = 0
            cell.textMaskLabel.alpha = 0
            cell.messageLabel.numberOfLines = 0
            //            let indexPath = IndexPath(row: indexPath.row, section: 0)
            //            tableView.reloadRows(at: [indexPath], with: .fade)
            chatListTableView.reloadData()
            
        }
    }
    
    func thumnailImageForFileUrl(fileUrl: URL,cell:OutmMemoCellVC) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true

        do {
            let thumnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1,timescale: 60), actualTime: nil)
            print("サムネイルの切り取り成功！")
            let uiImage = UIImage(cgImage: thumnailCGImage)
            cell.sendImageView.image = uiImage
            return UIImage(cgImage: thumnailCGImage, scale: 0, orientation: .right)
        }catch let err{
            print("エラー\(err)")
        }
        return nil
    }
    
    //    func getUserTeamInfo(userId:String,cell:OutmMemoCellVC){
    //        db.collection("users").document(userId).collection("belong_Team").document("teamId").getDocument { (document, error) in
    //            if let document = document, document.exists {
    //                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
    //                print("Document data: \(dataDescription)")
    //
    //                let teamIdArray = document.data()!["teamId"] as! Array<String>
    //                print(teamIdArray)
    //                print(teamIdArray[0])
    //
    //
    //                    teamIdArray.forEach{
    //                        self.getTeamInfo(teamId: $0,cell: cell)
    //                    }
    //            } else {
    //                print("Document does not exist")
    //            }
    //        }
    //    }
    //
    //    func getTeamInfo(teamId:String,cell:OutmMemoCellVC){
    //        db.collection("Team").document(teamId).getDocument { (document, error) in
    //            if let document = document, document.exists {
    //                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
    //                print("Document data: \(dataDescription)")
    //                let teamDic = Team(dic: document.data()!)
    //                self.teamInfo.append(teamDic)
    //                print("翼をください！",teamId)
    //                print("翼をください！",document.data()!)
    //                print("asefiosejof",teamDic)
    //
    //                cell.teamCollectionView.alpha = 1
    //
    //
    //                cell.teamCollectionView.reloadData()
    //            } else {
    //                print("Document does not exist")
    //            }
    //        }
    //    }
    @objc func shareStickerImage(_ sender: UIButton){
        if UIApplication.shared.canOpenURL(URL(string: "instagram-stories://share")!) {
            
            let indexPath = IndexPath(row:sender.tag , section: 0)
            let cell = chatListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OutmMemoCellVC
            let image = cell.storyBackView.asImage()
            
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
    
    @objc func flagButtonEvemt(_ sender: UIButton){
        //アラート生成
        //UIAlertControllerのスタイルがactionSheet
        let actionSheet = UIAlertController(title: "report", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        let uid = Auth.auth().currentUser?.uid
        let report = [
            "reporter": uid,
            "documentId": outMemo[sender.tag].documentId,
            "問題のコメント": outMemo[sender.tag].message,
            "問題と思われるユーザー": outMemo[sender.tag].userId,
            "createdAt": FieldValue.serverTimestamp(),
        ] as [String: Any]
        
        
        // 表示させたいタイトル1ボタンが押された時の処理をクロージャ実装する
        let action1 = UIAlertAction(title: "このユーザーを非表示にする", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            //実際の処理
            let dialog = UIAlertController(title: "本当に非表示にしますか？", message: "ブロックしたユーザーのあらゆる投稿が非表示になります。", preferredStyle: .alert)
            // 選択肢(ボタン)を2つ(OKとCancel)追加します
            //   titleには、選択肢として表示される文字列を指定します
            //   styleには、通常は「.default」、キャンセルなど操作を無効にするものは「.cancel」、削除など注意して選択すべきものは「.destructive」を指定します
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler:  { [self] action in
                
                if UserDefaults.standard.object(forKey: "blocked") == nil{
                    let XXX = ["XX" : true]
                    UserDefaults.standard.set(XXX, forKey: "blocked")
                }
                var blockDic:[String:Bool] = UserDefaults.standard.object(forKey: "blocked") as! [String: Bool]
                
                print("あいえいえいいえいえ",outMemo[sender.tag].userId)
                let anonymousId = outMemo[sender.tag].userId + "anonymous"
                
                if outMemo[sender.tag].anonymous == true {
                    blockDic[anonymousId] = true
                } else {
                    blockDic[outMemo[sender.tag].userId] = true
                }
                
                print("亜ジョイsfjイオ",blockDic)
                UserDefaults.standard.set(blockDic, forKey: "blocked")
                let uid = Auth.auth().currentUser?.uid
                
                print("tapped: \([sender.tag])番目のcell")
                
                self.outMemo.remove(at: sender.tag)
                self.chatListTableView.deleteRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
                self.db.collection("Report").document(self.outMemo[sender.tag].userId).collection("reported").document().setData(report, merge: true)
                self.db.collection("Report").document(self.outMemo[sender.tag].userId).setData(["reportedCount": FieldValue.increment(1.0),"createdAt":FieldValue.serverTimestamp()] as [String : Any])
            }))
            dialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            // 生成したダイアログを実際に表示します
            self.present(dialog, animated: true, completion: nil)
            print("このユーザーを非表示にする")
        })
        // 表示させたいタイトル2ボタンが押された時の処理をクロージャ実装する
        let action2 = UIAlertAction(title: "このユーザーを報告する", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            //実際の処理
            
            self.db.collection("Report").document(self.outMemo[sender.tag].userId).collection("reported").document().setData(report, merge: true)
            self.db.collection("Report").document(self.outMemo[sender.tag].userId).setData(["reportedCount": FieldValue.increment(1.0),"createdAt":FieldValue.serverTimestamp()] as [String : Any])
            print("このユーザーを報告する")
            
        })
        // 閉じるボタンが押された時の処理をクロージャ実装する
        //UIAlertActionのスタイルがCancelなので赤く表示される
        let close = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.destructive, handler: {
            (action: UIAlertAction!) in
            //実際の処理
            print("キャンセル")
        })
        //UIAlertControllerにタイトル1ボタンとタイトル2ボタンと閉じるボタンをActionを追加
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(close)
        
        actionSheet.popoverPresentationController?.sourceView = self.view
        
        let screenSize = UIScreen.main.bounds
        actionSheet.popoverPresentationController?.sourceRect=CGRect(x:screenSize.size.width/2,y:screenSize.size.height,width:0,height:0)
        //実際にAlertを表示する
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    func fetchDocContents(userId:String,cell:OutmMemoCellVC,documentId:String){
        
        fetchMypostData(userId: userId, cell: cell, documentId: documentId)
        
        //        if cell.teamInfo.count == 0 {
        cell.teamInfo.removeAll()
        //            cell.teamCollectionView.reloadData()
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        // 0.1秒後に実行したい処理（あとで変えるこれは良くない)
        //            self.getUserTeamInfo(userId: self.outMemo?.userId ?? "unknown")
        self.getUserTeamInfo(userId: userId, cell: cell)
        //            }
        //        }
    }
    
    func fetchMypostData(userId:String,cell:OutmMemoCellVC,documentId:String) {
        db.collection("users").document(userId).collection("MyPost").document(documentId)
            .addSnapshotListener { [self] documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    
                    if userId == "gBD75KJjTSPcfZ6TvbapBgTqpd92" {
                        
                        let userImage = "https://firebasestorage.googleapis.com:443/v0/b/totalgood-7b3a3.appspot.com/o/User_Image%2F51115339-DA49-4BE0-B9E6-A45FC8198FE0?alt=media&token=dac0b228-8381-430d-bb07-71ef20d80f4d"
                        let userFrontId = "ubatge"
                        
                        cell.userFrontIdLabel.text = userFrontId
                        
                        if let url = URL(string:userImage) {
                            Nuke.loadImage(with: url, into: cell.userImageView)
                        } else {
                            cell.userImageView?.image = nil
                        }
                    } else {
                        
                        cell.userFrontIdLabel.text = userFrontId
                        
                        if let url = URL(string:userImage ?? "") {
                            Nuke.loadImage(with: url, into: cell.userImageView)
                        } else {
                            cell.userImageView?.image = nil
                        }
                    }
                    return
                }
                
                let anoymousBool = document["anonymous"] as? Bool ?? false
                let messageString = document["message"] as? String ?? ""
                let stringCount = messageString.count
                let countRemainder = stringCount % 7
                
                let skipImageArray = [
                    "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/skipUserLogo%2Fundraw_refreshing_beverage_blue.png?alt=media&token=c45c9978-6c0e-481c-98f3-2493ac67d5fe",
                    "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/skipUserLogo%2Fundraw_refreshing_beverage_graypng.png?alt=media&token=3b5c4178-d1f5-4c48-aa1a-fb33730342e0",
                    "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/skipUserLogo%2Fundraw_refreshing_beverage_green.png?alt=media&token=c1e66255-6c0b-4156-86e0-d95f2acb4d75",
                    "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/skipUserLogo%2Fundraw_refreshing_beverage_purple.png?alt=media&token=929a9404-a62e-4e2a-a804-3daa193d41c1",
                    "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/skipUserLogo%2Fundraw_refreshing_beverage_redr.png?alt=media&token=2b84aa67-abb3-4de2-9eb5-263ee8380e03",
                    "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/skipUserLogo%2Fundraw_refreshing_beverage_td3r.png?alt=media&token=f2ea21ef-f532-4029-92d7-62c02a975431",
                    "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/skipUserLogo%2Fundraw_refreshing_beverage_yellowr.png?alt=media&token=f74d54f3-a7e6-4f5c-8170-b991d1d72555"
                ]
                
                
                if anoymousBool == true {
                    
                    let userImage = skipImageArray[countRemainder]
                    
                    let userFrontId = "anonymous"
                    cell.userFrontIdLabel.text = userFrontId
                    
                    if let url = URL(string:userImage) {
                        Nuke.loadImage(with: url, into: cell.userImageView)
                    } else {
                        cell.userImageView?.image = nil
                    }
                    
                } else {
                    
                    let userImage = document["userImage"] as? String ?? ""
                    let userFrontId = document["userFrontId"] as? String ?? ""
                    
                    cell.userFrontIdLabel.text = userFrontId
                    if let url = URL(string:userImage) {
                        Nuke.loadImage(with: url, into: cell.userImageView)
                    } else {
                        cell.userImageView?.image = nil
                    }
                }
                //                print("Current data: \(data)")
                //                let userId = document["userId"] as? String ?? "unKnown"
                //                userName = document["userName"] as? String ?? "unKnown"
                let delete = document["delete"] as? Bool ?? false
                
                if delete == true {
                    cell.messageLabel.text = "この投稿は削除されました"
                    
                    //後で直す
                    cell.graffitiContentsImageView.alpha = 0
                    cell.graffitiBackGroundConstraint.constant = 0
                    db.collection("users").document(uid ?? "").collection("TimeLine").document(documentId).setData(["delete":true],merge: true)
                } else {
                    //                    cell.messageLabel.text = message
                }
                //                cell.nameLabel.text = userName
                //                getUserTeamInfo(userId: userId, cell: cell)
            }
        
    }
    
    func getUserTeamInfo(userId:String,cell:OutmMemoCellVC){
        
        db.collection("users").document(userId).collection("belong_Team").addSnapshotListener {( snapshots, err) in
            if let err = err {
                
                print("メッセージの取得に失敗、\(err)")
                return
            }
            snapshots?.documentChanges.forEach({ (Naruto) in
                switch Naruto.type {
                case .added:
                    let dic = Naruto.document.data()
                    let teamInfoDic = Team(dic: dic)
                    //                    let teamId = Naruto.document.data()["teamId"] as? String ?? ""
                    cell.teamInfo.append(teamInfoDic)
                    
                case .modified, .removed:
                    print("noproblem")
                }
            })
            cell.teamCollectionView.reloadData()
            
        }
    }
}


extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}

extension ViewController: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 1
    }
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        
        let highlightViews: Array<UIView> = [bubuButton]
        //(hogeLabelが最初、次にfugaButton,最後にpiyoSwitchという流れにしたい)
        
        //チュートリアルで使うビューの中からindexで何ステップ目かを指定
        return coachMarksController.helper.makeCoachMark(for: highlightViews[index])
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
            
        case 0:    //fugaButton
            coachViews.bodyView.hintLabel.text = "ここから新しい投稿を行います!"
            coachViews.bodyView.nextLabel.text = "OK"
            
            
        default:
            break
            
        }
        
        //その他の設定が終わったら吹き出しを返します
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}

extension UIView {
    func ViewController() -> UIViewController? {
        var ChatRoomtableViewResponder: UIResponder? = self
        while true {
            guard let ChatRoomtableViewCellResponder = ChatRoomtableViewResponder?.next else { return nil }
            if let viewController = ChatRoomtableViewCellResponder as? UIViewController {
                return viewController
            }
            ChatRoomtableViewResponder = ChatRoomtableViewCellResponder
        }
    }
    func ViewController<T: UIView>(type: T.Type) -> T? {
        var ChatRoomTableViewResponder: UIResponder? = self
        while true {
            guard let ChatRoomTableViewCellResponder = ChatRoomTableViewResponder?.next else { return nil }
            if let view = ChatRoomTableViewCellResponder as? T {
                return view
            }
            ChatRoomTableViewResponder = ChatRoomTableViewCellResponder
        }
    }
}

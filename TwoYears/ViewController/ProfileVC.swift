//
//  ProfileVC.swift
//  TwoYears
//
//  Created by 平田翔大 on 2021/03/02.
//

import UIKit
import Firebase
import GuillotineMenu
import FirebaseFirestore
import SwiftMoment
import Nuke

class ProfileVC: UIViewController {
    
    var outMemo: [OutMemo] = []
    var teamInfo : [Team] = []
    var safeArea : CGFloat = 0
    var userId: String? = UserDefaults.standard.string(forKey:"userid") ?? "" //あとで調整する
    var userName: String? = ""
    var userImage : String = ""
    var cellImageTap : Bool = false
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    let DBU = Firestore.firestore().collection("users")
    private let cellId = "cellId"
    private var prevContentOffset: CGPoint = .init(x: 0, y: 0)
    let blockList:[String:Bool] = UserDefaults.standard.object(forKey: "blocked") as! [String:Bool]
    
    fileprivate let cellHeight: CGFloat = 210
    fileprivate let cellSpacing: CGFloat = 20
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    private let headerMoveHeight: CGFloat = 7
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userImagehighConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImageLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var chatListTableView: UITableView!
    @IBOutlet weak var headerhightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headertopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var teamCollectionView: UICollectionView!
    @IBOutlet weak var collectionHighConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionBottom: NSLayoutConstraint!
    @IBOutlet weak var collectionLeft: NSLayoutConstraint!
    @IBOutlet weak var collectionRight: NSLayoutConstraint!
    
    
    
    @IBOutlet var tapImage: UITapGestureRecognizer!
    @IBAction func tapImageView(_ sender: Any) {
        
//        return
        let storyboard = UIStoryboard.init(name: "UserSelf", bundle: nil)
        let UserSelfViewController = storyboard.instantiateViewController(withIdentifier: "UserSelfViewController") as! UserSelfViewController
        navigationController?.pushViewController(UserSelfViewController, animated: true)
        
    }
    
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
        
        print(self.prevContentOffset)
        print("えええ",scrollView.contentOffset)
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.navigationController?.navigationBar.isHidden = true
        
        let statusbarHeight = UIApplication.shared.statusBarFrame.size.height
        
        //        guard let tabbarHeight = CGFloat((tabBarController?.tabBar.frame.size.height))  // then節の中ではaは非オプショナル定数として扱われる
        //        else {
        //            let tabbarHeight = 0// aがnilの場合の処理
        //        }
        
        //        if tabbarHeight != nil {
        //            tabbarHeight = CGFloat(((tabBarController?.tabBar.frame.size.height)!))
        //        } else {
        //            tabbarHeight = 0
        //        }
        
        //        let tabbarHeight = CGFloat((tabBarController?.tabBar.frame.size.height)!)
        
        //        let safeArea = UIScreen.main.bounds.size.height - tabbarHeight - statusbarHeight
        
        safeArea = UIScreen.main.bounds.size.height - 0 - statusbarHeight
        
        let headerHigh = safeArea/3.5
        
        headerhightConstraint.constant = headerHigh
        
        
        
        //        topViewConstraint.constant = safeArea/7*3
        //        collectionViewConstraint.constant = safeArea/7*3
        //        centerConstraint.constant = widthImage
        
        userImageView.isUserInteractionEnabled = true
        
        userImagehighConstraint.constant = headerHigh/2
        userImageTopConstraint.constant = headerHigh/20
        userImageLeftConstraint.constant = headerHigh/20
        
        
        
        followLabel.clipsToBounds = true
        followLabel.layer.cornerRadius = 5
        followLabel.backgroundColor = .darkGray
        
//        userImageView.image = UIImage(named:"TG1")!
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = headerHigh/4
        
        collectionHighConstraint.constant = headerHigh/4
        collectionBottom.constant = headerHigh/20
        collectionLeft.constant = headerHigh/20
        collectionRight.constant = headerHigh/20
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        setSwipeBack()
        
        
        self.chatListTableView.estimatedRowHeight = 40
        self.chatListTableView.rowHeight = UITableView.automaticDimension
        
        //        navigationbarのやつ
        let navBar = self.navigationController?.navigationBar
        navBar?.barTintColor = #colorLiteral(red: 0.03921568627, green: 0.007843137255, blue: 0, alpha: 1)
        
        
        // セルの詳細なレイアウトを設定する
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // セルのサイズ
        flowLayout.itemSize = CGSize(width: headerHigh/4, height: headerHigh/4)
        // 縦・横のスペース
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 0
        //  スクロールの方向
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        // 上で設定した内容を反映させる
        self.teamCollectionView.collectionViewLayout = flowLayout
        // 背景色を設定
        self.teamCollectionView.backgroundColor = .clear
        
        teamCollectionView.dataSource = self
        teamCollectionView.delegate = self
        teamCollectionView.reloadData()
        
        
        //Pull To Refresh
        chatListTableView.refreshControl = UIRefreshControl()
        chatListTableView.refreshControl?.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
        
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        chatListTableView.separatorStyle = .none
        chatListTableView.backgroundColor = #colorLiteral(red: 0.03042059075, green: 0.01680222603, blue: 0, alpha: 1)
        //            #colorLiteral(red: 0.7238116197, green: 0.6172274334, blue: 0.5, alpha: 1)
        
        //        self.chatListTableView.reloadData()
//        fetchFireStore(userId: userId ?? "")
        getAlloutMemo(userId: userId ?? "")
        fetchUserTeamInfo(userId: userId ?? "")
        fetchUserProfile(userId: userId ?? "")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


        if cellImageTap == true {
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.navigationBar.isHidden = false
        } else {
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.navigationBar.isHidden = true
        }
    }
    
    
    
    //Pull to Refresh
    @objc private func onRefresh(_ sender: AnyObject) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.fetchFireStore(userId: self?.userId ?? "")

        }
    }
    
    func getAlloutMemo(userId:String) {
        db.collection("AllOutMemo").whereField("anonymous", isEqualTo: false).whereField("userId", isEqualTo: userId).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")

                    let dic = document.data()
                    let outMemoDic = OutMemo(dic: dic)

//                    let date: Date = rarabai.zikokudosei.dateValue()
//                    let momentType = moment(date)

//                    if blockList[rarabai.userId] == true {
//
//                    } else {
//                        if momentType >= moment() - 14.days {
//                            if rarabai.admin == true {
//                            }
//                            self.animals.append(rarabai)
//                        }
//                    }

                    self.outMemo.append(outMemoDic)

//                    print("でぃく",dic)
//                    print("ららばい",rarabai)
                    self.outMemo.sort { (m1, m2) -> Bool in
                        let m1Date = m1.createdAt.dateValue()
                        let m2Date = m2.createdAt.dateValue()
                        return m1Date > m2Date
                    }


                }
                self.chatListTableView.reloadData()
            }
        }
    }
    
    private func fetchFireStore(userId:String) {
        db.collection("users").document(userId).collection("TimeLine").whereField("anonymous", isEqualTo: false).whereField("userId", isEqualTo: userId).addSnapshotListener { [self] ( snapshots, err) in
            if let err = err {
                
                print("メッセージの取得に失敗、\(err)")
                return
            }
            
            snapshots?.documentChanges.forEach({ (Naruto) in
                switch Naruto.type {
                case .added:
                    let dic = Naruto.document.data()
                    let rarabai = OutMemo(dic: dic)
                    
                    let date: Date = rarabai.createdAt.dateValue()
                    let momentType = moment(date)
                    
                    if blockList[rarabai.userId] == true {
                    } else {
                        //                        if momentType >= moment() - 14.days {
                        //                            if rarabai.admin == true {
                        //                            }
                        self.outMemo.append(rarabai)
                        
                    }

                    self.outMemo.sort { (m1, m2) -> Bool in
                        let m1Date = m1.createdAt.dateValue()
                        let m2Date = m2.createdAt.dateValue()
                        return m1Date > m2Date
                    }
                case .modified, .removed:
                    print("noproblem")
                }
                self.chatListTableView.reloadData()
                self.chatListTableView.refreshControl?.endRefreshing()
            })
        }
    }
    
    func fetchUserProfile(userId:String){

        db.collection("users").document(userId).collection("Profile").document("profile")
            .addSnapshotListener { [self] documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                print("Current data: \(data)")
                userName = document["userName"] as? String ?? "unKnown"
                userImage = document["userImage"] as? String ?? "unKnown"
                
                userNameLabel.text = userName
                if let url = URL(string:userImage) {
                    Nuke.loadImage(with: url, into: userImageView)
                } else {
                    userImageView?.image = nil
                }
            }
    }
    
    func fetchUserTeamInfo(userId:String){
        
        db.collection("users").document(userId).collection("belong_Team").document("teamId")
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                print("Current data: \(data)")
                let teamIdArray = data["teamId"] as! Array<String>
                print(teamIdArray)
                print(teamIdArray[0])
                
                teamIdArray.forEach{
                    self.getTeamInfo(teamId: $0)
                    
                }
            }
        
    }
    
    func getTeamInfo(teamId:String){
        db.collection("Team").document(teamId).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                let teamDic = Team(dic: document.data()!)
                self.teamInfo.append(teamDic)
                print("翼をください！",teamId)
                print("翼をください！",document.data()!)
                print("asefiosejof",teamDic)
                self.teamCollectionView.reloadData()
            } else {
                print("Document does not exist")
            }
        }
    }
}

extension ProfileVC:UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 50
        let cellSize : CGFloat = self.view.bounds.width / 3 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as!  profileCollectionViewCell// 表示するセルを登録(先程命名した"Cell")
        cell.backView.clipsToBounds = true
        cell.backView.layer.cornerRadius = safeArea/3.5/4/4
        if let url = URL(string:teamInfo[indexPath.row].teamImage) {
            Nuke.loadImage(with: url, into: cell.teamCollectionImage!)
        } else {
            cell.teamCollectionImage?.image = nil
        }
        return cell
    }
    
    
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        chatListTableView.estimatedRowHeight = 20
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if animals.count < 100 {
        //            return animals.count
        //        } else {
        //            return 100
        //        }
        return outMemo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatRankingTableViewCell
        
        
        cell.messageLabel.text = outMemo[indexPath.row].message
        
        
        cell.mainBackground.layer.cornerRadius = 8
        cell.mainBackground.layer.masksToBounds = true
        cell.backback.backgroundColor = .clear
        cell.backgroundColor = .clear
        tableView.backgroundColor = .clear
        
        
        cell.shadowLayer.backgroundColor = .white
        //        #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 0.7282213185)
        cell.rankingnumber.text = (String(indexPath.row + 1))
        print(outMemo[indexPath.row].createdAt)
        
        let date: Date = outMemo[indexPath.row].createdAt.dateValue()
        
        print("デート！！",date)
        
        let momentType = moment(date)
        
        
        
        if momentType < moment() - 15.days {
            cell.aftertime.text = "削除済みです"
        } else if momentType < moment() - 14.days - 23.hours - 30.minutes{
            cell.aftertime.text = "もうすぐ消えます"
        } else if momentType < moment() - 14.days - 23.hours{
            cell.aftertime.text = "1時間以内に消えます"
        } else if momentType < moment() - 14.days - 18.hours{
            cell.aftertime.text = "数時間後に消えます"
        } else if momentType < moment() - 14.days - 12.hours{
            cell.aftertime.text = "半日後に消えます"
        } else if momentType < moment() - 14.days{
            cell.aftertime.text = "1日後に消えます"
        } else if momentType < moment() - 13.days{
            cell.aftertime.text = "2日後に消えます"
        } else if momentType < moment() - 12.days{
            cell.aftertime.text = "3日後に消えます"
        } else if momentType < moment() - 11.days{
            cell.aftertime.text = "4日後に消えます"
        } else if momentType < moment() - 10.days{
            cell.aftertime.text = "5日後に消えます"
        } else {
            cell.aftertime.text = ""
        }
        
        
        
        let comentjiLatestdate = outMemo[indexPath.row].createdAt.dateValue()
        let comentjiLatestmoment = moment(comentjiLatestdate)
        
        let dateformattedLatest = comentjiLatestmoment.format("MM/dd")
        cell.latestdateLabel.text = dateformattedLatest
        
        
        cell.userImageView.image = nil
        
        cell.userImageView.layer.cornerRadius = 22
        
        
        cell.messageLabel.numberOfLines = 0
        cell.messageLabel.clipsToBounds = true
        cell.messageLabel.layer.cornerRadius = 8
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(outMemo[indexPath.row].userId)
        
        let userId = outMemo[indexPath.row].userId
        //dic作ってドキュメントIdとそれに対しての時間とメッセージ内容といいねの種類についても載せる荒らしになるため,基本的にはsetDataはsetData?わかんないけど
        db.collection("users").document(userId).collection("Reaction").document().setData(["userId":uid ?? "unKnown"] as [String : Any])
    }
}

class ShadowRankingView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 6
        self.layer.shadowOpacity = 1.0
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
class ChatRankingTableViewCell: UITableViewCell {
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.backgroundColor = .clear
    }
    
    var animals : Animal? {
        didSet{
            if let animals = animals {
                messageLabel.text = animals.nameJP
            }
        }
    }
    @IBOutlet weak var aftertime: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var rankingnumber: UILabel!
    @IBOutlet weak var backback: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var shadowLayer: UIView!
    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var IndividualImageView: UIImageView!
    @IBOutlet weak var latestdateLabel: UILabel!
    @IBAction func tappedButton(_ sender: Any) {
        print("ssoieiei")
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    private func dateFormatterForDateLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}

class profileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var teamCollectionImage: UIImageView!
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // cellの枠の太さ
        //        self.layer.borderWidth = 1.0
        //        // cellの枠の色
        //        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //        backgroundColor = .gray
        //        if teamName == "red" {
        //            self.layer.borderColor = #colorLiteral(red: 1, green: 0, blue: 0.1150693222, alpha: 0.9030126284)
        //        } else  if teamName == "yellow" {
        //            self.layer.borderColor = #colorLiteral(red: 1, green: 0.992557539, blue: 0.3090870815, alpha: 1)
        //        } else  if teamName == "blue" {
        //            self.layer.borderColor = #colorLiteral(red: 0.4093301235, green: 0.9249009683, blue: 1, alpha: 1)
        //        } else if teamName == "purple" {
        //            self.layer.borderColor = #colorLiteral(red: 0.8918020612, green: 0.7076364437, blue: 1, alpha: 1)
        //        }
        // cellを丸くする
        //        self.layer.cornerRadius = 2.0
    }
}

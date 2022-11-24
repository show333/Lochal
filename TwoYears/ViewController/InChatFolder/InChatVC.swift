//
//  InChat.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/12/08.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Nuke
import GoogleMobileAds
import Instructions

class InChatVC:  UIViewController, UICollectionViewDataSource,UICollectionViewDelegate{
    
    
    var imageUrls = [String]()
    var teamInfo : [Team] = []
    var reaction : [Reaction] = []
    var safeArea : CGFloat = 0
    let db = Firestore.firestore()
    let coachMarksController = CoachMarksController()
    private let cellId = "cellId"
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var CreateButton: UIButton!
    
    @IBAction func CreateTappedButton(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "CreateTeam", bundle: nil)
        let CreateTeamVC = storyboard.instantiateViewController(withIdentifier: "CreateTeamVC") as! CreateTeamVC
        navigationController?.pushViewController(CreateTeamVC, animated: true)

    }
    
    
    @IBOutlet weak var teamCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var reactionTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.bool(forKey: "InChatInstruct") != true{
            UserDefaults.standard.set(true, forKey: "InChatInstruct")
            self.coachMarksController.start(in: .currentWindow(of: self))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        テスト ca-app-pub-3940256099942544/2934735716
//        本番 ca-app-pub-9686355783426956/8797317880
        self.bannerView.adUnitID = "ca-app-pub-9686355783426956/8797317880"
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
                
        self.coachMarksController.dataSource = self
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        fetchUserTeamInfo(userId:uid)
//        fetchReaction(userId:uid)
        
        teamCollectionView.dataSource = self
        teamCollectionView.delegate = self
        

        let statusbarHeight = UIApplication.shared.statusBarFrame.size.height
        let navigationbarHeight = CGFloat((self.navigationController?.navigationBar.frame.size.height)!)
        
        let tabbarHeight = CGFloat((tabBarController?.tabBar.frame.size.height)!)
        
        safeArea = UIScreen.main.bounds.size.height - tabbarHeight - statusbarHeight - navigationbarHeight
        
        collectionViewConstraint.constant = safeArea/1.5+5
        
       
        // セルの詳細なレイアウトを設定する
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // セルのサイズ
        flowLayout.itemSize = CGSize(width: safeArea/3, height: safeArea/3)
        // 縦・横のスペース
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 0
        //  スクロールの方向
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        // 上で設定した内容を反映させる
        self.teamCollectionView.collectionViewLayout = flowLayout
        // 背景色を設定
        self.teamCollectionView.backgroundColor = .clear
    }
    
    func fetchUserTeamInfo(userId:String){
        
        db.collection("users").document(userId).collection("belong_Team").addSnapshotListener { [self] ( snapshots, err) in
            if let err = err {
                
                print("メッセージの取得に失敗、\(err)")
                return
            }
            snapshots?.documentChanges.forEach({ (Naruto) in
                switch Naruto.type {
                case .added:
                    let dic = Naruto.document.data()
                    let teamInfoDic = Team(dic: dic)
                    
                    self.teamInfo.append(teamInfoDic)
                    self.teamInfo.sort { (m1, m2) -> Bool in
                        let m1Date = m1.createdAt.dateValue()
                        let m2Date = m2.createdAt.dateValue()
                        return m1Date > m2Date
                    }
                case .modified, .removed:
                    print("noproblem")
                }
            })
            self.teamCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  teamInfo.count// 表示するセルの数
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let horizontalSpace : CGFloat = 50
            let cellSize : CGFloat = self.view.bounds.width / 3 - horizontalSpace
            return CGSize(width: cellSize, height: cellSize)
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! teamCollectionViewCell// 表示するセルを登録(先程命名した"Cell")
        
        cell.teamNameLabel.text = teamInfo[indexPath.row].teamName

        var imageString = String()
        imageString = teamInfo[indexPath.row].teamImage
                
        cell.backView.clipsToBounds = true
        cell.backView.layer.cornerRadius = safeArea/16
        print("チームドキュメント",teamInfo[indexPath.row])
        
        if let url = URL(string:imageString) {
            Nuke.loadImage(with: url, into: cell.teamCollectionImage!)
        } else {
            cell.teamCollectionImage?.image = nil
        }
   
        
        print(indexPath.row)
        
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let teamRoomId = teamInfo[indexPath.row].teamId
        UserDefaults.standard.set(teamRoomId, forKey: "teamRoomId")
        
        let storyboard = UIStoryboard.init(name: "InChatRoom", bundle: nil)
        let InChatRoomVC = storyboard.instantiateViewController(withIdentifier: "InChatRoomVC") as! InChatRoomVC
        
        print(teamInfo[indexPath.row].teamId)
        navigationController?.pushViewController(InChatRoomVC, animated: true)
        print(indexPath.row)
    }

}

class teamCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var teamCollectionImage: UIImageView!
    
    @IBOutlet weak var teamNameLabel: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // cellの枠の太さ
//        self.layer.borderWidth = 1.0
        // cellの枠の色
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        backgroundColor = .gray

    }
}


extension InChatVC: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 2
    }
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        
        let highlightViews: Array<UIView> = [teamCollectionView, CreateButton,CreateButton]

        return coachMarksController.helper.makeCoachMark(for: highlightViews[index])
    }
    func coachMarksController(
        _ coachMarksController: CoachMarksController,
        coachMarkViewsAt index: Int,
        madeFrom coachMark: CoachMark
    ) -> (bodyView: UIView & CoachMarkBodyView, arrowView: (UIView & CoachMarkArrowView)?) {

        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true,
            arrowOrientation: coachMark.arrowOrientation
        )

        switch index {
        case 0:
            coachViews.bodyView.hintLabel.text = "あなたが所属している\nチームがここに表示されます"
            coachViews.bodyView.nextLabel.text = "タップ"
        
        case 1:
        coachViews.bodyView.hintLabel.text = "友達と一緒に\nチームを作成しましょう!"
            coachViews.bodyView.nextLabel.text = "OK"
            
        
        default:
            break
        
        }
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}

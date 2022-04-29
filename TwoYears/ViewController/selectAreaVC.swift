//
//  selectAreaVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/04/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Nuke

class selectAreaVC:UIViewController {
    
    
    var areaNameJaArray:[String] = []
    var areaNameEnArray:[String] = []
    var areaNameJaString:String?
    var areaNameEnString:String?
    
    var firstBool : Bool = false
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var headerSubTitleLabel: UILabel!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var areaNameCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerTitleLabel.text = "今住んでる都道府県はどこですか？"
        headerTitleLabel.font = UIFont(name:"03SmartFontUI", size:20)
        headerSubTitleLabel.text = "投稿時にそのエリアを中心に届きます！"
        headerSubTitleLabel.font = UIFont(name:"03SmartFontUI", size:14)
        let layout = UICollectionViewFlowLayout()
//          layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
//        let horizontalSpace : CGFloat = 20
        let cellSize : CGFloat = self.view.bounds.width / 3 - 5
        // セルのサイズ
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        // 縦・横のスペース
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        //  スクロールの方向
//        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        // 上で設定した内容を反映させる
        areaNameCollectionView.collectionViewLayout = layout
        
        switch areaNameJaString {
        case "北海道・東北":
            areaNameJaArray = ["北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県"]
            areaNameEnArray = ["hokkaido","aomori","iwate","miyagi","akita","yamagata","fukushima"]
        case "関東":
            areaNameJaArray = ["茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県"]
            areaNameEnArray = ["ibaraki","tochigi","gunma","saitama","chiba","tokyo","kanagawa"]

        case "中部":
            areaNameJaArray = ["新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県","愛知県"]
            areaNameEnArray = ["niigata","toyama","ishikawa","fukui","yamanashi","nagano","gifu","shizuoka","aichi"]
            
        case "近畿":
            areaNameJaArray = ["三重県","滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県"]
            areaNameEnArray = ["mie","shiga","kyoto","osaka","hyogo","nara","wakayama"]

            
        case "中国・四国":
            areaNameJaArray = ["鳥取県","島根県","岡山県","広島県","山口県","徳島県","香川県","愛媛県","高知県"]
            areaNameEnArray = ["tottori","shimane","okayama","hiroshima","yamaguchi","tokushima","kagawa","ehime","kochi"]

            
        case "九州・沖縄":
            areaNameJaArray = ["福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"]
            areaNameEnArray = ["fukuoka","saga","nagasaki","kumamoto","oita","miyazaki","kagoshima","okinawa"]
            
            
        default:
            areaNameJaArray = ["北海道・東北","関東","中部","近畿","中国・四国","九州・沖縄"]
            areaNameEnArray = ["hokkaido,tohoku","kanto","chubu","kinki","chugoku,shikoku","kyushu,okinawa"]
            
            if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Settings%2FbackGround%2Fnihonchizu-color-deformed.png?alt=media&token=138e5ea9-0d59-4703-9131-1941ff6e7069") {
                Nuke.loadImage(with: url, into: backImageView)
            } else {
                backImageView?.image = nil
            }
            
            areaNameCollectionView.backgroundColor = .clear
            print("aa")
            

        }
        
    }
}

extension selectAreaVC:UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return areaNameJaArray.count // 表示するセルの数
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! areaNameCollectionViewCell // 表示するセルを登録(先程命名した"Cell")
//        cell.backgroundColor = .red  // セルの色
        cell.nameJaLabel.text = areaNameJaArray[indexPath.row]
        cell.nameJaLabel.font = UIFont(name:"03SmartFontUI", size:17)

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if areaNameJaString == nil {
            
            let storyboard = UIStoryboard.init(name: "selectArea", bundle: nil)
            let selectAreaVC = storyboard.instantiateViewController(withIdentifier: "selectAreaVC") as! selectAreaVC
            selectAreaVC.areaNameJaString = areaNameJaArray[indexPath.row]
            selectAreaVC.areaNameEnString = areaNameEnArray[indexPath.row]

            navigationController?.pushViewController(selectAreaVC, animated: true)
        } else {
            
//            let areaNameJa = areaNameJaArray[indexPath.row]
//            let areaNameEn = areaNameEnArray[indexPath.row]
//            setSelectedArea(areaNameJa: areaNameJa,areaNameEn: areaNameEn)
//

            if firstBool == true {
                let storyboard = UIStoryboard.init(name: "Thankyou", bundle: nil)
                let ThankyouVC = storyboard.instantiateViewController(withIdentifier: "ThankyouVC") as! ThankyouVC
                navigationController?.pushViewController(ThankyouVC, animated: true)
                
            } else {
                dismiss(animated: true, completion: nil)
            }

        }
        
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 20
        let cellSize : CGFloat = self.view.bounds.width / 3 - horizontalSpace
        
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func setSelectedArea(areaNameJa:String,areaNameEn:String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        UserDefaults.standard.set(areaNameEn, forKey: "areaNameEn")
        UserDefaults.standard.set(areaNameJa, forKey: "areaNameJa")
        
        db.collection("users").document(uid).setData(["areaNameJa":areaNameJa,"areaNameEn":areaNameEn], merge: true)
        db.collection("Area").document("japan").collection("Prefectures").document(areaNameEn).setData(["memberCount": FieldValue.increment(1.0)], merge: true)

    }
    
}


class areaNameCollectionViewCell: UICollectionViewCell {

   
    @IBOutlet weak var nameJaLabel: UILabel!
    
    @IBOutlet weak var nameEnLabel: UILabel!
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        


       // cellの枠の太さ
       self.layer.borderWidth = 1.5
   
       self.layer.borderColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)

       // cellを丸くする
       self.layer.cornerRadius = 8.0
   }
}

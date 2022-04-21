//
//  selectAreaVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/04/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class selectAreaVC:UIViewController {
    
    
    var areaNameJaArray:[String] = []
    var areaName:String?
    
    @IBOutlet weak var areaNameCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        switch areaName {
        case "北海道・東北":
            areaNameJaArray = ["北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県"]
            
        case "関東":
            areaNameJaArray = ["茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県"]
       
        case "中部":
            areaNameJaArray = ["新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県","愛知県"]
   
        case "近畿":
            areaNameJaArray = ["三重県","滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県"]
            
        case "中国・四国":
            areaNameJaArray = ["鳥取県","島根県","岡山県","広島県","山口県","徳島県","香川県","愛媛県","高知県"]
            
        case "九州・沖縄":
            areaNameJaArray = ["福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"]
            
        default:
            areaNameJaArray = ["北海道・東北","関東","中部","近畿","中国・四国","九州・沖縄"]

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
        
        if areaName == nil {
//            let storyboard = UIStoryboard.init(name: "selectArea", bundle: nil)
//            let selectAreaVC = storyboard.instantiateViewController(withIdentifier: "selectAreaVC") as! selectAreaVC
////            selectAreaVC.modalPresentationStyle = .fullScreen
//            selectAreaVC.areaName = areaNameJaArray[indexPath.row]
//            self.present(selectAreaVC, animated: true, completion: nil)
            
            let storyboard = UIStoryboard.init(name: "selectArea", bundle: nil)
            let selectAreaVC = storyboard.instantiateViewController(withIdentifier: "selectAreaVC") as! selectAreaVC
            selectAreaVC.areaName = areaNameJaArray[indexPath.row]
            navigationController?.pushViewController(selectAreaVC, animated: true)
            
      
            
        } else {
            let storyboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let TabbarController = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
            TabbarController.selectedIndex = 1
            TabbarController.modalPresentationStyle = .fullScreen
            self.present(TabbarController, animated: true, completion: nil)        }
        
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 20
        let cellSize : CGFloat = self.view.bounds.width / 3 - horizontalSpace
        
        return CGSize(width: cellSize, height: cellSize)
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

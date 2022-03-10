//
//  FontCollectionVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/03/09.
//

import UIKit

class FontCollectionVC:UIViewController {
    
    
    let fontArray = [
        "Bearandloupe-Bold",
        "BistroSketch",
        "Camden-Regular",
        "Daniel-Bold",
        "Debby",
        "DoodlePen",
        "GrutchShaded",
        "MyFont-Regular",
        "Julies",
        "KBCuriousSoul",
        "KeyTabMetal",
        "Lackey",
        "LoveYaLikeASister",
        "LovingYou",
        "LunaBar",
        "MadeWithB",
        "mami-candy",
        "Mayonaise",
        "MonikaItalic",
        "MoonFlower",
        "MTFCupcake",
        "Pappo'sBluesBandOfficialFont",
        "pastel",
        "REIS-Regular",
        "Sketchica",
        "Skinnybastard-Regular",
        "Southpaw",
        "SweetPineapple-Regular",
    ]
    
    
    @IBOutlet weak var fontCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fontCollectionView.dataSource = self
        fontCollectionView.delegate = self
        
        
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // セルのサイズ
        flowLayout.itemSize = CGSize(width: 150.0, height: 150.0)
        // 縦・横のスペース
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.minimumInteritemSpacing = 12.0
        //  スクロールの方向
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        // 上で設定した内容を反映させる
        self.fontCollectionView.collectionViewLayout = flowLayout
        // 背景色を設定
        self.fontCollectionView?.backgroundColor = .clear
    }
}

extension FontCollectionVC:UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fontArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! fontCollectionViewCell// 表示するセルを登録(先程命名した"Cell")
        
        cell.fontNameLabel.text = fontArray[indexPath.row]

        cell.fontLabel.font = UIFont(name:fontArray[indexPath.row], size:40)
        print(indexPath.row)
        
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.presentingViewController as! CollectionPostVC
        vc.fontString = fontArray[indexPath.row]
        vc.wordCountLabel.font = UIFont(name:fontArray[indexPath.row], size:40)
        self.dismiss(animated: true, completion: nil)

        print(fontArray[indexPath.row])
    }
    
    
}

class fontCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var fontLabel: UILabel!
    @IBOutlet weak var fontNameLabel: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // cellの枠の太さ
//        self.layer.borderWidth = 1.0
        // cellの枠の色
//        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        backgroundColor = .gray

    }
}

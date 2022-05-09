//
//  MunicipalitiesSelectVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/05/09.
//

import UIKit
import Nuke

class MunicipalitiesSelectVC:UIViewController {
    private let cellId = "cellId"
    var municipalities:[String] = []
    var areaBlockJa:[String] = []
    var areaNameEn:String?
    var areaBlockDetails:String?

    @IBOutlet weak var explainImageView: UIImageView!
    @IBOutlet weak var explainImageHeight: NSLayoutConstraint!
    @IBOutlet weak var areaBlockTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        areaBlockTableView.delegate = self
        areaBlockTableView.dataSource = self
        let appFrameHeight = UIScreen.main.applicationFrame.size.height
        let navigationController: UINavigationController = UINavigationController()
        let navigationBarHeight = navigationController.navigationBar.frame.size.height
        let safeAreaHeight = appFrameHeight - navigationBarHeight
        explainImageHeight.constant = safeAreaHeight/2
        
        
        
        switch areaNameEn {
        case "tokyo":
            areaBlockJa = ["城北","城東","都心","城南","城西","北多摩","南多摩","西多摩"]
            print("亜教えfj",areaBlockJa)
            if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Settings%2Fexplain%2FtokyoArea.001.png?alt=media&token=c3dc08d4-b738-458a-9cc5-608e6ad29505") {
                Nuke.loadImage(with: url, into: explainImageView)
            } else {
                explainImageView?.image = nil
            }
        case "saitama":
            areaBlockJa = ["北部","東部","中央","西部","秩父"]
            print("亜教えfj",areaBlockJa)
            if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Settings%2Fexplain%2FsaitamaArea.001.png?alt=media&token=3b768e53-08c9-4a33-aa66-66e78a3e5d52") {
                Nuke.loadImage(with: url, into: explainImageView)
            } else {
                explainImageView?.image = nil
            }
        case"chiba":
            areaBlockJa = ["北総","九十九里","南房総","かずさ・臨海","ベイエリア","東葛飾"]
            print("亜教えfj",areaBlockJa)
            if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Settings%2Fexplain%2FchibaArea.001.png?alt=media&token=f08bee12-8170-49d9-b1b4-f76034c24a76") {
                Nuke.loadImage(with: url, into: explainImageView)
            } else {
                explainImageView?.image = nil
            }
        case "kanagawa":
            areaBlockJa = ["川崎","横浜","横須賀三浦","県央","湘南","県西"]
            print("亜教えfj",areaBlockJa)
            if let url = URL(string:"https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Settings%2Fexplain%2FkanagawaArea.001.png?alt=media&token=17eaaf2c-6771-4a59-9a95-5efc318a2188") {
                Nuke.loadImage(with: url, into: explainImageView)
            } else {
                explainImageView?.image = nil
            }
        default:
            print("あしおえjf")
        }
    }
}

extension MunicipalitiesSelectVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        areaBlockTableView.estimatedRowHeight = 120
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        areaBlockJa.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = areaBlockTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! areaBlockTableViewCell
        
        cell.areaNameLabel.font = UIFont(name: "03SmartFontUI", size: 21)
        cell.areaDetailLabel.font = UIFont(name: "03SmartFontUI", size: 17)

    
        
        switch areaBlockJa[indexPath.row] {
        case"城北":
            cell.areaDetailLabel.text = "北区、板橋区、豊島区、足立区、荒川区"
            cell.areaNameLabel.textColor = #colorLiteral(red: 0.9911803603, green: 0.9401426911, blue: 0, alpha: 1)
        case"城東":
            cell.areaDetailLabel.text = "台東区、墨田区、江東区、葛飾区、江戸川区"
            cell.areaNameLabel.textColor = #colorLiteral(red: 0, green: 0.6596467495, blue: 0.9305914044, alpha: 1)

        case"都心":
            cell.areaDetailLabel.text = "千代田区、中央区、港区、渋谷区、新宿区、文京区"
            cell.areaNameLabel.textColor = #colorLiteral(red: 1, green: 0.1306549311, blue: 0.3034612238, alpha: 1)


        case"城南":
            cell.areaDetailLabel.text = "品川区、目黒区、大田区"
            cell.areaNameLabel.textColor = #colorLiteral(red: 0.9818391204, green: 0.5070236921, blue: 0.9163169861, alpha: 1)

            
        case"城西":
            cell.areaDetailLabel.text = "練馬区、中野区、杉並区、世田谷区"
            cell.areaNameLabel.textColor = #colorLiteral(red: 0.2266518474, green: 0.943392694, blue: 0.5505039096, alpha: 1)


        case"北多摩":
            cell.areaDetailLabel.text = "三鷹市、調布市、小金井市、府中市、武蔵野市、狛江市、東村山市、小平市、国分寺市、国立市、東大和市、清瀬市、東久留米市、武蔵村山市、西東京市、立川市、昭島市"
            cell.areaNameLabel.textColor = #colorLiteral(red: 1, green: 0.5246978998, blue: 0, alpha: 1)

        case"南多摩":
            cell.areaDetailLabel.text = "八王子市、日野市、町田市、多摩市、稲城市"
            cell.areaNameLabel.textColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)

            
        case"西多摩":
            cell.areaDetailLabel.text = "青梅市、羽村市、あきる野市、福生市、日の出町、瑞穂町、檜原市、奥多摩町"
            cell.areaNameLabel.textColor = .darkGray
            
            
        case"北部":
            cell.areaDetailLabel.text = "上里町、神川町、寄居町、深谷市、熊谷市、本庄市、美里町"
            cell.areaNameLabel.textColor = #colorLiteral(red: 0.9818391204, green: 0.5070236921, blue: 0.9163169861, alpha: 1)

        case"東部":
            cell.areaDetailLabel.text = "春日部市、加須市、行田市、久喜市、越谷市、幸手市、白岡市、杉戸町、草加市、蓮田市、羽生市、松伏町、三郷市、宮代町、八潮市、吉川市"
            cell.areaNameLabel.textColor = #colorLiteral(red: 1, green: 0.5246978998, blue: 0, alpha: 1)

        case"中央":
            cell.areaDetailLabel.text = "上尾市、伊奈町、桶川市、川口市、北本市、鴻巣市、さいたま市、戸田市、蕨市"
            cell.areaNameLabel.textColor = #colorLiteral(red: 1, green: 0.1306549311, blue: 0.3034612238, alpha: 1)


        case"西部":
            cell.areaDetailLabel.text = "朝霞市、入間市、小川町、越生町、川越市、川島町、坂戸市、狭山市、志木市、鶴ヶ島市、ときがわ町、所沢市、滑川町、新座市、鳩山町、飯能市、東秩父村、東松山市、日高市、ふじみ野市、富士見市、三芳町、毛呂山町、吉見町、嵐山町、和光市"
            cell.areaNameLabel.textColor = #colorLiteral(red: 0, green: 0.6596467495, blue: 0.9305914044, alpha: 1)

            
        case"秩父":
            cell.areaDetailLabel.text = "秩父市、小鹿野町、長瀞町、皆野町、横瀬町"
            cell.areaNameLabel.textColor = #colorLiteral(red: 0.2266518474, green: 0.943392694, blue: 0.5505039096, alpha: 1)
            
        case"北総":
            cell.areaDetailLabel.text = "白井市、印西市、佐倉市、八街市、酒々井市、成田市、栄町、富里市、芝山町、多古町、神崎町、香取市、東庄町、銚子市"
            cell.areaNameLabel.textColor = #colorLiteral(red: 0, green: 0.6596467495, blue: 0.9305914044, alpha: 1)


        case"九十九里":
            cell.areaDetailLabel.text = "旭市、匝瑳市、横芝光町、山武市、東金市、九十九里町、大網白里市、白子市、長生村、長柄町、長南町、白子町、一宮町、睦沢町"
            cell.areaNameLabel.textColor = #colorLiteral(red: 0.9911803603, green: 0.9401426911, blue: 0, alpha: 1)


        case"南房総":
            cell.areaDetailLabel.text = "鋸南町、南房総市、館山市、鴨川市、大多喜町、勝浦市、御宿町、いすみ市"
            cell.areaNameLabel.textColor = #colorLiteral(red: 0.9818391204, green: 0.5070236921, blue: 0.9163169861, alpha: 1)


        case"かずさ・臨海":
            cell.areaDetailLabel.text = "市原市、袖ヶ浦市、木更津市、君津市、富津市"
            cell.areaNameLabel.textColor = #colorLiteral(red: 1, green: 0.5246978998, blue: 0, alpha: 1)


        case"ベイエリア":
            cell.areaDetailLabel.text = "千葉市、習志野市、船橋市、市川市、浦安市、四街道市、八千代市"
            cell.areaNameLabel.textColor = #colorLiteral(red: 0.2266518474, green: 0.943392694, blue: 0.5505039096, alpha: 1)


        case"東葛飾":
            cell.areaDetailLabel.text = "鎌ケ谷市、松戸市、我孫子市、柏市、流山市、野田市"
            cell.areaNameLabel.textColor = #colorLiteral(red: 1, green: 0.1306549311, blue: 0.3034612238, alpha: 1)

            
        case"川崎":
            cell.areaDetailLabel.text = "川崎市"
            cell.areaNameLabel.textColor = #colorLiteral(red: 1, green: 0.1306549311, blue: 0.3034612238, alpha: 1)


        case"横浜":
            cell.areaDetailLabel.text = "横浜市"
            cell.areaNameLabel.textColor = #colorLiteral(red: 0, green: 0.6596467495, blue: 0.9305914044, alpha: 1)


        case"横須賀三浦":
            cell.areaDetailLabel.text = "横須賀市、鎌倉市、逗子市、三浦市、葉山町"
            cell.areaNameLabel.textColor = #colorLiteral(red: 0.9911803603, green: 0.9401426911, blue: 0, alpha: 1)


        case"県央":
            cell.areaDetailLabel.text = "相模原市、厚木市、大和市、海老名市、座間市、綾瀬市、愛川町、清川村"
            cell.areaNameLabel.textColor = #colorLiteral(red: 0.2266518474, green: 0.943392694, blue: 0.5505039096, alpha: 1)


        case"湘南":
            cell.areaDetailLabel.text = "平塚市、藤沢市、茅ヶ崎市、秦野市、伊勢原市、寒川町、大磯町、二宮町"
            cell.areaNameLabel.textColor = #colorLiteral(red: 0.9818391204, green: 0.5070236921, blue: 0.9163169861, alpha: 1)


        case"県西":
            cell.areaDetailLabel.text = "小田原市、南足柄市、中井町、大井町、松田町、山北町、開成町、箱根町、真鶴町、湯河原町"
            cell.areaNameLabel.textColor = #colorLiteral(red: 1, green: 0.5246978998, blue: 0, alpha: 1)


        default:
            print("アセいおfj")
        }
        
        cell.areaNameLabel.text = areaBlockJa[indexPath.row]
        return cell
    }
}

class areaBlockTableViewCell:UITableViewCell {
    
    @IBOutlet weak var areaNameLabel: UILabel!
    
    @IBOutlet weak var areaDetailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

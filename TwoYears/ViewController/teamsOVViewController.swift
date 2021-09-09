//
//  teamsOVViewController.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/05/28.
//

import UIKit
import FirebaseFirestore
import Firebase
import Lottie

class teamsOVViewController: UIViewController {
    @IBOutlet weak var orangeTitle: UILabel!
    @IBOutlet weak var violetTitle: UILabel!
    @IBOutlet weak var redyellowLabel: UILabel!
    @IBOutlet weak var bluepurpleLabel: UILabel!
    @IBOutlet weak var TotalPointLabel: UILabel!
    @IBOutlet weak var orangeLabel: CountAnimationLabel!
    @IBOutlet weak var violetLabel: CountAnimationLabel!
    @IBOutlet weak var lottieUnderView: UIView!
    var animationView = AnimationView()
    var minusInt : Float?
    var totalcount : Float?
    var totalpluscount: Float?
    var totalparcount: Float?
    var totalcountrule : Float?
    var titlelabelColor : UIColor?
    let orangeViewCount : Float? = UserDefaults.standard.float(forKey: "orangeViewCount")
    let violetViewCount : Float? = UserDefaults.standard.float(forKey: "violetViewCount")
    @IBOutlet weak var underView: UIView!
    let screenSize = UIScreen.main.bounds
    override func viewDidLoad() {
        super.viewDidLoad()
        underView.backgroundColor = #colorLiteral(red: 0.5, green: 0.3315496575, blue: 1, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 1, green: 0.4897527825, blue: 0, alpha: 1)
        orangeTitle.textColor = #colorLiteral(red: 1, green: 0.4897527825, blue: 0, alpha: 1)
        redyellowLabel.textColor = #colorLiteral(red: 1, green: 0.4897527825, blue: 0, alpha: 1)
        orangeLabel.textColor = #colorLiteral(red: 1, green: 0.4897527825, blue: 0, alpha: 1)
        violetTitle.textColor = #colorLiteral(red: 0.5, green: 0.3315496575, blue: 1, alpha: 1)
        bluepurpleLabel.textColor = #colorLiteral(red: 0.5, green: 0.3315496575, blue: 1, alpha: 1)
        violetLabel.textColor = #colorLiteral(red: 0.5, green: 0.3315496575, blue: 1, alpha: 1)
        orangeTitle.clipsToBounds = true
        violetTitle.clipsToBounds = true
        redyellowLabel.clipsToBounds = true
        bluepurpleLabel.clipsToBounds = true
        TotalPointLabel.clipsToBounds = true
        orangeLabel.clipsToBounds = true
        violetLabel.clipsToBounds = true
        orangeTitle.layer.cornerRadius = 10
        violetTitle.layer.cornerRadius = 10
        redyellowLabel.layer.cornerRadius = 10
        bluepurpleLabel.layer.cornerRadius = 10
        TotalPointLabel.layer.cornerRadius = 15
        orangeLabel.layer.cornerRadius = 20
        violetLabel.layer.cornerRadius = 20
        TotalPointLabel.text = "  TOTALGOOD  "
        orangeLabel.animate(from: Int(orangeViewCount!)/2, to: Int(orangeViewCount!), duration: 1)
        violetLabel.animate(from: Int(violetViewCount!)/2, to: Int(violetViewCount!), duration: 1)
        print ("orange",orangeViewCount!)
        print ("violet",violetViewCount!)
        if orangeViewCount! - violetViewCount! > 0 {
            minusInt = -1
            titlelabelColor = #colorLiteral(red: 1, green: 0.4897527825, blue: 0, alpha: 1)
        } else if orangeViewCount! - violetViewCount! < 0 {
            minusInt = 1
            titlelabelColor = #colorLiteral(red: 0.5, green: 0.3315496575, blue: 1, alpha: 1)
        } else {
            minusInt = 1
            titlelabelColor = .systemGreen
        }
        
        print("aaaaaaa",minusInt!)
        totalcount = orangeViewCount! - violetViewCount!
        print("totalcount",totalcount!)
        totalpluscount = orangeViewCount! + violetViewCount!
        print("計算！！！！",orangeViewCount!/totalpluscount!*100)
        print("計算２!!!",violetViewCount!/totalpluscount!*100)
        totalparcount = (orangeViewCount!/totalpluscount!*100) - (violetViewCount!/totalpluscount!*100)
        print("トータルパーカウント！！",totalparcount!)
        if abs(totalparcount!) > 30 {
            totalcountrule = 0.6
        } else if abs(totalparcount!) > 25 {
            totalcountrule = 0.5
        } else if abs(totalparcount!) > 20 {
            totalcountrule = 0.45
        } else if abs(totalparcount!) > 15{
            totalcountrule = 0.4
        } else if abs(totalparcount!) > 12{
            totalcountrule = 0.35
        } else if abs(totalparcount!) > 9{
            totalcountrule = 0.3
        } else if abs(totalparcount!) > 7{
            totalcountrule = 0.25
        } else if abs(totalparcount!) > 5{
            totalcountrule = 0.2
        } else if abs(totalparcount!) > 3{
            totalcountrule = 0.15
        } else if abs(totalparcount!) > 1{
            totalcountrule = 0.1
        } else {
            totalcountrule = 0.0
        }
        print("entio",totalcountrule!)
        let moveheight = screenSize.size.height/2
        UIView.animate(withDuration: 0.65, delay: 0.15, animations: {
            self.underView.transform = CGAffineTransform(translationX: 0, y: moveheight * 0.05 * CGFloat(self.minusInt!))
        }) { bool in
            // ②アイコンを大きくする
            UIView.animate(withDuration: 0.2, delay: 0, animations: {
                self.TotalPointLabel.textColor = self.titlelabelColor
                self.underView.transform = CGAffineTransform(translationX: 0, y: -moveheight * CGFloat(self.totalcountrule!) * CGFloat(self.minusInt!))
                self.orangeLabel.transform = CGAffineTransform(translationX: 0, y: -moveheight * CGFloat(self.totalcountrule!) * CGFloat(self.minusInt!) * 0.5)
                self.violetLabel.transform = CGAffineTransform(translationX: 0, y: -moveheight * CGFloat(self.totalcountrule!) * CGFloat(self.minusInt!) * 0.5)
                self.TotalPointLabel.transform = CGAffineTransform(translationX: 0, y: -moveheight * CGFloat(self.totalcountrule!) * CGFloat(self.minusInt!) * 0.5)
                self.orangeTitle.transform = CGAffineTransform(translationX: 0, y: -moveheight * CGFloat(self.totalcountrule!) * CGFloat(self.minusInt!) * 0.5)
                self.violetTitle.transform = CGAffineTransform(translationX: 0, y: -moveheight * CGFloat(self.totalcountrule!) * CGFloat(self.minusInt!) * 0.5)
                self.redyellowLabel.transform = CGAffineTransform(translationX: 0, y: -moveheight * CGFloat(self.totalcountrule!) * CGFloat(self.minusInt!) * 0.5)
                self.bluepurpleLabel.transform = CGAffineTransform(translationX: 0, y: -moveheight * CGFloat(self.totalcountrule!) * CGFloat(self.minusInt!) * 0.5)
            }) }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.addAnimationView()
        lottieUnderView.alpha = 0
        UIView.animate(withDuration: 0.6, delay: 0, animations: {
            self.lottieUnderView.alpha = 1
        })
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        animationView.removeFromSuperview()
    }
    func addAnimationView() {
        //アニメーションファイルの指定
        animationView = AnimationView(name: "red_yellow")
        //ここに先ほどダウンロードしたファイル名を記述（拡張子は必要なし）
        //アニメーションの位置指定（画面中央）
        animationView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        //アニメーションのアスペクト比を指定＆ループで開始
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        lottieUnderView.addSubview(animationView)
    }
}

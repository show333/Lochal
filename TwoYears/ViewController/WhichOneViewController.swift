//
//  WhichOne.swift
//  protain
//
//  Created by 平田翔大 on 2021/02/16.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore


class WhichOneViewController: UIViewController {
    let uid = Auth.auth().currentUser?.uid
    var excount = 0
    private var firstAppear: Bool = false
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var explain2Label: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var beginLabel: UILabel!
    @IBOutlet weak var irastoyaImage: UIImageView!
    @IBOutlet weak var irastoyaImage2: UIImageView!
    @IBOutlet weak var irastoyaImage3: UIImageView!
    @IBOutlet weak var irastoyaImage4: UIImageView!
    @IBOutlet weak var irastoyaImage5: UIImageView!
    @IBOutlet weak var irastoyaImage6: UIImageView!
    @IBOutlet weak var irastoyaImage7: UIImageView!
    @IBOutlet weak var irastoyaImage8: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextTappedButton(_ sender: UIButton) {
        print(excount)
        print("センダー！！",sender.tag)
        if sender.tag == 1 {
            excount += 1
        } else if sender.tag == 0 {
            if excount >= 1 {
                excount -= 1
            }
        }
        if excount == 0 {
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.explain2Label.text = "WELCOME!\nTO\nTOTALGOOD"
                self.explainLabel.alpha = 0
                self.explain2Label.alpha = 1
                self.nextLabel.text = "次へ"
                self.backLabel.text = "戻る"
                self.beginLabel.text = "OK"
                self.nextLabel.alpha = 1
                self.backLabel.alpha = 0
                self.beginLabel.alpha = 0
                self.irastoyaImage.alpha = 0
            })
        }
        else if excount == 1 {
            explainLabel.text = "このアプリの説明を行います"
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.explainLabel.alpha = 1
                self.explain2Label.alpha = 0
                self.backLabel.alpha = 1
                self.irastoyaImage.alpha = 1
                
            })
        } else if excount == 2 {
            explain2Label.text = "このサービスは匿名性の\nSNSです!"
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.explainLabel.alpha = 0
                self.explain2Label.alpha = 1
                self.irastoyaImage.alpha = 1
                self.irastoyaImage2.alpha = 0
            })
            
        } else if excount == 3 {
            explainLabel.text = "個人の性別や年齢、ニックネームなどは設定する必要はありません\n\n(設定することは可能です)"
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.explainLabel.alpha = 1
                self.explain2Label.alpha = 0
                self.irastoyaImage.alpha = 0
                self.irastoyaImage2.alpha = 1
                self.irastoyaImage3.alpha = 0
            })
        } else if excount == 4 {
            explain2Label.text = "しかし、匿名性では\n誹謗中傷、悪質コメントが増える傾向にあります。"
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.explainLabel.alpha = 0
                self.explain2Label.alpha = 1
                self.irastoyaImage2.alpha = 0
                self.irastoyaImage3.alpha = 1
                self.irastoyaImage4.alpha = 0
            })
        } else if excount == 5 {
            explainLabel.text = "それらを防ぐために、\nこのサービスではチーム制を導入しました！"
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.explainLabel.alpha = 1
                self.explain2Label.alpha = 0
                self.irastoyaImage3.alpha = 0
                self.irastoyaImage4.alpha = 1
            })
        } else if excount == 6 {
            explain2Label.text = "チーム制とは従来の個人と個人が\nやりとりを行うSNSとは異なり、"
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.explainLabel.alpha = 0
                self.explain2Label.alpha = 1
                self.irastoyaImage4.alpha = 1
                self.irastoyaImage5.alpha = 0
            })
        } else if excount == 7 {
            explainLabel.text = "団体、グループに所属してもらい、\n「そのグループに所属している誰か」"
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.explainLabel.alpha = 1
                self.explain2Label.alpha = 0
                self.irastoyaImage4.alpha = 0
                self.irastoyaImage5.alpha = 1
            })
        } else if excount == 8 {
            explain2Label.text = "というプロフィールを一人一人が持つことになります"
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.explainLabel.alpha = 0
                self.explain2Label.alpha = 1
                self.irastoyaImage5.alpha = 1
                self.irastoyaImage6.alpha = 0
            })
        } else if excount == 9 {
            explainLabel.text = "これにより、同じグループの方には誹謗中傷が減り、"
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.explainLabel.alpha = 1
                self.explain2Label.alpha = 0
                self.irastoyaImage5.alpha = 0
                self.irastoyaImage6.alpha = 1
            })
        } else if excount == 10 {
            explain2Label.text = "他のグループの方に対して悪質コメントをしていた場合は"
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.explainLabel.alpha = 0
                self.explain2Label.alpha = 1
            })
        } else if excount == 11 {
            explainLabel.text = "同じグループの方が注意、通報をしてもらう事で"
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.explainLabel.alpha = 1
                self.explain2Label.alpha = 0
                self.irastoyaImage6.alpha = 1
                self.irastoyaImage7.alpha = 0
            })
        } else if excount == 12 {
            explain2Label.text = "クリーンなSNSになる事を狙いとしています！"
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.explainLabel.alpha = 0
                self.explain2Label.alpha = 1
                self.irastoyaImage6.alpha = 0
                self.irastoyaImage7.alpha = 1
            })
        } else if excount == 13 {
            explainLabel.text = "それでは、"
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.explainLabel.alpha = 1
                self.explain2Label.alpha = 0
                self.irastoyaImage7.alpha = 0
            })
        } else if excount == 14 {
            explain2Label.text = "一番最初のグループ分けを行いたいと思います！"
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.explainLabel.alpha = 0
                self.explain2Label.alpha = 1
                self.irastoyaImage8.alpha = 0
            })
        } else if excount == 15 {
            explainLabel.text = "全15問、二択で考え方の近い方を選んでいただき、"
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.explainLabel.alpha = 1
                self.explain2Label.alpha = 0
                self.irastoyaImage8.alpha = 1
            })
        } else if excount == 16 {
            explain2Label.text = "それらの診断結果をもとに\nあなたのチームが決まります！"
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.explainLabel.alpha = 0
                self.explain2Label.alpha = 1
                self.beginLabel.alpha = 0
                self.nextLabel.alpha = 1
                self.irastoyaImage8.alpha = 1
            })
        }else if excount == 17 {
            explainLabel.text = "準備はいいですか？"
            UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.explainLabel.alpha = 1
                self.explain2Label.alpha = 0
                self.beginLabel.alpha = 1
                self.nextLabel.alpha = 0
                self.irastoyaImage8.alpha = 0
            })
        }else if excount == 18 {
            
            performSegue(withIdentifier: "toQuizVC", sender: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        explainLabel.numberOfLines = 0
        explainLabel.lineBreakMode = .byWordWrapping
        explain2Label.numberOfLines = 0
        explain2Label.lineBreakMode = .byWordWrapping
        UIView.animate(withDuration: 1, delay: 1, options: UIView.AnimationOptions.allowUserInteraction, animations: {
            self.explainLabel.alpha = 0
            self.explain2Label.alpha = 1
        })
        backImage.image = UIImage(named:"tree")!
        view.backgroundColor = #colorLiteral(red: 0, green: 0.9052245021, blue: 0.6851730943, alpha: 1)
        irastoyaImage.image = UIImage(named: "setumei")
        irastoyaImage2.image = UIImage(named: "character")
        irastoyaImage3.image = UIImage(named: "depressed")
        irastoyaImage4.image = UIImage(named: "nakayoku")
        irastoyaImage5.image = UIImage(named: "group")
        irastoyaImage6.image = UIImage(named: "sns")
        irastoyaImage7.image = UIImage(named: "peace")
        irastoyaImage8.image = UIImage(named: "choice")
        self.explain2Label.text = "WELCOME!\nTO\nTOTALGOOD"
        self.nextLabel.text = "次へ"
        self.backLabel.text = "戻る"
        self.beginLabel.text = "OK"
        self.nextLabel.alpha = 1
        self.backLabel.alpha = 0
        self.beginLabel.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !firstAppear {
            let storyboard: UIStoryboard = UIStoryboard(name: "EULA", bundle: nil)//遷移先のStoryboardを設定
            let EULAViewController = storyboard.instantiateViewController(withIdentifier: "EULAViewController") //遷移先のTabbarController指定とIDをここに入力
            EULAViewController.modalPresentationStyle = .fullScreen
            self.present(EULAViewController, animated: true, completion: nil)
            firstAppear = true
        }
    }
}

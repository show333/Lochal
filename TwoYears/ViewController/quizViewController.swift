//
//  quizViewController.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/04/08.
//

import UIKit
import Lottie
import Nuke

class quizViewController : UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var upLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var lowButton: UIButton!
    
    var csvArray: [String] = []
    var quizArray: [String] = []
    var quizCount = 0
    var correctCountRed : Double = 0.0
    var correctCountBlue : Double = 0.0
    var correctCountYellow : Double = 0.0
    var correctCountPurple : Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0, green: 0.9052245021, blue: 0.6851730943, alpha: 1)
        csvArray = loadCSV(fileName: "quiz")
        

        upButton.imageView?.contentMode = .scaleAspectFill
//        upButton.contentHorizontalAlignment = .fill
//        upButton.contentVerticalAlignment = .fill
        
        lowButton.imageView?.contentMode = .scaleAspectFill
//        lowButton.contentHorizontalAlignment = .fill
//        lowButton.contentVerticalAlignment = .fill
        
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.numberOfLines = 0
        upLabel.numberOfLines = 0
        lowLabel.numberOfLines = 0
        if let url = URL(string:" rurubus[indexPath.row].sendImageURL") {
//            Nuke.loadImage(with: url, into: cell.sendImageView!)
//            Nuke.loadimage
        }
        
        quizArray = csvArray[quizCount].components(separatedBy: ",")
        questionLabel.text = quizArray[0]
        upButton.setImage(UIImage(named:"dog"), for: .normal)
        lowButton.setImage(UIImage(named:"cat"), for: .normal)
        upLabel.text = quizArray[2]
        lowLabel.text = quizArray[3]
    }
    func nextQuiz() {
        quizCount += 1
        if quizCount < csvArray.count {
            UIView.animate(withDuration: 0.2, delay: 0, animations: {
                self.frontView.alpha = 1
            }){ (completed)in
                UIView.animate(withDuration: 0.4, delay: 0.0, animations: { [self] in
                    frontLabel.text = "next!"
                    frontLabel.alpha = 1
                }) {(completed) in
                    UIView.animate(withDuration: 0.3, delay: 0.35, animations: { [self] in
                        self.frontView.alpha = 0
                        quizArray = csvArray[quizCount].components(separatedBy: ",")
                        questionLabel.text = quizArray[0]
                        upButton.setImage(UIImage(named:quizArray[4]), for: .normal)
                        lowButton.setImage(UIImage(named:quizArray[5]), for: .normal)
                        
                        upLabel.text = quizArray[2]
                        lowLabel.text = quizArray[3]
                    }) }
                
            }
            
            


        } else {
            performSegue(withIdentifier: "toScoreVC", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let scoreVC = segue.destination as! ScoreViewController
        scoreVC.correctRed = correctCountRed
        scoreVC.correctBlue = correctCountBlue
        scoreVC.correctYellow = correctCountYellow
        scoreVC.correctPurple = correctCountPurple
    }
    
    @IBAction func upperButton(_ sender: UIButton) {

        
        let rednum : Double = 10/7
        let bluenum : Double = 10/8
        let yellownum : Double = 10/10
        let purplenum : Double = 10/6
        
        if quizCount == 0{
        if sender.tag == Int(quizArray[1]) {
//            いぬとねこ
            correctCountRed += rednum

        } else {
            correctCountBlue += bluenum
        }
            print("レッド,ブルー,イエロー,パープル", correctCountRed,correctCountBlue,correctCountYellow,correctCountPurple)
            nextQuiz()
        } else if quizCount == 1{
            if sender.tag == Int(quizArray[1]) {
//                朝のアラーム複数回か一回
            } else {
                correctCountBlue += bluenum
            }
            print("レッド,ブルー,イエロー,パープル", correctCountRed,correctCountBlue,correctCountYellow,correctCountPurple)

            nextQuiz()
        } else if quizCount == 2{
            if sender.tag == Int(quizArray[1]) {
//                ドラマに出演することになった、相棒or宿敵
                correctCountRed += rednum
                correctCountYellow += yellownum

            } else {
                correctCountPurple += purplenum
            }
            print("レッド,ブルー,イエロー,パープル", correctCountRed,correctCountBlue,correctCountYellow,correctCountPurple)

            nextQuiz()
        } else if quizCount == 3{
            if sender.tag == Int(quizArray[1]) {
//                紹介したいのはどっち？お洒落or面白い
                correctCountPurple += purplenum

            } else {
                correctCountYellow += yellownum

            }
            print("レッド,ブルー,イエロー,パープル", correctCountRed,correctCountBlue,correctCountYellow,correctCountPurple)

            nextQuiz()
        } else if quizCount == 4{
            if sender.tag == Int(quizArray[1]) {
//                印象に残っている人数5人以上or4人以下

            } else {
                correctCountBlue += bluenum
            }
            print("レッド,ブルー,イエロー,パープル", correctCountRed,correctCountBlue,correctCountYellow,correctCountPurple)

            nextQuiz()
        } else if quizCount == 5{
            if sender.tag == Int(quizArray[1]) {
//                友人が奇抜な格好をしてきたいじりたくなる個性と認識
                correctCountYellow += yellownum
            } else {
                correctCountBlue += bluenum 
            }
            print("レッド,ブルー,イエロー,パープル", correctCountRed,correctCountBlue,correctCountYellow,correctCountPurple)

            nextQuiz()
        } else if quizCount == 6{
            if sender.tag == Int(quizArray[1]) {
//                海外映画字幕or吹き替え
                correctCountRed += rednum
                correctCountYellow += yellownum

            } else {
                correctCountBlue += bluenum
                correctCountPurple += purplenum 
            }
            print("レッド,ブルー,イエロー,パープル", correctCountRed,correctCountBlue,correctCountYellow,correctCountPurple)

            nextQuiz()
        } else if quizCount == 7{
            if sender.tag == Int(quizArray[1]) {
//                努力は報われる？YES or NO
                correctCountRed += rednum


            } else {
            }
            print("レッド,ブルー,イエロー,パープル", correctCountRed,correctCountBlue,correctCountYellow,correctCountPurple)

            nextQuiz()
        } else if quizCount == 8{
            if sender.tag == Int(quizArray[1]) {
//                いつからが大人だと思う?　卒業したら or 20から
               
            } else {
                correctCountYellow += yellownum
            }
            print("レッド,ブルー,イエロー,パープル", correctCountRed,correctCountBlue,correctCountYellow,correctCountPurple)

            nextQuiz()
        } else if quizCount == 9{
            if sender.tag == Int(quizArray[1]) {
//                昼　or 夜

            } else {
                correctCountPurple += purplenum
            }
            print("レッド,ブルー,イエロー,パープル", correctCountRed,correctCountBlue,correctCountYellow,correctCountPurple)
            
            nextQuiz()
        } else if quizCount == 10{
            if sender.tag == Int(quizArray[1]) {
                //                安定という言葉 退屈 or 安心
                correctCountRed += rednum + 1
                
            } else {
                correctCountYellow += yellownum
            }
            print("レッド,ブルー,イエロー,パープル", correctCountRed,correctCountBlue,correctCountYellow,correctCountPurple)
            
            nextQuiz()
        } else if quizCount == 11{
            if sender.tag == Int(quizArray[1]) {
                //                どちらを押しますか？　今世 or 来世
                correctCountRed += rednum
                correctCountYellow += yellownum
                correctCountPurple += purplenum
            } else {
                correctCountBlue += bluenum
            }
            print("レッド,ブルー,イエロー,パープル", correctCountRed,correctCountBlue,correctCountYellow,correctCountPurple)
            
            nextQuiz()
        } else if quizCount == 12{
            if sender.tag == Int(quizArray[1]) {
//                男女の友情　成立しない or する
                correctCountPurple += purplenum + 1
            } else {
                correctCountBlue += bluenum
                correctCountYellow += yellownum
            }
            print("レッド,ブルー,イエロー,パープル", correctCountRed,correctCountBlue,correctCountYellow,correctCountPurple)

            nextQuiz()
        } else if quizCount == 13{
            if sender.tag == Int(quizArray[1]) {
//                    朝の着替え 見られてる　or 気候
                
            } else {
                correctCountBlue += bluenum

            }
            print("レッド,ブルー,イエロー,パープル", correctCountRed,correctCountBlue,correctCountYellow,correctCountPurple)
            
            nextQuiz()
        } else if quizCount == 14{
            if sender.tag == Int(quizArray[1]) {
//                婚約者 or 親友
                correctCountRed += rednum

            } else {
                correctCountYellow += yellownum
            }
            print("レッド,ブルー,イエロー,パープル", correctCountRed,correctCountBlue,correctCountYellow,correctCountPurple)

            nextQuiz()
        }
    }
    

    
    func loadCSV(fileName: String) -> [String] {
        let csvBundle = Bundle.main.path(forResource: fileName, ofType: "csv")!
        do {
            let csvData = try String(contentsOfFile: csvBundle,encoding: String.Encoding.utf8)
            let lineChange = csvData.replacingOccurrences(of: "\r", with: "\n")
            csvArray = lineChange.components(separatedBy: "\n")
            csvArray.removeLast()
        } catch {
            print("エラー")
        }
        return csvArray
    }
    
}

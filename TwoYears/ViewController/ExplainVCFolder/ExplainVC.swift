//
//  ExplainVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/22.
//



import UIKit
import FirebaseAuth
import FirebaseFirestore
import Nuke

class ExplainVC:UIViewController{
    
    var pageCount: Int = 0
    
    let db = Firestore.firestore()
    
    let imageArray = [
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Explain_Images2%2FnewExplainImage.001.png?alt=media&token=f6065e0b-b9aa-4dde-ac7d-870ab92979bd",//0
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Explain_Images2%2FnewExplainImage.002.png?alt=media&token=13e4d505-319b-4071-a782-24e9901a18f8",//1
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Explain_Images2%2FnewExplainImage.003.png?alt=media&token=5b969cef-01e9-43e5-b03d-dcffcec11d0e",//2
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Explain_Images2%2FnewExplainImage.004.png?alt=media&token=917eaae9-4266-4e14-8636-24cd5bcc864f",//3
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Explain_Images2%2FnewExplainImage.005.png?alt=media&token=79155f03-df5a-431f-bd2e-73ed05b95333",//4
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Explain_Images2%2FnewExplainImage.006.png?alt=media&token=f3e77674-fda7-4c1b-908e-b12bfe259544",//5
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Explain_Images2%2FnewExplainImage.007.png?alt=media&token=dfe439e6-c3dd-4017-b5cb-bbb4f44b5f7c",//6
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Explain_Images2%2FnewExplainImage.008.png?alt=media&token=e4eceb5c-d791-4229-b330-aefdaf350676",//7
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Explain_Images2%2FnewExplainImage.009.png?alt=media&token=dcd11fbc-16bd-4dcd-b205-8a66f455b096",//8
    ]
    
    @IBOutlet weak var explainImageView: UIImageView!
    @IBOutlet weak var explainSecondView: UIImageView!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBAction func rightTappedButton(_ sender: Any) {
        if pageCount < 8 {
            pageCount += 1
        } else {
            
            let storyboard = UIStoryboard.init(name: "FirstSetName", bundle: nil)
            let FirstSetNameVC = storyboard.instantiateViewController(withIdentifier: "FirstSetNameVC") as! FirstSetNameVC
            navigationController?.pushViewController(FirstSetNameVC, animated: true)
            
        }
        
        
        backLabel.alpha = 1
        print(pageCount)

        if pageCount % 2 == 1 {
            explainImageView.alpha = 1
            explainSecondView.alpha = 0
        } else {
            explainImageView.alpha = 1
            explainSecondView.alpha = 0
        }

        if let url = URL(string:imageArray[pageCount]) {
            Nuke.loadImage(with: url, into: explainImageView)
        } else {
            explainImageView?.image = nil
        }

        if pageCount == 8 {
            if let url = URL(string:imageArray[pageCount-1]) {
                Nuke.loadImage(with: url, into: explainSecondView)
            } else {
                explainSecondView?.image = nil
            }
        } else {
            if let url = URL(string:imageArray[pageCount+1]) {
                Nuke.loadImage(with: url, into: explainSecondView)
            } else {
                explainSecondView?.image = nil
            }
        }
    }
    @IBOutlet weak var leftButton: UIButton!
    
    @IBAction func leftTappedButton(_ sender: Any) {
        if pageCount > 0 {
            pageCount -= 1
        }

        if pageCount % 2 == 1 {
            explainImageView.alpha = 1
            explainSecondView.alpha = 0
        } else {
            explainImageView.alpha = 1
            explainSecondView.alpha = 0
        }
        
        if let url = URL(string:imageArray[pageCount]) {
            Nuke.loadImage(with: url, into: explainImageView)
        } else {
            explainImageView?.image = nil
        }
        
        
        if pageCount == 0 {
            backLabel.alpha = 0
            if let url = URL(string:imageArray[pageCount+1]) {
                Nuke.loadImage(with: url, into: explainSecondView)
            } else {
                explainSecondView?.image = nil
            }
        } else {

            if let url = URL(string:imageArray[pageCount-1]) {
                Nuke.loadImage(with: url, into: explainSecondView)
            } else {
                explainSecondView?.image = nil
            }
        }
    }
    

    
    func randomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in characters.randomElement()! })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        
        

        
        explainSecondView.alpha = 0
        
        backLabel.alpha = 0
        if let url = URL(string:imageArray[pageCount]) {
            Nuke.loadImage(with: url, into: explainImageView)
        } else {
            explainImageView?.image = nil
        }
        
        if let url = URL(string:imageArray[pageCount+1]) {
            Nuke.loadImage(with: url, into: explainSecondView)
        } else {
            explainSecondView?.image = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let iconchoose = UserDefaults.standard.integer(forKey: "EULA")
        if iconchoose == 1 {
        } else {
            let storyboard = UIStoryboard.init(name: "EULA", bundle: nil)
            let brands = storyboard.instantiateViewController(withIdentifier: "EULAViewController")
            brands.modalPresentationStyle = .fullScreen
            self.present(brands, animated: true, completion: nil)
        }
    }
    
}

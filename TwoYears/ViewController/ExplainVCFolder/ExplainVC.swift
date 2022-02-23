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
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImagesConnect.001.png?alt=media&token=77032f71-df0f-4612-95d1-3835021c753f",//0
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImagesConnect.002.png?alt=media&token=257ec466-8d59-4d89-94a1-99270cdcfabf",//1
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImagesConnect.003.png?alt=media&token=15bd2706-7b55-4548-a571-458c1b450c6f",//2
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImagesConnect.004.png?alt=media&token=3a7ec224-0e90-40d0-8919-eae695ec748a",//3
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImagesConnect.005.png?alt=media&token=8a69bf79-dc14-4563-a738-19b6c1a9bbef",//4
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImagesConnect.006.png?alt=media&token=63f2cc7a-e8c4-4467-a801-32c83c6a4cb0",//5
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImagesConnect.007.png?alt=media&token=7a8c6fc2-f77c-42c9-b19c-f84949a5e20a",//6
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImagesConnect.008.png?alt=media&token=719b1b3b-be68-49b7-95ae-64c1a0e22ae2",//7
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImagesConnect.009.png?alt=media&token=a1007b70-4c2f-4185-8fc6-6c882f6cbed3",//8
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImagesConnect.010.png?alt=media&token=9b91e0c4-0f21-4323-bc9b-f21b25b877b4",//9
        
        "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/explain_Images%2FexplainImagesConnect.011.png?alt=media&token=ed655c9c-96e7-42ba-a696-0820f7db5b1f",//10
    ]
    
    @IBOutlet weak var explainImageView: UIImageView!
    @IBOutlet weak var explainSecondView: UIImageView!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBAction func rightTappedButton(_ sender: Any) {
        if pageCount < 10 {
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

        if pageCount == 10 {
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

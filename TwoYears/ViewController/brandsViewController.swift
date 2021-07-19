//
//  brandsViewController.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/04/29.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase

class brandsViewController: UIViewController {
    
    @IBOutlet weak var firstButton: UIButton!
    
    @IBOutlet weak var secondsButton: UIButton!
    
    @IBOutlet weak var thirdButton: UIButton!
    
    @IBOutlet weak var forthButton: UIButton!
    
    @IBOutlet weak var fifthButton: UIButton!
    
    let DBU = Firestore.firestore().collection("users")
    let uid = UserDefaults.standard.string(forKey: "userId")


    
    @IBAction func firstTappedButton(_ sender: Any) {
        DBU.document(uid!).setData(["userBrands": "TG1"], merge: true)
        UserDefaults.standard.set("TG1", forKey: "userBrands")
        UserDefaults.standard.set(true, forKey: "userIcon")
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func secondsTappedButton(_ sender: Any) {
        DBU.document(uid!).setData(["userBrands": "TG2"], merge: true)
        UserDefaults.standard.set("TG2", forKey: "userBrands")
        UserDefaults.standard.set(true, forKey: "userIcon")
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func thirdTappdeButton(_ sender: Any) {
        DBU.document(uid!).setData(["userBrands": "TG3"], merge: true)
        UserDefaults.standard.set("TG3", forKey: "userBrands")
        UserDefaults.standard.set(true, forKey: "userIcon")
        dismiss(animated: true, completion: nil)


    }
    
    @IBAction func forthTappedButton(_ sender: Any) {
        DBU.document(uid!).setData(["userBrands": "TG4"], merge: true)
        UserDefaults.standard.set("TG4", forKey: "userBrands")
        UserDefaults.standard.set(true, forKey: "userIcon")
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func fifthTappedButton(_ sender: Any) {
        DBU.document(uid!).setData(["userBrands": "TG5"], merge: true)
        UserDefaults.standard.set("TG5", forKey: "userBrands")
        UserDefaults.standard.set(true, forKey: "userIcon")
        dismiss(animated: true, completion: nil)

    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let friends = UserDefaults.standard.bool(forKey: "friends")
        let firsttime = UserDefaults.standard.bool(forKey: "firsttime")
        
        if firsttime == true{

            
        } else {
            let storyboard = UIStoryboard(name: "thanksfriends", bundle: nil)
            let thanksfriends = storyboard.instantiateViewController(withIdentifier: "thanksfriends") as! thanksfriends
            thanksfriends.friendbool = friends
            
            self.present(thanksfriends, animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: "firsttime")
    
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        firstButton.setImage(UIImage(named:"TG1"), for: .normal)
        secondsButton.setImage(UIImage(named:"TG2"), for: .normal)
        thirdButton.setImage(UIImage(named:"TG3"), for: .normal)
        forthButton.setImage(UIImage(named:"TG4"), for: .normal)
        fifthButton.setImage(UIImage(named:"TG5"), for: .normal)

        firstButton.imageView?.contentMode = .scaleAspectFill
        secondsButton.imageView?.contentMode = .scaleAspectFill
        thirdButton.imageView?.contentMode = .scaleAspectFill
        forthButton.imageView?.contentMode = .scaleAspectFill
        fifthButton.imageView?.contentMode = .scaleAspectFill
        
        firstButton.layer.cornerRadius = 40.0
        secondsButton.layer.cornerRadius = 40.0
        thirdButton.layer.cornerRadius = 40.0
        forthButton.layer.cornerRadius = 40.0
        fifthButton.layer.cornerRadius = 40.0
        
        


    }
}

//
//  stampViewController.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2021/05/20.
//

import UIKit
import Nuke
import FirebaseFirestore
import Firebase

class stampViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var laLabel: UILabel!
    
    var transitionNewPostBool : Bool?
    var stampUrls : String?
    var imageUrls = [String]()
    let db = Firestore.firestore()
    
    let userName: String? =  UserDefaults.standard.object(forKey: "userName") as? String ?? "Unknown"
    let userImage: String? = UserDefaults.standard.object(forKey: "userImage") as? String ?? "Unknown"
    let userFrontId: String? = UserDefaults.standard.object(forKey: "userFrontId") as? String ?? "Unknown"
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func cancelTappedButton(_ sender: Any) {
        UIView.animate(withDuration: 0.14, delay: 0, animations: {
            self.imageView.alpha = 0
            self.cancelButton.alpha = 0
            self.laLabel.alpha = 0
        })
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBAction func tappedImageView(_ sender: Any) {
        print("aaaa")
        print(stampUrls!)
        
        if transitionNewPostBool == true {
            print("aaaa")
            let vc = self.presentingViewController as! sinkitoukou
            vc.imageString = stampUrls
            vc.assetsType = "stamp"
            self.dismiss(animated: true, completion: nil)
        } else {
            addMessageToFirestore(urlString: stampUrls!)
            dismiss(animated: true, completion: nil)
        }
        
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CollectionViewCell
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        if let url = URL(string:imageUrls[indexPath.row]) {
            Nuke.loadImage(with: url, into: cell.stampImageView!)
        } else {
            cell.stampImageView?.image = nil
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.2, delay: 0.1, animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.imageView.alpha = 1
//
//
        }) { bool in
        // ②アイコンを大きくする
            UIView.animate(withDuration: 0.1, delay: 0, animations: {
                self.imageView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)

        }) { bool in
            // ②アイコンを大きくする
            UIView.animate(withDuration: 0.1, delay: 0, animations: {
                self.imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            })
            }
        }
    
        laLabel.alpha = 1
        cancelButton.alpha = 0.7
        
        stampUrls = imageUrls[indexPath.row]
    
        if let url = URL(string:imageUrls[indexPath.row]) {
            Nuke.loadImage(with: url, into: imageView)
        }
    }
    
    
    
    
    private func addMessageToFirestore(urlString: String) {
        
        let userId = UserDefaults.standard.string(forKey: "chatRoomUserId")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        func randomString(length: Int) -> String {
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map{ _ in characters.randomElement()! })
        }
        let documentId = randomString(length: 20)
                    let docData = [
                        "createdAt": FieldValue.serverTimestamp(),
                        "message": "",
                        "userId": uid,
                        "documentId" : documentId,
                        "admin": false,
                        "sendImageURL": urlString,
                    ] as [String: Any]
        
        let upDateDoc = [
            "chatLatestedAt": FieldValue.serverTimestamp(),
            "messageCount": FieldValue.increment(1.0),
            "newMessage": "\(String(describing: userName))がスタンプしました",
            "latestUserId":uid
        ] as [String: Any]
        
        db.collection("users").document(uid).collection("ChatRoom").document(userId ?? "").collection("Messages").document(documentId).setData(docData)
        db.collection("users").document(userId ?? "").collection("ChatRoom").document(uid).collection("Messages").document(documentId).setData(docData)
        db.collection("users").document(userId ?? "").collection("Connections").document(uid).setData(upDateDoc, merge: true)
        db.collection("users").document(userId ?? "").setData(["messageNum": FieldValue.increment(1.0)], merge: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBOutlet weak var stampCollcetionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stampCollcetionView.delegate = self
        stampCollcetionView.dataSource = self
        
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        
        imageView.layer.borderWidth = 2
        
        imageView.alpha = 0
        cancelButton.alpha = 0
        laLabel.alpha = 0
        
        // セルの詳細なレイアウトを設定する
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // セルのサイズ
        flowLayout.itemSize = CGSize(width: 100.0, height: 100.0)
        // 縦・横のスペース
        flowLayout.minimumLineSpacing = 10.0
        flowLayout.minimumInteritemSpacing = 12.0
        //  スクロールの方向
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        // 上で設定した内容を反映させる
        self.stampCollcetionView.collectionViewLayout = flowLayout
        // 背景色を設定
        self.stampCollcetionView?.backgroundColor = .clear
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.55)
        
        imageUrls =  ["https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA1osusume.png?alt=media&token=0da0367d-af96-4f12-b660-52388bf955d7",//A1
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA2itiosi.png?alt=media&token=2883e323-af38-4678-9e20-a0cc85fa980f",//A2
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA3maru.png?alt=media&token=5e92bbeb-7ca3-461a-964d-f1165259065a",//A3
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA4batu.png?alt=media&token=39d0493e-9362-404d-a628-de514f9a417c",//A4
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA5extu.png?alt=media&token=64e2ff4e-b14d-4f11-9ab3-8e61350388f5",//A5
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA6pinn.png?alt=media&token=d2f2fb68-522b-4c55-b85d-60ee56b25737",//A6
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA7atafuta.png?alt=media&token=3409716e-a480-44de-925d-d44ee0bd1ab9",//A7
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA8u-nn.png?alt=media&token=7e996956-c7e8-41fb-8a3c-a2f095ad78c0",//A8
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA9sikusiku.png?alt=media&token=4d4c811a-dfba-4024-bf32-718670af68ae",//A9
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA10punpun.png?alt=media&token=acbef5d9-fb46-4575-841c-800e5fc89344",//A10
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA11gusya.png?alt=media&token=fc744cee-7365-441c-81d4-8f877076ec13",//A11
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FA12iine.png?alt=media&token=f344a8bc-368c-4ce9-9f3e-9980a0705266",//A12
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB1gimonn.png?alt=media&token=8edd18a4-d8c1-4aa3-a147-90a92e73c84e",//B1
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB2hyokkori.png?alt=media&token=13eb5fa7-d790-451b-a7a2-43c1b1b532f8",//B2
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB3korede.png?alt=media&token=70a31f21-728b-4339-93f1-7984ac7f635a",//B3
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB4ha-to.png?alt=media&token=22cb5c5e-d4f1-4a46-be32-5c708f669473",//B4
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB5bi-ru.png?alt=media&token=54044c91-32de-4365-851e-823c46c84d05",//B5
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB6runnrunn.png?alt=media&token=3f52c1c9-16fd-493f-b5f8-3e2e5cbab034",//B6
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB7dogeza.png?alt=media&token=99799883-d9e9-4758-8a7c-3dc7844115b5",//B7
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB8nemasu.png?alt=media&token=ecdd59e8-7445-4a69-81e1-4a9efc7735e8",//B8
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FB9genkai.png?alt=media&token=047a11fe-abe4-4c9b-95dd-fca81e5c089b",//B9
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF1burebure.png?alt=media&token=6ef860dc-4669-4abd-bfbe-acccfada72d4",//F1
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF2ganbari.png?alt=media&token=2503be25-7469-4495-9a66-7ba4a6f124d8",//F2
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF3kontiku.png?alt=media&token=bb205dc0-bb73-4da2-8d9d-062f0db9c462",//F3
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF4konban.png?alt=media&token=12818af7-e152-4270-8168-8bd57a0a00f8",//F4
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF5itteki.png?alt=media&token=ee4d437e-f6be-4d87-9566-136f5f3de94c",//F5
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF6ittera.png?alt=media&token=2c882b36-a4ee-4f64-a3d0-9a6004011477",//F6
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF7aisiteru.png?alt=media&token=21dc5119-ef29-42e9-a6d7-9aee1dc85d80",//F7
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF8isogasii.png?alt=media&token=fb17e802-52f7-4dc3-a0be-6a0b6c5b7885",//F8
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF9subara.png?alt=media&token=4145b657-81d3-4ab6-ab4d-70cea6083ce3",//F9
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF10otukare.png?alt=media&token=6ef78a52-dc77-48a8-b135-53d006706133",//F10
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF11tadaima.png?alt=media&token=d648a103-1e24-4dd2-b2cd-a58e0df6117e",//F11
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF12onegai.png?alt=media&token=a3bcf762-a1be-4176-adb7-4eb229512606",//F12
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF13gotisou.png?alt=media&token=a1b82ef8-f19a-4f29-a099-ab21275be658",//F13
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF14itadaki.png?alt=media&token=9eaa805b-ec43-470a-b576-ff056721ddc6",//F14
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF15gurasann.png?alt=media&token=3100bd9b-cc95-423a-8c94-6dec2616e90d",//F15
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF16kanpai.png?alt=media&token=56eb4e1f-9c50-43db-b213-54358c72388f",//F16
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF17kurisumasu.png?alt=media&token=5a04314f-4b7d-4119-8f89-b847af4a41b5",//F17
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF18gojou.png?alt=media&token=0ce25eb8-9048-482e-a9fd-4faf593c28a2",//F18
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FF19usito.png?alt=media&token=9796e944-b050-4962-bdb8-32163c30a1b4",//F19
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FG1usi.png?alt=media&token=81abc531-521a-42c9-84ee-e4f956d73915",//G1
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FG2nemasu.png?alt=media&token=a03da529-c8c6-4f8e-94b8-39fefd8de034",//G2
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FG3gurasann.png?alt=media&token=9c1d8def-2def-485b-89eb-c02d83d142ac",//G3
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FG4kuyasi.png?alt=media&token=42c76a16-7b12-4dd6-b1ab-1a538497c464",//G4
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FG5nemasu.png?alt=media&token=bb39929e-5d47-473b-9065-bcb350ce8324",//G5
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FG6batu.png?alt=media&token=06e472e4-689b-4d10-9f57-1aa5af21382a",//G6
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FG7maru.png?alt=media&token=400281a8-9945-431a-9179-f645521c4b16",//G7
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FG8dog.png?alt=media&token=3755a316-e21a-491c-b050-267d5c9a9e8f",//G8
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FC1haaa.png?alt=media&token=035fd92c-7c6f-4806-afb7-406f5882d0c0",//C1
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FC2ikasu.png?alt=media&token=89894702-d098-4d1b-b9d8-5f9598f29007",//C2
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FC3nozoki1.png?alt=media&token=e0884181-56e1-4a06-b583-57f813a81474",//C3
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FC4nozoki2.png?alt=media&token=546f23a0-ff95-4fbd-94d1-8ace7e586602",//C4
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FC5drink.png?alt=media&token=d314d906-1127-428d-8fd7-ac773a421eda",//C5
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FC6champion.png?alt=media&token=e22a9456-bdfb-4499-8ae2-f09b9b89ab39",//C6
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FC7moumuri.png?alt=media&token=df062567-bfa0-464e-9a96-33d869ca2b99",//C7
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FC8oraaa.png?alt=media&token=436ffce0-77be-42e0-8eda-c513db096bc5",//C8
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FC9omedetou.png?alt=media&token=79199b8c-1e80-4df3-928b-5a58a95f0dc2",//C9
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FC10yossya.png?alt=media&token=f349ba89-e524-49b8-b52e-a101c88dab17",//C10
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FC11hey.png?alt=media&token=238f9d85-06f0-41ea-985f-e31f78ad0ce8",//C11
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FC12flag.png?alt=media&token=e55ae578-4826-4bd8-962a-b989f61b736d",//C12
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FC13TV.png?alt=media&token=091ac84b-d34d-4057-8743-b8d6e198d385",//C13
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FC14hizamazuke.png?alt=media&token=0d766649-ae94-4192-9c3f-73e7532294d7",//C14
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FC15daradara.png?alt=media&token=8eaf9d62-4b86-457b-8d2f-212b62b0e5be",//C15
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FC16hey.png?alt=media&token=7b83123b-6aed-460f-9eff-497875115e13",//C16
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FC17syouso.png?alt=media&token=6d6c82a0-36ef-4f60-8e25-13a1d48fb5de",//C17
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FC18caution.png?alt=media&token=051ee161-c7c6-4f19-88d5-dfca3bdc28b3",//C18
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FC19chabudai.png?alt=media&token=7cf5c728-3c32-4814-af3e-d7fce7e6ed2c",//C19
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FD1daradarapng.png?alt=media&token=3712ba5b-e6e3-4425-84ea-c3e1f47aa42b",//D1
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FD2kondru.png?alt=media&token=3566e4ce-6102-4735-a553-d973b70509d9",//D2
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FD3santa.png?alt=media&token=4345929e-67b1-4a52-a832-093d7b58e949",//D3
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FD4ka-ringu.png?alt=media&token=f769ff0d-1f80-423d-bbf0-ad805223c6b6",//D4
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FD5kozinmari.png?alt=media&token=ec11c6f8-1da8-4185-a3b5-0acac5e42332",//D5
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FD6gimonn.png?alt=media&token=6fbb40a7-40c6-4cb7-a861-90759f60343a",//D6
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FD7kuzira.png?alt=media&token=45419f6f-48a7-4277-8aa6-7695f199c46e",//D7
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FD8genkai.png?alt=media&token=385676b2-a3dc-478e-a0bf-4c44ebdd4086",//D8
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FD9gu-tara.png?alt=media&token=2a6db9de-e5ac-4cf6-afb3-fb445756b549",//D9
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FD10kyunn.png?alt=media&token=6fdac33d-43d5-4604-a582-202386000fcf",//D10
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FE1pienn.png?alt=media&token=a0d99521-b559-4c5e-bf6a-9c1722e19add",//E1
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FE2goriras.png?alt=media&token=3cb8ce79-81cc-4992-a2c0-b22135930677",//E2
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FE3goriraandcat.png?alt=media&token=ed7ca0c2-31fb-4dad-ae67-aa74808bb147",//E3
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FE4genkai.png?alt=media&token=e5bdc866-a124-4946-9e04-d86685047949",//E4
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FE5angry.png?alt=media&token=8214f832-99a7-4780-9da0-261df138cabc",//E5
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FE6haaa.png?alt=media&token=3f5225a8-cee8-4f49-90af-7c5c4f85a0b7",//E6
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FE7you.png?alt=media&token=1d66dc4a-6ee3-4cd5-8627-4a612ff20e50",//E7
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FE8PC.png?alt=media&token=6a3b7702-59dc-4ebc-991b-b1254542ee3f",//E8
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FE9cooool.png?alt=media&token=cbd27498-f58d-4d9f-a954-edf4321925dc",//E9
                     "https://firebasestorage.googleapis.com/v0/b/totalgood-7b3a3.appspot.com/o/Stamp_Image%2FE10guuuu.png?alt=media&token=163fe3ad-3b3d-4b26-a6b2-52fe054bd83c",//E10
        ]
  
    }
}
 
class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var stampImageView: UIImageView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // cellの枠の太さ
        self.layer.borderWidth = 1.5
    
        self.layer.borderColor = #colorLiteral(red: 0, green: 1, blue: 0.8712542808, alpha: 1)

        // cellを丸くする
        self.layer.cornerRadius = 8.0
    }
}

extension stampViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}

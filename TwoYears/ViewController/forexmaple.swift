////
////  forexmaple.swift
////  TwoYears
////
////  Created by 平田翔大 on 2021/03/04.
////
//
//import UIKit
//import Firebase
//
//class TodoListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var userNameLabel: UILabel!
//
//    var todoIdArray: [String] = []
//    var todoTitleArray: [String] = []
//    var todoDetailArray: [String] = []
//    var todoIsDoneArray: [Bool] = []
//    var isDone: Bool = false
//
//    // スワイプ時のアクションを設定するメソッド
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        // 未完了・完了済みの切り替えのスワイプ
//        let editAction = UIContextualAction(style: .normal,
//                                            title: "Edit",
//                                            handler: {(action: UIContextualAction, view: UIView, completion: (Bool) -> Void) in
//            if let user = Auth.auth().currentUser {
//                Firestore.firestore().collection("users/\(user.uid)/todos").document(self.todoIdArray[indexPath.row]).updateData(
//                    [
//                        "isDone": !self.todoIsDoneArray[indexPath.row],
//            "updatedAt": FieldValue.serverTimestamp()
//                    ]
//                    ,completion: { error in
//                        if let error = error {
//                            print("TODO更新失敗: " + error.localizedDescription)
//                            let dialog = UIAlertController(title: "TODO更新失敗", message: error.localizedDescription, preferredStyle: .alert)
//                            dialog.addAction(UIAlertAction(title: "OK", style: .default))
//                            self.present(dialog, animated: true, completion: nil)
//                        } else {
//                            print("TODO更新成功")
//                            self.getTodoDataForFirestore()
//                        }
//                })
//            }
//        })
//        editAction.backgroundColor = UIColor(red: 101/255.0, green: 198/255.0, blue: 187/255.0, alpha: 1)
//        // controlの値によって表示するアイコンを切り替え
//        switch isDone {
//        case true:
//            editAction.image = UIImage(systemName: "arrowshape.turn.up.left")
//        default:
//            editAction.image = UIImage(systemName: "checkmark")
//        }
//
//        // 削除のスワイプ
//        let deleteAction = UIContextualAction(style: .normal,
//                                              title: "Delete",
//                                              handler: { (action: UIContextualAction, view: UIView, completion: (Bool) -> Void) in
//            if let user = Auth.auth().currentUser {
//                Firestore.firestore().collection("users/\(user.uid)/todos").document(self.todoIdArray[indexPath.row]).delete(){ error in
//                    if let error = error {
//                        print("TODO削除失敗: " + error.localizedDescription)
//                        let dialog = UIAlertController(title: "TODO削除失敗", message: error.localizedDescription, preferredStyle: .alert)
//                        dialog.addAction(UIAlertAction(title: "OK", style: .default))
//                        self.present(dialog, animated: true, completion: nil)
//                    } else {
//                        print("TODO削除成功")
//                        self.getTodoDataForFirestore()
//                    }
//                }
//            }
//        })
//        deleteAction.backgroundColor = UIColor(red: 214/255.0, green: 69/255.0, blue: 65/255.0, alpha: 1)
//        deleteAction.image = UIImage(systemName: "clear")
//
//        // スワイプアクションを追加
//        let swipeActionConfig = UISwipeActionsConfiguration(actions: [editAction, deleteAction])
//        // fullスワイプ時に挙動が起きないように制御
//        swipeActionConfig.performsFirstActionWithFullSwipe = false
//
//        return swipeActionConfig
//    }
//}

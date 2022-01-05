//
//  ReadLogVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/05.
//

import UIKit

class ReadLogVC: UIViewController{
    @IBOutlet weak var readLogTableView: UITableView!
    private let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        readLogTableView.delegate = self
        readLogTableView.dataSource = self
    }
}
extension ReadLogVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = readLogTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ReadLogTableViewCell
        return cell
    }
    
    
}

class ReadLogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var reactionView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

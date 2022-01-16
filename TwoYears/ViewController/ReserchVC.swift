//
//  ReserchVC.swift
//  TOTALGOOD
//
//  Created by 平田翔大 on 2022/01/16.
//

import UIKit

class ReserchVC:UIViewController{
    private let cellId = "cellId"

    @IBOutlet weak var reserchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reserchTableView.dataSource = self
        reserchTableView.delegate = self
    }
}

extension ReserchVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reserchTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ReserhTableViewCell
        return cell

    }
}

class ReserhTableViewCell:UITableViewCell{
    
}

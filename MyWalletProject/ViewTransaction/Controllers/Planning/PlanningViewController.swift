//
//  PlanningViewController.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/1/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class PlanningViewController: UIViewController {

    
    @IBOutlet var planningTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()

        // Do any additional setup after loading the view.
    }
    
    func initComponents(){
        PlanningCell.registerCellByNib(planningTableView)
        planningTableView.dataSource = self
    }
}
extension PlanningViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return PlanningCell.loadCell(tableView) as! PlanningCell
    }
}

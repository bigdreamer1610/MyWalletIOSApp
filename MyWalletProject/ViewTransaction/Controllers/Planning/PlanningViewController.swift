//
//  PlanningViewController.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/1/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

struct PlanningItem{
    var icon: String
    var title: String
    var footer: String
}

class PlanningViewController: UIViewController {

    var list = [
    PlanningItem(icon: "money-bag", title: "Budgets", footer: "Set budget for individual category, or for all categories in a wallet"),
    PlanningItem(icon: "events", title: "Events", footer: "Create an event to track on your spending during an actual event, like travelling at weekend")
    ]
    
    @IBOutlet var planningTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        initComponents()
        planningTableView.isScrollEnabled = false
    }
    
    func initComponents(){
        planningTableView.dataSource = self
        planningTableView.delegate = self
        ItemPlanningCell.registerCellByNib(planningTableView)
        FooterCell.registerCellByNib(planningTableView)
        
    }
}
extension PlanningViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //return PlanningCell.loadCell(tableView) as! PlanningCell
        let cell = ItemPlanningCell.loadCell(tableView) as! ItemPlanningCell
        cell.setUpData(item: list[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            AppRouter.routerTo(from: self, router: .budget, options: .push)
        } else {
            AppRouter.routerTo(from: self, router: .event, options: .push)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = FooterCell.loadCell(tableView) as! FooterCell
        cell.setUp(des: list[section].footer)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
}

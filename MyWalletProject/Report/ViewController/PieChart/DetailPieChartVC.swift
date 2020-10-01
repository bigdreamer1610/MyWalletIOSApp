//
//  DetailPieChartVC.swift
//  MyWalletProject
//
//  Created by Nguyen Thi Huong on 9/28/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class DetailPieChartVC: UIViewController {
    var sumIncome = 0
    var sumExpense = 0
    var state = 0
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
       
        print("Pie \(sumIncome)")
      
        print("Pie \(sumExpense)")
        
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        IncomDetailTableViewCell.registerCellByNib(tableView)
        DetailPieTableViewCell.registerCellByNib(tableView)
        NameTableViewCell.registerCellByNib(tableView)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    @IBAction func popToView(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailPieChartVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = NameTableViewCell.loadCell(tableView)  as! NameTableViewCell
            return cell
        } else if indexPath.section == 1 {
            let cell = DetailPieTableViewCell.loadCell(tableView) as! DetailPieTableViewCell
            return cell
        } else {
            let cell = IncomDetailTableViewCell.loadCell(tableView) as! IncomDetailTableViewCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 && indexPath.section != 1 {
            print("Helđjhaiựh")
            let vc = UIStoryboard.init(name: "Report", bundle: nil).instantiateViewController(withIdentifier: "dayDetailPC") as! DayDetailPC
            //            vc.setUpDataTransactionView(item: transactionSections[indexPath.section - 1].items[indexPath.row], header: transactionSections[indexPath.section - 1].header)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
}

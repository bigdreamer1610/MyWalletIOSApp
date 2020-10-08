//
//  DetailPieChartVC.swift
//  MyWalletProject
//
//  Created by Nguyen Thi Huong on 9/28/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class DetailPieChartVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var formatter = NumberFormatter()
    var sum = 0
    var state: State?
    var segmentIndex = 0
    var sumByCategory = [SumByCate]()
    var categories = [Category]()
    var transations = [Transaction]()
    var nameIconCategory = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        DetailPCCell.registerCellByNib(tableView)
        DetailPieTableViewCell.registerCellByNib(tableView)
        NameTableViewCell.registerCellByNib(tableView)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.showsVerticalScrollIndicator = false
    }
    
    func getData(info: SumArr) {
        sum = info.sum
        sumByCategory = info.sumByCategory
        transations = info.transations
    }
    
    @IBAction func popToView(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmentInAndDe(_ uiSegmentedControl: UISegmentedControl) {
        segmentIndex = uiSegmentedControl.selectedSegmentIndex
        switch segmentIndex {
        case 0:
            sumByCategory.sort(by: { $0.amount > $1.amount })
        default:
            sumByCategory.sort(by: { $0.amount < $1.amount })
        }
        tableView.reloadData()
    }
}

extension DetailPieChartVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return sumByCategory.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = NameTableViewCell.loadCell(tableView)  as! NameTableViewCell
            cell.selectionStyle = .none
            if state == .income {
                cell.setupIncome(sum)
            } else {
                cell.setupExpense(sum)
            }
            return cell
        case 1:
            let cell = DetailPieTableViewCell.loadCell(tableView) as! DetailPieTableViewCell
            cell.selectionStyle = .none
            cell.setChart(sumByCategory)
            return cell
        default:
            let cell = DetailPCCell.loadCell(tableView) as! DetailPCCell
            cell.selectionStyle = .none
            if state == .income {
                cell.lblMoney.textColor = .blue
            } else {
                cell.lblMoney.textColor = .red
            }
            cell.lblTypeOfMoney.text = sumByCategory[indexPath.row].category
            cell.lblMoney.text = String(formatter.string(from: NSNumber(value: sumByCategory[indexPath.row].amount))!)
            let filtered = categories.filter { category in
                return category.id! == sumByCategory[indexPath.row].category
            }
            cell.categoryImage.image = UIImage(named: filtered[0].iconImage ?? "bill")
            self.nameIconCategory = filtered[0].iconImage ?? "bill"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        if indexPath.section == 2 {
        //            let vc = UIStoryboard.init(name: "Report", bundle: nil).instantiateViewController(withIdentifier: "dayDetailPC") as! DayDetailPC
        //            vc.transactions = transations
        //            vc.categoryImage = nameIconCategory
        //            vc.sumByCategory = sumByCategory[indexPath.row].amount
        //            vc.state = state
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }
    }
    
}

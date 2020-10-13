//
//  DayDetailPC.swift
//  MyWalletProject
//
//  Created by Nguyen Thi Huong on 9/30/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class DayDetailPC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let transactionHeader: CGFloat = 60
    let transactionRow: CGFloat = 65
    let detailCell: CGFloat = 70
    var transactionSections = [TransactionSection]()
    var categoryName = "Thưởng"
    var date = "24/09/2020"
    var transactions = [Transaction]()
    
    var dataSorts = [[Transaction]]()
    var categoryImage = ""
    var sumByCategory = 0
    var state: State?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableViews()
        self.title = "\(categoryName), \(date)"
        
    }
    
    @IBAction func popToView(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func initTableViews(){
        tableView.delegate = self
        tableView.dataSource = self
        DayDetailCell.registerCellByNib(tableView)
        HeaderTransactionCell.registerCellByNib(tableView)
        TransactionCell.registerCellByNib(tableView)
    }
}

extension DayDetailPC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        } else {
            return transactions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = DayDetailCell.loadCell(tableView) as! DayDetailCell
            cell.selectionStyle = .none
            cell.lblMoney.text = String(sumByCategory)
            if state == .income {
                cell.lblTypeOfMoney.text = "Income"
            } else {
                cell.lblTypeOfMoney.text = "Expense"
            }
            return cell
        } else {
            let cell = TransactionCell.loadCell(tableView) as! TransactionCell
            cell.lbCategory.text = transactions[indexPath.row].categoryid
            cell.lbAmount.text = String(transactions[indexPath.row].amount ?? 0)
            cell.lbNote.text = transactions[indexPath.row].note
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let vc = UIStoryboard.init(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "detail") as! DetailTransactionController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension DayDetailPC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = HeaderTransactionCell.loadCell(tableView) as! HeaderTransactionCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var myHeight: CGFloat = 0
        if section != 0 {
            myHeight = transactionHeader
        } else {
            myHeight = 0
        }
        return myHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var myHeight: CGFloat = 0
        
        if indexPath.section == 0 {
            myHeight = detailCell
        } else {
            myHeight = transactionRow
        }
        return myHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == tableView  {
            return 30
        }
        return 0
    }
}

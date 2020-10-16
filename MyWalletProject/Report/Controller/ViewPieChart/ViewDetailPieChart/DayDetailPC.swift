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
    var transactionSections = [TransactionSection]()
    var categoryName = ""
    var date = ""
    var transactions = [Transaction]()
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
        HeaderCategoryCell.registerCellByNib(tableView)
        TransactionDayCell.registerCellByNib(tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    func setupData(info: DetailPC) {
        self.state = info.state
        self.transactions = info.transactions
        self.categoryImage = info.categoryImage
        self.sumByCategory = info.sumByCategory
        self.categoryName = info.category
        self.date = info.date
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
            if state == .income {
                cell.setupLabel(color: .blue, text: Constants.income, sum: sumByCategory)
            } else {
                cell.setupLabel(color: .red, text: Constants.expense, sum: sumByCategory)
            }
            return cell
        } else {
            let cell = TransactionDayCell.loadCell(tableView) as! TransactionDayCell
            cell.selectionStyle = .none
            if state == .income {
                cell.lbAmount.textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            } else {
                cell.lbAmount.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            }
            let sum = transactions[indexPath.row].amount ?? 0
            let currentDay = transactions[indexPath.row].date
            let dateNumber = currentDay?.split(separator: "/")[0] ?? ""
            let myNote = transactions[indexPath.row].note ?? ""
            cell.setupData(data: DetailDayPCByCate(day: String(dateNumber), date: self.date, amount: sum, note: myNote))
            return cell
        }
    }
    
}

extension DayDetailPC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = HeaderCategoryCell.loadCell(tableView) as! HeaderCategoryCell
        cell.setupData(data: CategoryHeader(categoryName: categoryName, noOfTransactions: transactions.count, amount: sumByCategory, icon: categoryImage))
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
        myView.backgroundColor = UIColor.groupTableViewBackground
        return myView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var myHeight: CGFloat = 0
        if section != 0 {
            myHeight = Constants.categoryHeader
        } else {
            myHeight = 0
        }
        return myHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var myHeight: CGFloat = 0
        if indexPath.section == 0 {
            myHeight = Constants.detailPCCell
        } else {
            myHeight = Constants.categoryRow
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

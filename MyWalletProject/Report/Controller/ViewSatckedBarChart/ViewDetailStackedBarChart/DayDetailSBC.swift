//
//  DayDetailSBC.swift
//  MyWalletProject
//
//  Created by Nguyen Thi Huong on 9/29/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class DayDetailSBC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let transactionHeader: CGFloat = 60
    let transactionRow: CGFloat = 65
    let detailCell: CGFloat = 135
    var date = ""
    var incomeArray = [Transaction]()
    var expenseArray = [Transaction]()
    var trans = [[Transaction]](repeating: [Transaction](), count: 32)
    var sumIncome = 0
    var sumExpense = 0
    var sumIncomeByDate = 0
    var sumExpenseByDate = 0
    var imageName = ""
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableViews()
        self.title = date
        
        rearrangeData()
    }
    
    @IBAction func popToView(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func setupData(info: DetailDaySBC) {
        sumIncome = info.sumIncome
        sumExpense = info.sumExpense
        incomeArray = info.incomeArray
        expenseArray = info.expenseArray
        date = info.date
    }
    
    func initTableViews(){
        tableView.delegate = self
        tableView.dataSource = self
        DayDetail.registerCellByNib(tableView)
        HeaderTransactionCell.registerCellByNib(tableView)
        TransactionCell.registerCellByNib(tableView)
    }
    
    func rearrangeData() {
        for expense in expenseArray {
            let currentDay = expense.date
            let dateNumber = Int(currentDay?.split(separator: "/")[0] ?? "")
            
            trans[dateNumber ?? -1].append(expense)
            sumExpenseByDate += expense.amount ?? 0
            
        }
        
        for income in incomeArray {
            let currentDay = income.date
            let dateNumber = Int(currentDay?.split(separator: "/")[0] ?? "")
            
            trans[dateNumber ?? -1].append(income)
            sumIncomeByDate += income.amount ?? 0
        }
        
        for tran in trans {
            if !tran.isEmpty {
                count += 1
            }
        }
        print(count)
    }
}

extension DayDetailSBC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        } else {
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = DayDetail.loadCell(tableView) as! DayDetail
            cell.setUpData(expense: sumIncome, income: sumExpense)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = TransactionCell.loadCell(tableView) as! TransactionCell
            return cell
        }
    }
}

extension DayDetailSBC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = HeaderTransactionCell.loadCell(tableView) as! HeaderTransactionCell
//            let currentDay = incomeArray[indexPath].date
//            let dateNumber = currentDay?.split(separator: "/")[0] ?? ""
        
        
        
//        if index in 0
//        cell.setupData(data: DetailDaySBCCell(date: <#String#>, day: <#String#>, amount: , longDate: date))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var myHeight: CGFloat = 0
        if section != 0 {
            myHeight = Constants.transactionHeader
        } else {
            myHeight = 0
        }
        return myHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var myHeight: CGFloat = 0
        
        if indexPath.section == 0 {
            myHeight = Constants.detailCell
        } else {
            myHeight = Constants.transactionRow
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

//
//  DayDetailSBC.swift
//  MyWalletProject
//
//  Created by Nguyen Thi Huong on 9/29/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

struct DataForHeader {
    var date: Int
    var sum: Int
    var transactions: [Transaction]
}

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
    var dataArray = [DataForHeader]()
    var categories = [Category]()
    var dateForHeader = 0
    var currentHeaderIndex = 0
    var index = 0
    var state: State?
    
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
        self.sumIncome = info.sumIncome
        self.sumExpense = info.sumExpense
        self.incomeArray = info.incomeArray
        self.expenseArray = info.expenseArray
        self.date = info.date
        self.categories = info.categories
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
        }
        
        for income in incomeArray {
            let currentDay = income.date
            let dateNumber = Int(currentDay?.split(separator: "/")[0] ?? "")
            trans[dateNumber ?? -1].append(income)
        }
        
        for index in 0 ..< trans.count {
            var extractData: DataForHeader = DataForHeader(date: 0, sum: 0, transactions: [Transaction]())
            
            if !trans[index].isEmpty {
                count += 1
                extractData.date = index
                for tran in trans[index] {
                    extractData.transactions.append(tran)
                    if tran.transactionType == "income" {
                        extractData.sum += tran.amount ?? 0
                    } else {
                        extractData.sum -= tran.amount ?? 0
                    }
                }
                dataArray.append(extractData)
            }
        }
    }
}

extension DayDetailSBC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        } else {
            return dataArray[section - 1].transactions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = DayDetail.loadCell(tableView) as! DayDetail
            cell.setUpData(expense: sumExpense, income: sumIncome)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = TransactionCell.loadCell(tableView) as! TransactionCell
            
            var data = Transaction()
            
            data = dataArray[indexPath.section - 1].transactions[indexPath.row]
            
            let filtered = categories.filter { category in
                return category.id ?? "" == data.categoryid
            }
            imageName = filtered[0].iconImage ?? "salary"
            
            cell.setupData(data: DetailSBCByDate(category: data.categoryid ?? "", amount: data.amount ?? 0, note: data.note ?? "", imageName: imageName), state: data.transactionType ?? "")
            
            return cell
        }
    }
}

extension DayDetailSBC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = HeaderTransactionCell.loadCell(tableView) as! HeaderTransactionCell
        
            cell.setupData(data: DetailDaySBCCell(date: String(dataArray[section - 1].date), day: "", amount: dataArray[section - 1].sum, longDate: date))
        
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

//
//  DetailStackedBarChartVC.swift
//  MyWalletProject
//
//  Created by Nguyen Thi Huong on 9/28/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class DetailStackedBarChartVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var sumExpense = 0
    var sumIncome = 0
    var netIncome = 0
    var date = ""
    var incomeArray = [Transaction]()
    var expenseArray = [Transaction]()
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.title = Constants.netIncome
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        DetailSBCTableViewCell.registerCellByNib(tableView)
        DetailSBCCell.registerCellByNib(tableView)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
    }
    
    func setupData(info: SumInfo) {
        self.sumIncome = info.sumIncome
        self.sumExpense = info.sumExpense
        self.date = info.date
        self.incomeArray = info.incomeArray
        self.expenseArray = info.expenseArray
        self.netIncome = info.netIncome
        self.categories = info.categories
    }
    
    @IBAction func popReportVC(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailStackedBarChartVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = DetailSBCTableViewCell.loadCell(tableView)  as! DetailSBCTableViewCell
            cell.setChartData(sumIncome, sumExpense)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = DetailSBCCell.loadCell(tableView) as! DetailSBCCell
            cell.setupData(info: SumInfo(sumIncome: sumIncome, sumExpense: sumExpense, netIncome: sumIncome - sumExpense, date: date, incomeArray: incomeArray, expenseArray: expenseArray, categories: categories))
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let vc = UIStoryboard.init(name: "Report", bundle: Bundle.main).instantiateViewController(identifier: "dayDetailSBC") as! DayDetailSBC
            vc.setupData(info: DetailDaySBC(sumIncome: sumIncome, sumExpense: sumExpense, incomeArray: incomeArray, expenseArray: expenseArray, date: date, categories: categories))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//
//  BudgetTransactionViewController.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class BudgetTransactionViewController: UIViewController {

    var presenter: BudgetTransactionPresenter?
    @IBOutlet var detailTableView: UITableView!
    
    var transactionSections = [TransactionSection]()
    var amount: Int = 0
    var budget: Budget!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        initData()
        // Do any additional setup after loading the view.
    }
    
    func setUp(presenter: BudgetTransactionPresenter){
        self.presenter = presenter
    }
    
    func initComponents(){
        OverviewCell.registerCellByNib(detailTableView)
        TransactionCell.registerCellByNib(detailTableView)
        HeaderTransactionCell.registerCellByNib(detailTableView)
        detailTableView.dataSource = self
        detailTableView.delegate = self
    }
    
    func setUpBudget(budget: Budget){
        self.budget = budget
    }
    
    func initData(){
        presenter?.setUpBudget(budgetObject: budget)
        presenter?.fetchDataTransactions(cid: budget.categoryId!)
    }
    func fetchData(trans: [Transaction]){
        presenter?.fetchData(trans: trans)
    }

}


extension BudgetTransactionViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number = 1
        if section != 0 {
            number = transactionSections[section-1].items.count
        }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var myCell = UITableViewCell()
        if indexPath.section == 0 {
            let cell = OverviewCell.loadCell(tableView) as! OverviewCell
            cell.setUpData(transactionType: budget.transactionType!, amount: amount)
            myCell = cell
        } else {
            let cell = TransactionCell.loadCell(tableView) as! TransactionCell
            cell.setUpData(data: transactionSections[indexPath.section-1].items[indexPath.row])
            myCell = cell
        }
        myCell.selectionStyle = .none
        return myCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionSections.count + 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var myView = UIView()
        if section != 0 {
            let cell = HeaderTransactionCell.loadCell(tableView) as! HeaderTransactionCell
            cell.setUpData(data: transactionSections[section-1].header)
            myView = cell
        }
        return myView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return Constants.transactionHeader
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return Constants.overviewCell
        } else {
            return Constants.transactionRow
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
}

extension BudgetTransactionViewController : BudgetTransactionPresenterDelegate {
    func reloadData() {
        self.detailTableView.reloadData()
    }
    
    func getTransactionSection(section: [TransactionSection]) {
        self.transactionSections = section
        self.detailTableView.reloadData()
    }
    
    func getTotal(total: Int) {
        self.amount = total
        self.detailTableView.reloadData()
    }
    
    func getAllTransactions(trans: [Transaction]) {
        fetchData(trans: trans)
    }
    
    
}

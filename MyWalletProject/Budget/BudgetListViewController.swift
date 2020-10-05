//
//  BudgetListViewController.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 9/30/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Firebase

class BudgetListViewController: UIViewController , UITableViewDataSource , UITableViewDelegate{
    
    @IBOutlet weak var tblBudget: UITableView!
    @IBOutlet weak var lblTotalMoney: UILabel!
    var refreshControl = UIRefreshControl()
    
    var budget: Budget?
    var listBudget:[Budget] = []
    var listBudgetCurrent:[Budget] = []
    var listBudgetFinish:[Budget] = []
    var listTransaction:[Transaction] = []
    
    var ref = Database.database().reference()
    var totalMoneyCurrent = 0
    var totalMoneyFinish = 0
    
    var segmentIndex = 0
    
    var time = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataBudget()
        
        tblBudget.dataSource = self
        tblBudget.delegate = self
        
        let nibName = UINib(nibName: "BudgetCell", bundle: nil)
        tblBudget.register(nibName, forCellReuseIdentifier: "BudgetCell")
        
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblBudget.addSubview(refreshControl)
        
        tblBudget.reloadData()
        tblBudget.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblBudget.frame.width, height: 0))
    }
    
    @objc func refresh(_ sender: AnyObject){
        getDataBudget()
        refreshControl.endRefreshing()
    }
    
    //MARK: get data Firebase Budget and Transaction
    func getDataBudget() {
        
        listBudgetCurrent.removeAll()
        listBudgetFinish.removeAll()
        listTransaction.removeAll()
        
        let dispatchGroup = DispatchGroup() // tạo luồng load cùng 1 nhóm
        
        // load api Budget
        dispatchGroup.enter()
        ref.child("Account").child("userid1").child("budget").observeSingleEvent(of: .value) { (data) in
            for case let child as DataSnapshot in data.children{
                guard let dict = child.value as? [String:Any] else{
                    print("Error")
                    return
                }
                let id = dict["id"] as? Int
                let cateId = dict["categoryId"] as? String
                let cateImage = dict["categoryImage"] as? String
                let cateName = dict["categoryName"] as? String
                let transType = dict["transactionType"] as? String
                let amount = dict["amount"] as? Int
                let startDate = dict["startDate"] as? String
                let endDate = dict["endDate"] as? String
                
                let budget = Budget(id: id, categoryId: cateId, categoryName: cateName, categoryImage: cateImage, transactionType: transType, amount: amount, startDate: startDate, endDate: endDate)
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                
                let end = formatter.date(from: endDate ?? "")
                
                if let end = end , end < self.time {
                    self.listBudgetFinish.append(budget)
                } else {
                    self.listBudgetCurrent.append(budget)
                }
            }
            dispatchGroup.leave()
        }
        
        // Load api Transaction expense
        dispatchGroup.enter()
          ref.child("Account").child("userid1").child("transaction").child("expense").observeSingleEvent(of: .value) { (data) in
              for case let child as DataSnapshot in data.children{
                  guard let dict = child.value as? [String:Any] else {
                      print("Error")
                      return
                  }
                  
                  let cateName = dict["categoryid"] as? String
                  let amount = dict["amount"] as? Int
                  let date = dict["date"] as? String
                  
                  let transaction = Transaction(amount: amount, categoryid: cateName , date: date)
                  
                  self.listTransaction.append(transaction)
              }
              dispatchGroup.leave()
          }
          
        // load api transaction income
          dispatchGroup.enter()
          ref.child("Account").child("userid1").child("transaction").child("income").observeSingleEvent(of: .value) { (data) in
              for case let child as DataSnapshot in data.children{
                  guard let dict = child.value as? [String:Any] else {
                      print("Error")
                      return
                  }
                  
                  let cateName = dict["categoryid"] as? String
                  let amount = dict["amount"] as? Int
                  let date = dict["date"] as? String
                  
                  let transaction = Transaction(amount: amount, categoryid: cateName , date: date)
                  
                  self.listTransaction.append(transaction)
              }
              dispatchGroup.leave()
          }
        
        // Sau khi load hết api mới reload lại table
          dispatchGroup.notify(queue: .main, execute: {
              self.tblBudget.reloadData()
          })
    }
    
    //MARK: lấy tổng số tiền đã tiêu theo tên Category
    func getAmountListTransaction(cateName:String , startDate:String , endDate:String) -> Int {
        var amount = 0
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let start = formatter.date(from: startDate)
        let end = formatter.date(from: endDate)
        
        for transaction in listTransaction {
            if (cateName == transaction.categoryid) {
                var date = formatter.date(from: transaction.date!)
                if let start = start , let end = end , let date = date{
                    if date >= start && date < end {
                        amount += transaction.amount ?? 0
                    }
                }
            }
        }
        
        return amount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.totalMoneyCurrent = 0
        self.totalMoneyFinish = 0
        if segmentIndex == 0{
            totalMoneyFinish = 0
            for budget in self.listBudgetCurrent {
                self.totalMoneyCurrent += budget.amount ?? 0
                self.lblTotalMoney.text = "Total: \(self.totalMoneyCurrent)"
            }
        
            return listBudgetCurrent.count
        }
        else{
            totalMoneyCurrent = 0
            for budget in self.listBudgetFinish {
                self.totalMoneyFinish += budget.amount ?? 0
                self.lblTotalMoney.text = "Total: \(self.totalMoneyFinish)"
            }
            return listBudgetFinish.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetCell", for: indexPath) as! BudgetCell
        
        DispatchQueue.main.async {
            cell.prgFormCate.layer.cornerRadius = cell.prgFormCate.bounds.height / 2
            cell.prgFormCate.layer.masksToBounds = true
        }
        
        if segmentIndex == 0 {
            let categoryImage = listBudgetCurrent[indexPath.row].categoryImage ?? ""
            let categoryName = listBudgetCurrent[indexPath.row].categoryName ?? ""
            let amount = listBudgetCurrent[indexPath.row].amount ?? 0
            let startDate = listBudgetCurrent[indexPath.row].startDate ?? ""
            let endDate = listBudgetCurrent[indexPath.row].endDate ?? ""
            let spentTransaction = getAmountListTransaction(cateName: categoryName , startDate: startDate , endDate: endDate)
            
            cell.setLayout(categoryImage: categoryImage, categoryName: categoryName, amount: amount, startDate: startDate, endDate: endDate , spent: spentTransaction)
        }
        
        else{
            let categoryImage = listBudgetFinish[indexPath.row].categoryImage ?? ""
            let categoryName = listBudgetFinish[indexPath.row].categoryName ?? ""
            let amount = listBudgetFinish[indexPath.row].amount ?? 0
            let startDate = listBudgetFinish[indexPath.row].startDate ?? ""
            let endDate = listBudgetFinish[indexPath.row].endDate ?? ""
//            let spentTransaction = getAmountListTransaction(cateName: categoryName ?? "")
            let spentTransaction = getAmountListTransaction(cateName: categoryName , startDate: startDate , endDate: endDate)
            
            cell.setLayout(categoryImage: categoryImage, categoryName: categoryName, amount: amount, startDate: startDate, endDate: endDate , spent: spentTransaction)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = UIStoryboard.init(name: "budget", bundle: nil).instantiateViewController(withIdentifier: "BudgetDetailController") as! BudgetDetailController
        
        var id = 0
        var categoryId = ""
        var categoryName = ""
        var categoryImage = ""
        var transactionType = ""
        var amount = 0
        var startDate = ""
        var endDate = ""
        var spentTransaction = 0
        
        if segmentIndex == 0{
            id = listBudgetCurrent[indexPath.row].id ?? 0
            categoryId = listBudgetCurrent[indexPath.row].categoryId ?? ""
            categoryName = listBudgetCurrent[indexPath.row].categoryName ?? ""
            categoryImage = listBudgetCurrent[indexPath.row].categoryImage ?? ""
            transactionType = listBudgetCurrent[indexPath.row].transactionType ?? ""
            amount = listBudgetCurrent[indexPath.row].amount ?? 0
            startDate = listBudgetCurrent[indexPath.row].startDate ?? ""
            endDate = listBudgetCurrent[indexPath.row].endDate ?? ""
            spentTransaction = getAmountListTransaction(cateName: categoryName, startDate: startDate, endDate: endDate)
        }
        else{
            id = listBudgetFinish[indexPath.row].id ?? 0
            categoryId = listBudgetFinish[indexPath.row].categoryId ?? ""
            categoryName = listBudgetFinish[indexPath.row].categoryName ?? ""
            categoryImage = listBudgetFinish[indexPath.row].categoryImage ?? ""
            transactionType = listBudgetFinish[indexPath.row].transactionType ?? ""
            amount = listBudgetFinish[indexPath.row].amount ?? 0
            startDate = listBudgetFinish[indexPath.row].startDate ?? ""
            endDate = listBudgetFinish[indexPath.row].endDate ?? ""
            spentTransaction = getAmountListTransaction(cateName: categoryName, startDate: startDate, endDate: endDate)
        }
        
        let budgetObject = Budget(id: id,categoryId: categoryId, categoryName: categoryName, categoryImage: categoryImage, transactionType: transactionType, amount: amount, startDate: startDate, endDate: endDate)
        
        vc.budgetObject = budgetObject
        vc.spent = spentTransaction
        vc.delegateBudgetDetail = self
        
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnBackClick(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        AppRouter.routerTo(from: RouterType.tabbar.getVc(), options: .transitionCrossDissolve, duration: 0.2, isNaviHidden: true)
    }
    //MARK: Click Add
    @IBAction func btnAddClick(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "budget", bundle: nil).instantiateViewController(withIdentifier: "TestController") as! BudgetController

        vc.type = "Add Budget"
        vc.delegateBudgetController = self
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func segmentTime(_ uiSegmentedControl: UISegmentedControl) {
        segmentIndex = uiSegmentedControl.selectedSegmentIndex
        tblBudget.reloadData()
    }
}

extension BudgetListViewController : BudgetControllerDelegate {
    func reloadDataDetailBudgetintoBudgetController(budget: Budget, spend:Int) {
        getDataBudget()
        tblBudget.reloadData()
    }
    
    func reloadDataListBudgetintoBudgetController() {
        getDataBudget()
        tblBudget.reloadData()
    }
}

extension BudgetListViewController : BudgetDetailControllerDelegate {
    func reloadDataListBudgetintoBudgetDetailController() {
        getDataBudget()
        tblBudget.reloadData()
    }
}


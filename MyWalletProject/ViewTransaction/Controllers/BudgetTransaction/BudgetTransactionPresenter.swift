//
//  BudgetTransactionPresenter.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

protocol BudgetTransactionPresenterDelegate: class {
    func reloadData()
    func getTransactionSection(section: [TransactionSection])
    func getTotal(total: Int)
    func startLoading()
    func endLoading()
}

class BudgetTransactionPresenter {
    weak var delegate: BudgetTransactionPresenterDelegate?
    fileprivate var usecase: BudgetTransactionUseCase?
    
    var transactionSections = [TransactionSection]()
    var allTransactions = [Transaction]()
    var finalTransactions = [Transaction]()
    var dates = [TransactionDate]()
    var budget: Budget!
    
//    var weekdays = ["Sunday","Monday","Tuesday","Wednesday","Thurday","Friday","Saturday"]
//    var months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    init(delegate: BudgetTransactionPresenterDelegate, usecase: BudgetTransactionUseCase) {
        self.delegate = delegate
        self.usecase = usecase
        self.usecase?.delegate = self
    }
    
    func setUpBudget(budgetObject: Budget){
        self.budget = budgetObject
    }
    
    func fetchDataTransactions(cid: String){
        delegate?.startLoading()
        usecase?.getTransactionsbyCategory(cid: cid)
    }
    
    func fetchData(){
        getTransactionByCategoryInRange()
        getTotalAmount()
        processTransactionSection(list: finalTransactions)
    }
    
    func getTotalAmount(){
        var amount = 0
        for t in finalTransactions {
            amount += t.amount!
        }
        delegate?.getTotal(total: amount)
    }
    func processTransactionSection(list: [Transaction]){
        var sections = [TransactionSection]()
        for a in dates {
            var items = [TransactionItem]()
            var amount = 0
            //header
            for b in list {
                if a.dateString == b.date {
                    //MARK: - Get count for each header amount
                    if b.transactionType == TransactionType.expense.getValue(){
                        amount -= b.amount!
                    } else {
                        amount += b.amount!
                    }
                    //let note = b.note ?? ""
                    //MARK: - Get Item for each section of header
                    let categoryName = budget.categoryName!
                    let icon = budget.categoryImage!
                    let type = budget.transactionType!
                    var item = TransactionItem(id: "\(b.id!)", categoryName: categoryName,amount: b.amount!, iconImage: icon, type: type)
                    if let note = b.note {
                        item.note = note
                    }
                    items.append(item)
                }
            }
            let components = Defined.convertToDate(resultDate: a.dateString)
            let dateModel = Defined.getDateModel(components: components)
            let th = TransactionHeader(dateModel: dateModel, amount: amount)
            sections.append(TransactionSection(header: th, items: items))
            
        }
        transactionSections = sections
        delegate?.endLoading()
        delegate?.getTransactionSection(section: transactionSections)
    }
    
    
}

extension BudgetTransactionPresenter {
    func getDateArray(arr: [String], startDate: String, endDate: String) -> [TransactionDate]{
        let date1 = Defined.dateFormatter.date(from: startDate)!
        let date2 = Defined.dateFormatter.date(from: endDate)!
        var list = [TransactionDate]()
        var mDates = [Date]()
        for a in arr {
            let myDate = a
            let date = Defined.dateFormatter.date(from: myDate)!
            if date >= date1 && date <= date2 {
                mDates.append(date)
            }
        }
        //sort descending
        mDates = mDates.sorted { (first, second) -> Bool in
            first.compare(second) == ComparisonResult.orderedDescending        }
        //Date style: 18/09/2020
        Defined.dateFormatter.dateStyle = .short
        for d in mDates {
            let t = TransactionDate(dateString: Defined.dateFormatter.string(from: d), date: d)
            list.append(t)
        }
        return list
    }
    
    func getTransactionByCategoryInRange(){
        //date model of given month year
        dates = getDateArray(arr: Defined.getAllDayArray(allTransactions: allTransactions), startDate: budget.startDate!, endDate: budget.endDate!)
        //get transaction by month
        finalTransactions = Defined.getTransactionbyDate(dateArr: dates, allTrans: allTransactions)
    }
    
}

extension BudgetTransactionPresenter : BudgetTransactionUseCaseDelegate {
    func responseDataTransactions(trans: [Transaction]) {
        self.allTransactions = trans
        fetchData()
    }
    
    
}

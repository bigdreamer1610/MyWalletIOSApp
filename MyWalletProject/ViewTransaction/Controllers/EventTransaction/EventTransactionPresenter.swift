//
//  EventTransactionPresenter.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/7/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Foundation

protocol EventTransactionPresenterDelegate: class {
    func reloadData()
    func getTransactionSection(section: [TransactionSection])
    func getTotal(total: Int)
    func getAllTransactions(trans: [Transaction])
}

class EventTransactionPresenter {
    weak var delegate: EventTransactionPresenterDelegate?
    fileprivate var eventUseCase: EventTransactionUseCase?
    fileprivate var viewTransUseCase: ViewTransactionUseCase?
    
    var transactionSections = [TransactionSection]()
    var allTransactions = [Transaction]()
    var finalTransactions = [Transaction]()
    var dates = [TransactionDate]()
    var amount: Int = 0
    var event: Event!
    var categories: [Category]?
    
    var weekdays = ["Sunday","Monday","Tuesday","Wednesday","Thurday","Friday","Saturday"]
    var months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    init(delegate: EventTransactionPresenterDelegate, eventUseCase: EventTransactionUseCase, viewTransUseCase: ViewTransactionUseCase) {
        self.delegate = delegate
        self.eventUseCase = eventUseCase
        self.viewTransUseCase = viewTransUseCase
        self.viewTransUseCase?.delegate = self
        self.eventUseCase?.delegate = self
    }
    
    func setUpEvent(e: Event){
        self.event = e
    }
    
    func fetchCategories(){
        viewTransUseCase?.getListCategories()
    }
    
    func fetchDataTransactions(eid: String){
        eventUseCase?.getTransactionByEvent(eid: eid)
        
    }
    
    func fetchData(trans: [Transaction]){
        allTransactions = trans
        getTransactionByEvent()
        getTotalAmount()
        processTransactionSection(list: finalTransactions)
        
    }
    
    func getTotalAmount(){
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
                    //MARK: - Get Item for each section of header
                    var categoryName = ""
                    var icon = ""
                    var type = ""
                    for c in categories! {
                        if b.categoryid == c.id {
                            categoryName = c.name!
                            icon = c.iconImage!
                            type = c.transactionType!
                            break
                        }
                    }
                    var item = TransactionItem(id: "\(b.id!)", categoryName: categoryName,amount: b.amount!, iconImage: icon, type: type)
                    if let note = b.note {
                        item.note = note
                    }
                    if let eventid = b.eventid {
                        item.eventid = eventid
                    }
                    items.append(item)
                }
            }
            let components = Defined.convertToDate(resultDate: a.dateString)
            let dateModel = Defined.getDateModel(components: components, weekdays: weekdays, months: months)
            let th = TransactionHeader(dateModel: dateModel, amount: amount)
            sections.append(TransactionSection(header: th, items: items))
            
        }
        transactionSections = sections
        delegate?.getTransactionSection(section: transactionSections)
    }
    
}

extension EventTransactionPresenter {
    func getDateArray(arr: [String]) -> [TransactionDate]{
        var mDates = [Date]()
        for a in arr {
            let myDate = a
            let date = Defined.dateFormatter.date(from: myDate)!
            mDates.append(date)
        }
        return Defined.getTransactionDates(dates: mDates)
    }
    
    func getTransactionByEvent(){
        //date model of given month year
        dates = getDateArray(arr: Defined.getAllDayArray(allTransactions: allTransactions))
        //get transaction by month
        finalTransactions = Defined.getTransactionbyDate(dateArr: dates, allTrans: allTransactions)
    }
}

extension EventTransactionPresenter : ViewTransactionUseCaseDelegate {
    func responseBalance(balance: Int) {
        print("something")
    }
    
    func responseAllTransactions(trans: [Transaction]) {
        print("something")
    }
    
    func responseCategories(cate: [Category]) {
        DispatchQueue.main.async {
            self.categories = cate
        }
    }
    
}

extension EventTransactionPresenter : EventTransactionUseCaseDelegate {
    func responseDataTransactions(trans: [Transaction]) {
        self.allTransactions = trans
        delegate?.getAllTransactions(trans: trans)
    }
}

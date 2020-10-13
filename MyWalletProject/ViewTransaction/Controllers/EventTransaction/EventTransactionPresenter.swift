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
    func startLoading()
    func endLoading()
}
class EventTransactionPresenter {
    weak var delegate: EventTransactionPresenterDelegate?
    fileprivate var eventUseCase: EventTransactionUseCase?
    var transactionSections = [TransactionSection]()
    var allTransactions = [Transaction]()
    var finalTransactions = [Transaction]()
    var dates = [TransactionDate]()
    var event: Event!
    var categories: [Category]?
    
    
    init(delegate: EventTransactionPresenterDelegate, eventUseCase: EventTransactionUseCase) {
        self.delegate = delegate
        self.eventUseCase = eventUseCase
        self.eventUseCase?.delegate = self
    }
    func setUpEvent(e: Event){
        self.event = e
    }
    func fetchCategories(){
        eventUseCase?.getListCategories()
    }
    func fetchDataTransactions(eid: String){
        delegate?.startLoading()
        eventUseCase?.getTransactionByEvent(eid: eid)
    }
    func fetchData(){
        getTransactionByEvent()
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
            let dateModel = Defined.getDateModel(components: components)
            let th = TransactionHeader(dateModel: dateModel, amount: amount)
            sections.append(TransactionSection(header: th, items: items))
        }
        transactionSections = sections
        delegate?.endLoading()
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
extension EventTransactionPresenter : EventTransactionUseCaseDelegate {
    func responseDataCategory(cate: [Category]) {
        self.categories = cate
    }
    
    func responseDataTransactions(trans: [Transaction]) {
        self.allTransactions = trans
        fetchData()
    }
}

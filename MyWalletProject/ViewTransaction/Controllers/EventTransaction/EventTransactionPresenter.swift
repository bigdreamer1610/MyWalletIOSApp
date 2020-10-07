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
    fileprivate var usecase: EventTransactionUseCase?
    
    var transactionSections = [TransactionSection]()
    var allTransactions = [Transaction]()
    var finalTransactions = [Transaction]()
    var dates = [TransactionDate]()
    var amount: Int = 0
    var event: Event!
    
    var weekdays = ["Sunday","Monday","Tuesday","Wednesday","Thurday","Friday","Saturday"]
    var months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    init(delegate: EventTransactionPresenterDelegate, usecase: EventTransactionUseCase) {
        self.delegate = delegate
        self.usecase = usecase
        self.usecase?.delegate = self
    }
    
    func fetchDataTransactions(eid: String){
        usecase?.getTransactionByEvent(eid: eid)
    }
    
    func getTotalAmount(){
        for t in finalTransactions {
            amount += t.amount!
        }
        delegate?.getTotal(total: amount)
    }
    
    
}

extension EventTransactionPresenter {
    func getDateModel(components: DateComponents) -> DateModel{
        let weekDay = components.weekday!
        let month = components.month!
        let date = components.day!
        let year = components.year!
        let model = DateModel(date: date, month: months[month-1], year: year, weekDay: weekdays[weekDay-1])
        return model
    }
    //MARK: - Get all day string array sorted descending
    func getAllDayArray() -> [String]{
        var checkArray = [String]()
        //MARK: - Get all distinct date string
        for a in allTransactions {
            var check = false
            for b in checkArray {
                if a.date == b {
                    check = true
                }
            }
            if !check {
                checkArray.append(a.date!)
            }
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "vi_VN")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        //MARK: - Sort date string
        let sortedArray = checkArray.sorted { (first, second) -> Bool in
            dateFormatter.date(from: first)?.compare(dateFormatter.date(from: second)!) == ComparisonResult.orderedDescending
        }
        print("sortedArray: \(sortedArray)")
        return sortedArray
    }
    
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
        print("get Date array: \(list)")
        return list
    }
    
    func getTransactionByCategoryInRange(){
        //date model of given month year
        //dates = getDateArray(arr: getAllDayArray(), startDate: budget.startDate!, endDate: budget.endDate!)
        //get transaction by month
        finalTransactions = getTransactionbyDate(dateArr: dates)
        print("final transactions: \(finalTransactions.count)")
    }
    
    func getTransactionbyDate(dateArr: [TransactionDate]) -> [Transaction]{
        var list = [Transaction]()
        for day in dateArr {
            for tran in allTransactions {
                if tran.date == day.dateString {
                    list.append(tran)
                }
            }
        }
        print("get Transaction by date: \(list)")
        return list
    }
}

extension EventTransactionPresenter : EventTransactionUseCaseDelegate {
    func responseDataTransactions(trans: [Transaction]) {
        self.allTransactions = trans
        delegate?.getAllTransactions(trans: trans)
    }
    
    
}

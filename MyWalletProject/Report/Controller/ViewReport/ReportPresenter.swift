//
//  ReportPresenter.swift
//  MyWalletProject
//
//  Created by Nguyen Thi Huong on 10/9/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
import UIKit

protocol ReportPresenterDelegate: class {
    func returnIncomeDataForView(incomeArray: [Transaction], sumIncome: Int)
    func returnExpenseDataForView(expenseArray: [Transaction], sumExpense: Int)
    func returnIncomeDataForPieChart(sum: [SumByCate])
    func returnExpenseDataForPieChart(sum: [SumByCate])
    func returnCategories(categories: [Category])
    func returnDetailCell(open: Int)
}

class ReportPresenter {
    var delegate: ReportPresenterDelegate?
    var usecase: ReportUseCase?
    
    var sumByCategoryIncome = [SumByCate]()
    var sumByCategoryExpense = [SumByCate]()
    
    var allTransactions = [Transaction]()
    var finalTransactions = [Transaction]()
    var myDate: String = ""
    var month = ""
    var year = ""
    
    init(delegate: ReportPresenterDelegate, usecase: ReportUseCase) {
        self.delegate = delegate
        self.usecase = usecase
        self.usecase?.delegate = self
    }
}

extension ReportPresenter {
    func requestIncome(dateInput: String) {
        usecase?.getIncomeFromDB(dateInput: dateInput)
    }
    
    func requestExpense(dateInput: String) {
        usecase?.getExpenseFromDB(dateInput: dateInput)
    }
    
    func requestCategories(nameNode: String) {
        usecase?.getCategoriesFromDB(nameNode: nameNode)
    }
    
    func handleDataForPieChart(dataArray: [Transaction], state: State?) {
        var sumByCategory = [SumByCate]()
        for index in 0 ..< dataArray.count {
            let sumIndex = checkExist(category: dataArray[index].categoryid!, array: sumByCategory)
            if sumIndex != -1 {
                sumByCategory[sumIndex].amount += dataArray[index].amount!
            } else {
                sumByCategory.append(SumByCate(category: dataArray[index].categoryid!, amount: dataArray[index].amount!))
            }
        }
        sumByCategory.sort(by: { $0.amount > $1.amount })
        if state == .income {
            sumByCategoryIncome = sumByCategory
            self.delegate?.returnIncomeDataForPieChart(sum: sumByCategoryIncome)
        } else {
            sumByCategoryExpense = sumByCategory
            self.delegate?.returnExpenseDataForPieChart(sum: sumByCategoryExpense)
        }
    }
    
    // Check if a Category exists
    func checkExist(category: String, array: [SumByCate]) -> Int {
        for index in 0 ..< array.count {
            if category == array[index].category {
                return index
            }
        }
        return -1
    }
    
    //MARK: - Data for money cell
    
    // load transaction to set up sections
    func requestAllTransaction(dateInput: String) {
        usecase?.getAllTransactions()
        self.myDate = dateInput
    }
    
    func getDateArray(arr: [String], month: Int, year: Int) -> [TransactionDate] {
        var mDates = [Date]()
        arr.forEach { (a) in
            let myDate = a
            let date = Defined.dateFormatter.date(from: myDate)
            let components = Defined.calendar.dateComponents([.day, .month, .year, .weekday], from: date!)
            //if year & month = given
            if components.month == month && components.year == year {
                mDates.append(date!)
            }
        }
        return Defined.getTransactionDates(dates: mDates)
    }
    
    // Get All transaction from the given month/year
    func getTransactionbyDate(dateArr: [TransactionDate]) -> [Transaction] {
        var list = [Transaction]()
        for day in dateArr {
            for tran in allTransactions {
                if tran.date == day.dateString {
                    list.append(tran)
                }
            }
        }
        return list
    }
    
    // Calculate sum amount of given list in a months
    func calculateDetail(list: [Transaction]) -> Int {
        var number = 0
        list.forEach { (a) in
            if a.transactionType == TransactionType.expense.getValue(){
                number -= a.amount!
            } else {
                number += a.amount!
            }
        }
        return number
    }
    
    func loadDetailCell(month: Int, year: Int) -> Int {
        let previousMonth = (month == 1) ? 12 : (month - 1)
        let previousYear = (month == 1) ? (year - 1) : year
        let previousDates = getDateArray(arr: Defined.getAllDayArray(allTransactions: allTransactions), month: previousMonth, year: previousYear)
        let open = calculateDetail(list: getTransactionbyDate(dateArr: previousDates))
        return open
    }
}

extension ReportPresenter: ReportUseCaseDelegate {
    
    func responseAllTransactions(trans: [Transaction]) {
        self.allTransactions = trans
        let tempDate = myDate.split(separator: "/")
        month = String(tempDate[0])
        year = String(tempDate[1])
        delegate?.returnDetailCell(open: loadDetailCell(month: Int(self.month) ?? 0, year: Int(self.year) ?? 0))
    }
    
    func responseCategories(categories: [Category]) {
        self.delegate?.returnCategories(categories: categories)
    }
    
    func responseIncomeData(incomeArray: [Transaction], sumIncome: Int) {
        self.delegate?.returnIncomeDataForView(incomeArray: incomeArray, sumIncome: sumIncome)
    }
    
    func responseExpenseData(expenseArray: [Transaction], sumExpense: Int) {
        self.delegate?.returnExpenseDataForView(expenseArray: expenseArray, sumExpense: sumExpense)
    }
}

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
}

class ReportPresenter {
    var delegate: ReportPresenterDelegate?
    var usecase: ReportUseCase = ReportUseCase()
    
    var sumByCategoryIncome = [SumByCate]()
    var sumByCategoryExpense = [SumByCate]()
    
    init() {
        self.usecase.delegate = self
    }
}

extension ReportPresenter {
    func requestIncome(dateInput: String) {
        usecase.getIncomeFromDB(dateInput: dateInput)
    }
    
    func requestExpense(dateInput: String) {
        usecase.getExpenseFromDB(dateInput: dateInput)
    }
    
    func requestCategories(nameNode: String) {
        usecase.getCategoriesFromDB(nameNode: nameNode)
        
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
}

extension ReportPresenter: ReportUseCaseDelegate {
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

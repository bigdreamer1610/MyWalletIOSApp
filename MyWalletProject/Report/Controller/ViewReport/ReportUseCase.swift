//
//  ReportUseCase.swift
//  MyWalletProject
//
//  Created by Nguyen Thi Huong on 10/9/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import CodableFirebase

protocol ReportUseCaseDelegate {
    func responseIncomeData(incomeArray: [Transaction], sumIncome: Int)
    func responseExpenseData(expenseArray: [Transaction], sumExpense: Int)
    func responseCategories(categories: [Category])
}

class ReportUseCase {
    var expenseArray: [Transaction] = []
    var incomeArray: [Transaction] = []
    var sumIncome = 0
    var sumExpense = 0
    var categories: [Category] = []
    var delegate: ReportUseCaseDelegate?
}

extension ReportUseCase {
    func getIncomeFromDB(dateInput: String) {
        Defined.ref.child(Path.income.getPath()).observe(.value) {
            snapshot in
            self.incomeArray.removeAll()
            self.sumIncome = 0
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    return
                }
                let amount = dict["amount"] as! Int
                let date = dict["date"] as! String
                let categoryid = dict["categoryid"] as! String
                let note = dict["note"] as! String
                let transactionType = "income"

                let tempDate = date.split(separator: "/")
                let checkDate = tempDate[1] + "/" + tempDate[2]
                if dateInput == checkDate {
                    let ex = Transaction(transactionType: transactionType, amount: amount, categoryid: categoryid, date: date, note: note)
                    self.sumIncome += amount
                    self.incomeArray.append(ex)
                }
            }
            self.delegate?.responseIncomeData(incomeArray: self.incomeArray, sumIncome: self.sumIncome)
        }
    }
    
    
    func getExpenseFromDB(dateInput: String) {
        Defined.ref.child(Path.expense.getPath()).observe( .value) {
            snapshot in
            self.expenseArray.removeAll()
            self.sumExpense = 0
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    return
                }
                let amount = dict["amount"] as! Int
                let date = dict["date"] as! String
                let categoryid = dict["categoryid"] as! String
                let note = dict["note"] as! String
                let transactionType = "expense"
                
                let tempDate = date.split(separator: "/")
                let checkDate = tempDate[1] + "/" + tempDate[2]
                if dateInput == checkDate {
                    let ex = Transaction(transactionType: transactionType, amount: amount, categoryid: categoryid, date: date, note: note)
                    self.sumExpense += amount
                    self.expenseArray.append(ex)
                }
            }
            self.delegate?.responseExpenseData(expenseArray: self.expenseArray, sumExpense: self.sumExpense)
        }
    }
    
    func getCategoriesFromDB(nameNode: String) {
        Defined.ref.child(Path.category.getPath()).child(nameNode).observe(.value) {
            snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    return
                }
                let id = child.key
                let iconImage = dict["iconImage"] as! String
                let name = dict["name"] as! String
                let ex = Category(id: id, name: name, iconImage: iconImage)
                self.categories.append(ex)
            }
            self.delegate?.responseCategories(categories: self.categories)
        }
    }
}


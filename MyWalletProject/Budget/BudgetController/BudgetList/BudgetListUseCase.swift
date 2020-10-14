//
//  BudgetListUseCase.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 10/7/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
import Firebase

protocol BudgetListUseCaseDelegate : class{
    func getListBudget(budgetCurrents:[Budget] , budgetFinishs:[Budget] , transactions:[Transaction])
}

class BudgetListUseCase {
    weak var delegate : BudgetListUseCaseDelegate?
}

extension BudgetListUseCase {
    
    //MARK: get data Firebase Budget and Transaction
    func getDataBudget() {
        let time = Date()
        var listBudgetCurrent = [Budget]()
        var listBudgetFinish = [Budget]()
        var listTransaction = [Transaction]()
        
        let dispatchGroup = DispatchGroup() // tạo luồng load cùng 1 nhóm
        // load api Budget
        dispatchGroup.enter()
        Defined.ref.child(FirebasePath.budget).observeSingleEvent(of: .value) { (data) in
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
                if let end = end , end < time {
                    listBudgetFinish.append(budget)
                } else {
                    listBudgetCurrent.append(budget)
                }
            }
            dispatchGroup.leave()
        }
        
        // Load api Transaction expense
        dispatchGroup.enter()
        Defined.ref.child(FirebasePath.transaction).child("expense").observeSingleEvent(of: .value) { (data) in
            for case let child as DataSnapshot in data.children{
                guard let dict = child.value as? [String:Any] else {
                    print("Error")
                    return
                }
                let cateName = dict["categoryid"] as? String
                let amount = dict["amount"] as? Int
                let date = dict["date"] as? String
                let transaction = Transaction(amount: amount, categoryid: cateName , date: date)
                listTransaction.append(transaction)
            }
            dispatchGroup.leave()
        }
        
        // load api transaction income
        dispatchGroup.enter()
        Defined.ref.child(FirebasePath.transaction).child("income").observeSingleEvent(of: .value) { (data) in
            for case let child as DataSnapshot in data.children{
                guard let dict = child.value as? [String:Any] else {
                    print("Error")
                    return
                }
                let cateName = dict["categoryid"] as? String
                let amount = dict["amount"] as? Int
                let date = dict["date"] as? String
                let transaction = Transaction(amount: amount, categoryid: cateName , date: date)
                listTransaction.append(transaction)
            }
            dispatchGroup.leave()
        }
        // Sau khi load hết api mới reload lại table
        dispatchGroup.notify(queue: .main, execute: {
            self.delegate?.getListBudget(budgetCurrents: listBudgetCurrent, budgetFinishs: listBudgetFinish, transactions: listTransaction)
        })
    }
    
}



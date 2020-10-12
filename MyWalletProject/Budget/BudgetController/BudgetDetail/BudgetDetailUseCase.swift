//
//  BudgetDetailUseCase.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 10/7/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
import Firebase

protocol BudgetDetailUseCaseDelegate : class {
    func getBudget(budget:Budget , listTransaction:[Transaction])
}

class BudgetDetailUseCase {
    weak var delegate : BudgetDetailUseCaseDelegate?
}

extension BudgetDetailUseCase {
    
    func deleteBudgetDB1(id:Int){
        Defined.ref.child("Account").child("userid1").child("budget").child("\(id)").removeValue()
    }
    
    func getDataBudget(id:Int) {
        var listBudget = [Budget]()
        var listTransaction = [Transaction]()
        
        let dispatchGroup = DispatchGroup() // tạo luồng load cùng 1 nhóm
        // load api Budget
        dispatchGroup.enter()
        Defined.ref.child("Account").child("userid1").child("budget").observeSingleEvent(of: .value) { (data) in
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
                listBudget.append(budget)
            }
            dispatchGroup.leave()
        }
        
        // Load api Transaction expense
        dispatchGroup.enter()
        Defined.ref.child("Account").child("userid1").child("transaction").child("expense").observeSingleEvent(of: .value) { (data) in
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
        Defined.ref.child("Account").child("userid1").child("transaction").child("income").observeSingleEvent(of: .value) { (data) in
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
            for budgetObject in listBudget {
                if budgetObject.id == id {
                    self.delegate?.getBudget(budget: budgetObject, listTransaction: listTransaction)
                }
            }
        })
    }
}


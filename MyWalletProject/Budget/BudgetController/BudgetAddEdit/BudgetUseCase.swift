//
//  BudgetUseCase.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 10/7/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
import Firebase

protocol BudgetUseCaseDelegate : class {
    func getNewChildID(id:Int)
    func getListBudgetName(listBudgetName:[Budget])
    func getListTransaction(listTransaction:[Transaction])
}

protocol BudgetAdd {
    func getnewChild()
    func addBudgetDB(budget:Budget , id : Int)
}

protocol BudgetEdit {
    func editBudgetDB(budget: Budget)
}

class BudgetUseCase {
    weak var delegate:BudgetUseCaseDelegate?
}

// MARK: - get list Budget
extension BudgetUseCase {
    
    func getListBudget() {
        var listBudgetName = [Budget]()
        Defined.ref.child(FirebasePath.budget).observeSingleEvent(of: .value) { (data) in
            for case let child as DataSnapshot in data.children{
                guard let dict = child.value as? [String:Any] else{
                    print("Error")
                    return
                }
                let cateName = dict["categoryName"] as? String
                let startDate = dict["startDate"] as? String
                let endDate = dict["endDate"] as? String
                let budget = Budget(categoryName: cateName, startDate: startDate, endDate: endDate)
                listBudgetName.append(budget)
            }
            self.delegate?.getListBudgetName(listBudgetName: listBudgetName)
        }
        
    }
    
    func getlistTrans(){
        var listTransaction = [Transaction]()
        
        // tạo luồng load cùng 1 nhóm
        let dispatchGroup = DispatchGroup()
        // Load api Transaction expense
        dispatchGroup.enter()
        Defined.ref.child(FirebasePath.expense).observeSingleEvent(of: .value) { (data) in
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
        Defined.ref.child(FirebasePath.income).observeSingleEvent(of: .value) { (data) in
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
        
        dispatchGroup.notify(queue: .main, execute: {
            self.delegate?.getListTransaction(listTransaction: listTransaction)
        })
    }
}

//MARK: - add budget
extension BudgetUseCase : BudgetAdd{
    // get new child id
    func getnewChild(){
        var newChild = 0
        Defined.ref.child(FirebasePath.budget).observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let self = self else {
                return
            }
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                if snapshots.count < 1{
                    newChild = 1
                }
                else{
                    for snap in snapshots.reversed() {
                        let keyString = snap.key
                        if let keyInt = Int(keyString){
                            newChild = keyInt + 1
                        }
                        break;
                    }
                }
            }
            self.delegate?.getNewChildID(id: newChild)
        }
    }
    
    // add budget to db
    func addBudgetDB(budget: Budget, id: Int) {
        let budget = [
            "id" : id,
            "categoryId" : budget.categoryId!,
            "categoryName" : budget.categoryName!,
            "categoryImage" : budget.categoryImage!,
            "transactionType" : budget.transactionType!,
            "amount" : budget.amount!,
            "startDate" : budget.startDate!,
            "endDate" : budget.endDate!
            ] as [String : Any]
        
        Defined.ref.child(FirebasePath.budget).child("\(id)").updateChildValues(budget,withCompletionBlock: { error , ref in
            if error == nil {
            }else{
            }
        } )
    }
}

extension BudgetUseCase : BudgetEdit {
    func editBudgetDB(budget: Budget) {
        let budget1 = [
            "id" : budget.id!,
            "categoryId" : budget.categoryId! ,
            "categoryName" : budget.categoryName!,
            "categoryImage" : budget.categoryImage!,
            "transactionType" : budget.transactionType!,
            "amount" : budget.amount!,
            "startDate" : budget.startDate!,
            "endDate" : budget.endDate!,
        ] as [String : Any]
        
        Defined.ref.child(FirebasePath.budget).child("\(budget.id!)").updateChildValues(budget1,withCompletionBlock: { error , ref in
            if error == nil {
            }else{
            }
        } )
    }
}


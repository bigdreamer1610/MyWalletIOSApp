//
//  BudgetPresenter.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 10/7/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

protocol BudgetPresenterDelegate : class{
    func getNewChildID(id:Int)
    func getListBudgetName(listBudgetName:[Budget])
    func getListTransaction(listTransaction:[Transaction])
    func getAmount(amount:Int)
}

class BudgetPresenter {
    weak var delegate : BudgetPresenterDelegate?
    fileprivate var budgetUseCase : BudgetUseCase?
    
    init(delegate : BudgetPresenterDelegate , budgetUseCase : BudgetUseCase) {
        self.delegate = delegate
        self.budgetUseCase = budgetUseCase
        self.budgetUseCase?.delegate = self
    }
    
    func getListBudgetName(){
        budgetUseCase?.getListBudget()
    }
    
    func getlistTransaction(){
        budgetUseCase?.getlistTrans()
    }
    
    func getNewId(){
        budgetUseCase?.getnewChild()
    }
    
    func addBudget(budget: Budget, id: Int){
        budgetUseCase?.addBudgetDB(budget: budget, id: id)
    }
    
    func editBudget(budget:Budget){
        budgetUseCase?.editBudgetDB(budget: budget)
    }
    
    func getAmountTrans(budget:Budget , listTransaction:[Transaction]){
        var amount = 0
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let start = formatter.date(from: budget.startDate ?? "")
        let end = formatter.date(from: budget.endDate ?? "")
        for transaction in listTransaction {
            if (budget.categoryName == transaction.categoryid) {
                let date = formatter.date(from: transaction.date!)
                if let start = start , let end = end , let date = date{
                    if date >= start && date < end {
                        amount += transaction.amount ?? 0
                    }
                }
            }
        }
        delegate?.getAmount(amount: amount)
    }
}

extension BudgetPresenter : BudgetUseCaseDelegate {
    func getNewChildID(id: Int) {
        delegate?.getNewChildID(id: id)
    }
    
    func getListBudgetName(listBudgetName: [Budget]) {
        delegate?.getListBudgetName(listBudgetName: listBudgetName)
    }
    
    func getListTransaction(listTransaction: [Transaction]) {
        delegate?.getListTransaction(listTransaction: listTransaction)
    }
}

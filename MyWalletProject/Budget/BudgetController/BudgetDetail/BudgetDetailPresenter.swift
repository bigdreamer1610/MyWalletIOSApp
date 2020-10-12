//
//  BudgetDetailPresenter.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 10/7/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

protocol BudgetDetailPresenterDelegate : class {
    func getBudget(budget:Budget , listTransaction:[Transaction])
    func getAmount(amount: Int)
}
 
class BudgetDetailPresenter {
    weak var delegate : BudgetDetailPresenterDelegate?
    fileprivate var budgetDetailUseCase:BudgetDetailUseCase?
    
    init(delegate : BudgetDetailPresenterDelegate , usecase: BudgetDetailUseCase) {
        self.delegate = delegate
        self.budgetDetailUseCase = usecase
        self.budgetDetailUseCase?.delegate = self
    }
    
    func deleteBudgetDB(id:Int){
        budgetDetailUseCase?.deleteBudgetDB1(id: id)
    }
    
    func getDataBudgetId(id:Int){
        budgetDetailUseCase?.getDataBudget(id: id)
    }
}

extension BudgetDetailPresenter{
    // get amount transaction
    func getAmountListTransaction(budget:Budget, listTransaction:[Transaction]){
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

extension BudgetDetailPresenter : BudgetDetailUseCaseDelegate {
    func getBudget(budget: Budget, listTransaction: [Transaction]) {
        delegate?.getBudget(budget: budget, listTransaction: listTransaction)
    }
    
}

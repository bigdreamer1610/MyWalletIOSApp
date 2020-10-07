//
//  BudgetListPresenter.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 10/7/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

protocol BudgetListPresenterDelegate: class {
    func getDataListBudgetPresenter(budgetCurrents:[Budget], budgetFinishs:[Budget], transactions:[Transaction])
    func getAmount(amount: Int)
}

class BudgetListPresenter {
    weak var delegate : BudgetListPresenterDelegate?
    fileprivate var budgetlistUseCase: BudgetListUseCase?
    
    init(delegate : BudgetListPresenterDelegate, budgetlistUseCase: BudgetListUseCase) {
        self.delegate = delegate
        self.budgetlistUseCase = budgetlistUseCase
        self.budgetlistUseCase?.delegate = self
    }
    
    func getDataBudget(){
        budgetlistUseCase?.getDataBudget()
    }
}

extension BudgetListPresenter{
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

extension BudgetListPresenter:BudgetListUseCaseDelegate {
    func getListBudget(budgetCurrents: [Budget], budgetFinishs: [Budget], transactions: [Transaction]) {
        delegate?.getDataListBudgetPresenter(budgetCurrents: budgetCurrents, budgetFinishs: budgetFinishs, transactions: transactions)
    }
    
}


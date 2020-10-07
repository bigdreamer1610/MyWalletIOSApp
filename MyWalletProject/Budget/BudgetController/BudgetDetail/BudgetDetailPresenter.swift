//
//  BudgetDetailPresenter.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 10/7/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

class BudgetDetailPresenter {
    fileprivate var budgetDetailUseCase:BudgetDetailUseCase?
    
    init(usecase: BudgetDetailUseCase) {
        self.budgetDetailUseCase = usecase
    }
    
    func deleteBudgetDB(id:Int){
        budgetDetailUseCase?.deleteBudgetDB1(id: id)
    }
}

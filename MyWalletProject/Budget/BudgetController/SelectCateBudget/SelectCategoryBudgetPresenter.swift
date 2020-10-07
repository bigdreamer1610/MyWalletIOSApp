//
//  SelectCategoryBudgetPresenter.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 10/7/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

protocol SelectCategoryBudgetPresenterDelegate : class {
    func getDataCate(listCateExpense:[Category], listCateIncome:[Category])
}

class SelectCategoryBudgetPresenter {
    weak var delegate : SelectCategoryBudgetPresenterDelegate?
    fileprivate var selectCateBudgetUseCase : SelectCategoryBudgetUseCase?
    
    init(delegate : SelectCategoryBudgetPresenterDelegate , selectCateBudgetUseCase : SelectCategoryBudgetUseCase) {
        self.delegate = delegate
        self.selectCateBudgetUseCase = selectCateBudgetUseCase
        self.selectCateBudgetUseCase?.delegate = self
    }
    
    func getCateDB(){
        selectCateBudgetUseCase?.getDataCategoryDB()
    }
}

extension SelectCategoryBudgetPresenter : SelectCategoryBudgetUseCaseDelegate {
    func getDataCate(listCateExpense: [Category], listCateIncome: [Category]) {
        delegate?.getDataCate(listCateExpense: listCateExpense, listCateIncome: listCateIncome)
    }
    
}

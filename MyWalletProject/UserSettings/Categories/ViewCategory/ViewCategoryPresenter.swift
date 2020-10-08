//
//  ViewCategoryPresenter.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

protocol ViewCategoryPresenterDelegate {
    func receiveIncomeCategories(_ listCategoryIncome: [Category])
    func receiveExpenseCategories(_ listCategoryExpense: [Category])
    func receiveListImage(_ listImage: [String])
}

class ViewCategoryPresenter {
    var delegate: ViewCategoryPresenterDelegate?
    var usecase: ViewCategoryUseCase?
    
    init(delegate: ViewCategoryPresenterDelegate, usecase: ViewCategoryUseCase) {
        self.delegate = delegate
        self.usecase = usecase
        self.usecase?.delegate = self
    }
}

extension ViewCategoryPresenter {
    func requestListImage() {
        usecase?.getListImage()
    }
    
    func requestIncomeCategories() {
        usecase?.getIncomeCategories()
    }
    
    func requestExpenseCategories() {
        usecase?.getExpenseCategories()
    }
}

extension ViewCategoryPresenter: ViewCategoryUseCaseDelegate {
    func reponseListImage(_ listImage: [String]) {
        delegate?.receiveListImage(listImage)
    }
    
    func responseListCategoryIncome(_ listCategoryIncome: [Category]) {
        delegate?.receiveIncomeCategories(listCategoryIncome)
    }
    
    func responseListCategoryExpense(_ listCategoryExpense: [Category]) {
        delegate?.receiveExpenseCategories(listCategoryExpense)
    }
}

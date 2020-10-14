//
//  DetailCategoryPresenter.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 10/8/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

protocol DetailCategoryPresenterDelegate {
    func finishDeleteCategory()
}

class DetailCategoryPresenter {
    var delegate: DetailCategoryPresenterDelegate?
    var usecase: DetailCategoryUseCase?
    
    init(delegate: DetailCategoryPresenterDelegate, usecase: DetailCategoryUseCase) {
        self.delegate = delegate
        self.usecase = usecase
    }
}

extension DetailCategoryPresenter {
    func deleteCategory(_ category: Category) {
        usecase?.deleteCategoryInDB(category)
        delegate?.finishDeleteCategory()
    }
    
    func deleteAllTransactionOfCategory(_ category: Category) {
        usecase?.deleteAllTransactionOfCategoryInDB(category)
    }
    
    func deleteAllBudgetOfCategory(_ category: Category) {
        usecase?.deleteAllBudgetOfCategoryInDB(category)
    }
}

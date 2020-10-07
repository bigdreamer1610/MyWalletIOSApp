//
//  AddEditCategoryPresenter.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

protocol AddEditCategoryPresenterDelegate {
    func showAlertMessage(_ message: String, _ state: Bool)
}

class AddEditCategoryPresenter {
    var delegate: AddEditCategoryPresenterDelegate?
    var usecase: AddEditCategoryUseCase?
    
    init(delegate: AddEditCategoryPresenterDelegate, usecase: AddEditCategoryUseCase) {
        self.delegate = delegate
        self.usecase = usecase
    }
}

extension AddEditCategoryPresenter {
    func saveUserCategory(_ category: Category, _ categoryType: String) {
        usecase?.saveUserCategoryToDB(category, categoryType)
    }
    
    func validateInput(_ categoryName: String?, _ imageIndex: Int?) {
        var message = ""
        var state = false
        
        // MARK: - Handle invalid cases
        if let name = categoryName, name.isEmpty {
            message = "Category name can not be blank, please try again!"
        } else if let index = imageIndex, index == -1 {
            message = "Please choose an image for your category"
        } else {
            state = true
        }
        
        delegate?.showAlertMessage(message, state)
    }
}

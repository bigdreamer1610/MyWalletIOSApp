//
//  AddTransactionPresenter.swift
//  MyWalletProject
//
//  Created by BAC Vuong Toan (VTI.Intern) on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

protocol AddTransactionPresenterDelegate: class {
    
}
class AddTransactionPresenter  {
    fileprivate var usecase: AddTransactionUseCase?

    init(usecase: AddTransactionUseCase) {
        self.usecase = usecase
    }
    
    func add(trans: Transaction){
        usecase?.addTransactionToDB(t: trans)
    }
}


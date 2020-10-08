//
//  EditTransactionPresenter.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/8/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit



class EditTransactionPresenter {
    fileprivate var usecase: EditTransactionUseCase?
    
    init(usecase: EditTransactionUseCase) {
        self.usecase = usecase
    }
    
    func update(t: Transaction, oldType: String){
        usecase?.editTransaction(trans: t, oldType: oldType)
    }
}

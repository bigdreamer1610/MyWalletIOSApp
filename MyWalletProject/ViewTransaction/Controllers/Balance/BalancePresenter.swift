//
//  BalancePresenter.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/5/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

class BalancePresenter {
    fileprivate var balanceUseCase: BalanceUseCase?
    
    init(usecase: BalanceUseCase) {
        self.balanceUseCase = usecase
    }
    
    func updateBalance(with balance: Int){
        balanceUseCase?.saveBalanceToDB(balance: balance)
    }
}


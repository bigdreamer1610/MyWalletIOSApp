//
//  BalanceUseCase.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/5/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

class BalanceUseCase {
}

extension BalanceUseCase {
    func saveBalanceToDB(balance: Int){
        Defined.ref.child("Account/userid1/information").updateChildValues(["balance": balance]){ (error,reference) in
            
        }
        Defined.defaults.set(balance, forKey: Constants.balance)
    }
}





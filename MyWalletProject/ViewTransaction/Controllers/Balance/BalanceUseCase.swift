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
        let old = Defined.defaults.integer(forKey: Constants.balance)
        if old != balance {
            let writeData: [String: Any] = [
                "date": Defined.dateFormatter.string(from: Date()),
                "note": "Adjust balance",
                "amount" : abs(balance - old),
                "categoryid": "Others"]
            let type = (old > balance) ? TransactionType.expense.getValue() : TransactionType.income.getValue()
            Defined.ref.child(FirebasePath.transaction).child("\(type)").childByAutoId().setValue(writeData)
            Defined.ref.child(FirebasePath.information).updateChildValues(["balance": balance]){ (error,reference) in
                
            }
            Defined.defaults.set(balance, forKey: Constants.balance)
        }
        
    }
}





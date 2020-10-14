//
//  AddTransactionUseCase.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Firebase

class AddTransactionUseCase{
    
}
extension AddTransactionUseCase{
    func addTransactionToDB(t: Transaction){
        // add a new transaction
        let writeData: [String: Any] = [
            "date": t.date!,
            "note": t.note!,
            "amount" : t.amount!,
            "categoryid": t.categoryid!,
            "eventid":t.eventid!]
        Defined.ref.child(FirebasePath.transaction).child("/\(t.transactionType!)").childByAutoId().setValue(writeData)
        
        // adjust balance
        var balance = Defined.defaults.integer(forKey: Constants.balance)
        if t.transactionType == TransactionType.expense.getValue() {
            balance -= t.amount!
        } else {
            balance += t.amount!
        }
        Defined.ref.child(FirebasePath.information).updateChildValues(["balance": balance]){ (error,reference) in
            
        }
    }
}

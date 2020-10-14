//
//  EditTransactionUseCase.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/8/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Firebase



class EditTransactionUseCase {}

extension EditTransactionUseCase {
    func editTransaction(trans: Transaction, oldTrans: Transaction){
        let update = [
            "note":trans.note!,
            "date":trans.date!,
            "categoryid": trans.categoryid!,
            "amount": trans.amount!,
            "eventid": trans.eventid!
            ] as [String : Any]
        
        var balance = Defined.defaults.integer(forKey: Constants.balance) + oldTrans.amount!
        if oldTrans.transactionType == TransactionType.income.getValue() {
            balance = Defined.defaults.integer(forKey: Constants.balance) - oldTrans.amount!
        }
        //transactiontype changes
        if trans.transactionType != oldTrans.transactionType {
            Defined.ref.child(FirebasePath.transaction).child(oldTrans.transactionType ?? "").child("\(trans.id ?? "")").removeValue()
        }
        // adjust balance
        if trans.transactionType == TransactionType.expense.getValue() {
            balance -= trans.amount!
        } else {
            balance += trans.amount!
        }
        
        // update balance in firebase
        Defined.ref.child(FirebasePath.information).updateChildValues(["balance": balance]){ (error,reference) in
            
        }
        
        //set userdefaults balance
        Defined.defaults.set(balance, forKey: Constants.balance)
        
        //update transaction
        Defined.ref.child(FirebasePath.transaction).child("/\(trans.transactionType!)/\(trans.id ?? "")").updateChildValues(update) { (error, reference) in
            if error != nil {
                
            } else {
                print(reference)
            }
        }
    }
}

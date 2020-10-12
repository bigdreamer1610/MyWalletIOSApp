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
    func editTransaction(trans: Transaction, oldType: String){
        let update = [
            "note":trans.note!,
            "date":trans.date!,
            "categoryid": trans.categoryid!,
            "amount": trans.amount!,
            "eventid": trans.eventid!
            ] as [String : Any]
        if trans.transactionType != oldType {
            Defined.ref.child("Account/userid1/transaction/\(oldType)/\(trans.id!)").removeValue { (error, reference) in
                //remove old position
            }
        }
        Defined.ref.child("Account/userid1/transaction/\(trans.transactionType!)/\(trans.id ?? "")").updateChildValues(update) { (error, reference) in
            if error != nil {
                print("Error: \(error!)")
            } else {
                print(reference)
            }
        }
    }
}

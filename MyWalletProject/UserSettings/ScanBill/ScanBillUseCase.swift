//
//  ScanBillUseCase.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 9/23/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol ScanBillUseCaseDelegate {
    func saveTransactionToDB(_ transaction: Transaction)
}

class ScanBillUseCase {
    var delegate: ScanBillUseCaseDelegate?
}

extension ScanBillUseCase: ScanBillUseCaseDelegate {
    func saveTransactionToDB(_ transaction: Transaction) {
        let userTransaction = [
            "amount": transaction.amount!,
            "categoryid": "Bill",
            "date": transaction.date!,
            "note": transaction.note!] as [String : Any]
        
        Defined.ref.child("Account").child("userid1").child("transaction").child("expense").childByAutoId().setValue(userTransaction, withCompletionBlock: {
            error, ref in
            if error == nil {}
            else {}
        })
    }
}


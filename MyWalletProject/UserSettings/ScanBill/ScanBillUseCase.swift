//
//  ScanBillUseCase.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 9/23/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ScanBillUseCase {
    
    var ref: DatabaseReference!
    
    // MARK: - Save transaction to DB
    func saveTransactionToDB(_ transaction: Transaction) {
        ref = Database.database().reference()
        
        let userTransaction = [
            "amount": transaction.amount!,
            "categoryid": "Bill",
            "date": transaction.date!,
        "note": transaction.note!] as [String : Any]
        
        self.ref.child("Account").child("userid1").child("transaction").child("expense").childByAutoId().setValue(userTransaction, withCompletionBlock: {
            error, ref in
            if error == nil {}
            else {}
        })
    }
}

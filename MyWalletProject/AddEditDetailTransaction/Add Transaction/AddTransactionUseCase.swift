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
        let writeData: [String: Any] = [
            "date": t.date!,
            "note": t.note!,
            "amount" : t.amount!,
            "categoryid": t.categoryid!,
            "eventid":t.eventid!]
        Defined.ref.child("Account/userid1/transaction/\(t.transactionType!)").childByAutoId().setValue(writeData)
    }
}

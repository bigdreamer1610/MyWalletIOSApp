//
//  BudgetTransactionUseCase.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Firebase

protocol BudgetTransactionUseCaseDelegate: class {
    func responseDataTransactions(trans: [Transaction])
}

class BudgetTransactionUseCase {
    weak var delegate: BudgetTransactionUseCaseDelegate?
}

extension BudgetTransactionUseCase {
    func getTransactionsbyCategory(cid: String){
        Defined.ref.child(FirebasePath.transaction).observe(.value) {[weak self] (snapshot) in
            guard let `self` = self else {
                return
            }
            var allTransactions = [Transaction]()
            for case let snapshots as DataSnapshot in snapshot.children {
                for case let snapshot as DataSnapshot in snapshots.children {
                    guard let dict = snapshot.value as? [String: Any] else {return}
                    let id = snapshot.key
                    let amount = dict["amount"] as? Int
                    let categoryid = dict["categoryid"] as? String
                    if categoryid == cid {
                        let date = dict["date"] as? String
                        let transactionType = snapshots.key
                        var transaction = Transaction(id: id, transactionType: transactionType, amount: amount, categoryid: categoryid, date: date)
                        if let note = dict["note"] as? String {
                            transaction.note = note
                        }
                        if let eventid = dict["eventid"] as? String {
                            transaction.eventid = eventid
                        }
                        allTransactions.append(transaction)
                    }
                }
            }
            self.delegate?.responseDataTransactions(trans: allTransactions)
        }
    }
}



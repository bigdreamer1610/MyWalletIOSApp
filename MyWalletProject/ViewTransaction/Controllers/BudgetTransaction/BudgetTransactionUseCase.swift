//
//  BudgetTransactionUseCase.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

protocol BudgetTransactionUseCaseDelegate: class {
    func responseDataTransactions(trans: [Transaction])
}

class BudgetTransactionUseCase {
    weak var delegate: BudgetTransactionUseCaseDelegate?
}

extension BudgetTransactionUseCase {
    func getTransactionsbyCategory(cid: String){
        Defined.ref.child(Path.transaction.getPath()).observe(.value) {[weak self] (snapshot) in
            guard let `self` = self else {
                return
            }
            var allTransactions = [Transaction]()
            for case let snapshots as DataSnapshot in snapshot.children {
                for case let snapshot as DataSnapshot in snapshots.children {
                    guard let dict = snapshot.value as? [String: Any] else {return}
                    do {
                        var model = try FirebaseDecoder().decode(Transaction.self, from: dict)
                        model.id = snapshot.key
                        model.transactionType = snapshots.key
                        if model.categoryid == cid {
                            allTransactions.append(model)
                        }
                        
                    } catch let error {
                        print(error)
                    }
                    
                }
            }
            self.delegate?.responseDataTransactions(trans: allTransactions)
        }
    }
}



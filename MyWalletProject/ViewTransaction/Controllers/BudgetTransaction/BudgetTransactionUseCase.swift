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

class BudgetTransactionUseCase : BaseUseCase {
    weak var delegate: BudgetTransactionUseCaseDelegate?
}

extension BudgetTransactionUseCase {
    func getTransactionsbyCategory(cid: String){
        getListAllTransactions { [weak self](transactions) in
            var allTransactions = [Transaction]()
            guard let `self` = self else {
                return
            }
            for trans in transactions {
                if trans.categoryid == cid {
                    allTransactions.append(trans)
                }
            }
            self.delegate?.responseDataTransactions(trans: allTransactions)
        }
        
    }
}



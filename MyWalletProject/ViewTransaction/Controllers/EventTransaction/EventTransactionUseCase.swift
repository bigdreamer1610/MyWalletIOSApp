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

protocol EventTransactionUseCaseDelegate: BaseUseCaseDelegate {
    func responseDataTransactions(trans: [Transaction])
}

class EventTransactionUseCase: BaseUseCase {
    weak var delegate: EventTransactionUseCaseDelegate?
}

extension EventTransactionUseCase {
    
    func getListCategories(){
        getListAllCategories { [weak self](categories) in
            guard let `self` = self else {return}
            self.delegate?.responseDataCategories(cate: categories)
        }
    }
    
    func getTransactionByEvent(eid: String){
        var transactions = [Transaction]()
        getListAllTransactions { [weak self](allTransactions) in
            guard let `self` = self else {
                return
            }
            for trans in allTransactions {
                if trans.eventid == eid {
                    transactions.append(trans)
                }
            }
            self.delegate?.responseDataTransactions(trans: transactions)
        }
    }
}



//
//  DetailTransactionUseCase.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

protocol DetailTransactionUseCaseDelegate: class {
    func responseEvent(event: Event)
    func responseTrans(trans: Transaction)
    func responseCategory(cate: Category)
    func responseNoEvent()
}
class DetailTransactionUseCase : BaseUseCase{
    weak var delegate: DetailTransactionUseCaseDelegate?
}

extension DetailTransactionUseCase {
    func getEventInfo(eventid: String){
        if eventid != "" {
            getListAllEvents { [weak self](events) in
                guard let `self` = self else {
                    return
                }
                for event in events {
                    if event.id == eventid {
                        self.delegate?.responseEvent(event: event)
                        break
                    }
                }
            }
        } else {
            delegate?.responseNoEvent()
        }
        
    }
    
    func deleteTransaction(t: Transaction){
        Defined.ref.child(Path.transaction.getPath()).child("/\(t.transactionType!)/\(t.id!)").removeValue { (error, reference) in
            //remove old position
        }
        var balance = Defined.defaults.integer(forKey: Constants.balance) + t.amount!
        if t.transactionType == TransactionType.income.getValue() {
            balance -= 2 * t.amount!
        }
        
        // update balance
        updateBalance(balance: balance)
    }
    
    func getTransaction(transid: String){
        getListAllTransactions { [weak self](transactions) in
            guard let `self` = self else {
                return
            }
            for trans in transactions {
                if trans.id == transid {
                    self.delegate?.responseTrans(trans: trans)
                    break
                }
            }
        }
    }
    
    func getCategory(cid: String){
        getListAllCategories {[weak self] (categories) in
            guard let `self` = self else {return}
            for cate in categories {
                if cate.id == cid {
                    self.delegate?.responseCategory(cate: cate)
                    break
                }
            }
        }
    }
}

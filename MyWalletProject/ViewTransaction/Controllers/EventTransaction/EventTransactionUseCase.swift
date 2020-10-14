//
//  BudgetTransactionUseCase.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Firebase

protocol EventTransactionUseCaseDelegate: class {
    func responseDataTransactions(trans: [Transaction])
    func responseDataCategory(cate: [Category])
}

class EventTransactionUseCase {
    weak var delegate: EventTransactionUseCaseDelegate?
}

extension EventTransactionUseCase {
    
    func getListCategories(){
        Defined.ref.child(FirebasePath.category).observe(.value) {[weak self] (snapshot) in
            guard let `self` = self else {return}
            var categories = [Category]()
            for case let snapshots as DataSnapshot in snapshot.children {
                for case let snapshot as DataSnapshot in snapshots.children {
                    guard let dict = snapshot.value as? [String:Any] else {
                        return
                    }
                    let id = snapshot.key
                    let name = dict["name"] as? String
                    let iconImage = dict["iconImage"] as? String
                    let transactionType =  snapshots.key
                    let category = Category(id: id, name: name, transactionType: transactionType, iconImage: iconImage)
                    categories.append(category)
                }
            }
            self.delegate?.responseDataCategory(cate: categories)
        }
    }
    
    func getTransactionByEvent(eid: String){
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
                    let date = dict["date"] as? String
                    let transactionType = snapshots.key
                    var transaction = Transaction(id: id, transactionType: transactionType, amount: amount, categoryid: categoryid, date: date)
                    if let note = dict["note"] as? String {
                        transaction.note = note
                    }
                    if let eventid = dict["eventid"] as? String {
                        transaction.eventid = eventid
                        if eventid == eid {
                            allTransactions.append(transaction)
                        }
                    }
                }
            }
            self.delegate?.responseDataTransactions(trans: allTransactions)
        }
    }
}



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
                    do {
                        var model = try FirebaseDecoder().decode(Category.self, from: dict)
                        model.transactionType = snapshots.key
                        model.id = snapshot.key
                        categories.append(model)
                    } catch let error {
                        print(error)
                    }
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
                    
                    do {
                        var model = try FirebaseDecoder().decode(Transaction.self, from: dict)
                        model.id = snapshot.key
                        model.transactionType = snapshots.key
                        if model.eventid == eid {
                            allTransactions.append(model)
                            print("event: \(model)")
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



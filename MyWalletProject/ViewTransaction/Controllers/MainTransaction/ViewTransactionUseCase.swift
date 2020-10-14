//
//  ViewTransactionUseCase.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/2/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import CodableFirebase

protocol ViewTransactionUseCaseDelegate: class {
    func responseCategories(cate: [Category])
    func responseBalance(balance: Int)
    func responseAllTransactions(trans: [Transaction])
}

class ViewTransactionUseCase {
    weak var delegate: ViewTransactionUseCaseDelegate?
}

extension ViewTransactionUseCase {
    
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
            self.delegate?.responseCategories(cate: categories)
        }
    }
    
    func getBalance(){
        Defined.ref.child(FirebasePath.balance).observe(.value) { (snapshot) in
            if let value = snapshot.value as? Int {
                self.delegate?.responseBalance(balance: value)
            }
        }
    }
    
    func getAllTransactions(){
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
                        allTransactions.append(model)
                    } catch let error {
                        print(error)
                    }
                }
            }
            self.delegate?.responseAllTransactions(trans: allTransactions)
        }
    }
    
}



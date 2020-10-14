//
//  BaseUseCase.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/13/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//


import UIKit
import Firebase
import CodableFirebase

class BaseUseCase {
    func getListAllCategories(completion: @escaping (([Category]) -> ())){
        Defined.ref.child(FirebasePath.category).observe(.value) { (snapshot) in
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
            completion(categories)
        }
    }
    
    func getListAllTransactions(completion: @escaping (([Transaction]) -> ())){
        Defined.ref.child(FirebasePath.transaction).observe(.value) { (snapshot) in
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
            completion(allTransactions)
        }
    }
    
}

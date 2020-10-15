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
        Defined.ref.child(Path.category.getPath()).observe(.value) { (snapshot) in
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
        Defined.ref.child(Path.transaction.getPath()).observe(.value) { (snapshot) in
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
                    }
                }
            }
            completion(allTransactions)
        }
    }
    
    func getListAllEvents(completion: @escaping (([Event]) -> ())){
        Defined.ref.child(Path.event.getPath()).observe(DataEventType.value) {(snapshot) in
            var events = [Event]()
            for case let snapshots as DataSnapshot in snapshot.children {
                guard let dict = snapshots.value as? [String:Any] else {
                    return
                }
                do {
                    let model = try FirebaseDecoder().decode(Event.self, from: dict)
                    events.append(model)
                } catch _ {
                }
            }
            completion(events)
        }
    }
    
    func updateBalance(balance: Int){
        // update balance in firebase
        Defined.ref.child(Path.information.getPath()).updateChildValues(["balance": balance]){ (error,reference) in
            
        }
        //set userdefaults balance
        Defined.defaults.set(balance, forKey: Constants.balance)
        
    }
    
}

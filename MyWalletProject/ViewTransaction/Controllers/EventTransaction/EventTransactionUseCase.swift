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
        var categories = [Category]()
        Defined.ref.child("Category").observe(.value) {[weak self] (snapshot) in
            guard let `self` = self else {return}
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                //expense/income
                for mySnap in snapshots {
                    let myKey = (mySnap as AnyObject).key as String
                    //key inside expense/income
                    if let mySnap = mySnap.children.allObjects as? [DataSnapshot]{
                        for snap in mySnap {
                            let id = snap.key
                            if let value = snap.value as? [String: Any]{
                                let name = value["name"] as? String
                                let iconImage = value["iconImage"] as? String
                                let transactionType =  myKey
                                let category = Category(id: id, name: name, transactionType: transactionType, iconImage: iconImage)
                                categories.append(category)
                            }
                        }
                    }
                }
                self.delegate?.responseDataCategory(cate: categories)
            }
        }
    }
    
//    func getListCategories(){
//        var categories = [Category]()
//        Defined.ref.child("Category").observeSingleEvent(of: .value) {[weak self] (snapshot) in
//            guard let `self` = self else {return}
//            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
//                //expense/income
//                for mySnap in snapshots {
//                    let myKey = (mySnap as AnyObject).key as String
//                    //key inside expense/income
//                    if let mySnap = mySnap.children.allObjects as? [DataSnapshot]{
//                        for snap in mySnap {
//                            let id = snap.key
//                            if let value = snap.value as? [String: Any]{
//                                let name = value["name"] as? String
//                                let iconImage = value["iconImage"] as? String
//                                let transactionType =  myKey
//                                let category = Category(id: id, name: name, transactionType: transactionType, iconImage: iconImage)
//                                categories.append(category)
//                            }
//                        }
//                    }
//                }
//                self.delegate?.responseDataCategory(cate: categories)
//            }
//        }
//    }
    func getTransactionByEvent(eid: String){
        var allTransactions = [Transaction]()
        Defined.ref.child("Account/userid1/transaction").observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let `self` = self else {
                return
            }
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for mySnap in snapshots {
                    let transactionType = (mySnap as AnyObject).key as String
                    if let snaps = mySnap.children.allObjects as? [DataSnapshot]{
                        for snap in snaps {
                            let id = snap.key
                            if let value = snap.value as? [String: Any]{
                                let amount = value["amount"] as! Int
                                let categoryid = value["categoryid"] as! String
                                let date = value["date"] as! String
                                var transaction = Transaction(id: id, transactionType: transactionType, amount: amount, categoryid: categoryid, date: date)
                                if let note = value["note"] as? String {
                                    transaction.note = note
                                }
                                if let eventid = value["eventid"] as? String {
                                    transaction.eventid = eventid
                                    if eventid == eid {
                                        allTransactions.append(transaction)
                                    }
                                }
                                
                            }
                        }
                    }
                }
                self.delegate?.responseDataTransactions(trans: allTransactions)
                
            }
        }
    }
}



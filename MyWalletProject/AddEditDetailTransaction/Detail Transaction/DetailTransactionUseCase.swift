//
//  DetailTransactionUseCase.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Firebase

protocol DetailTransactionUseCaseDelegate: class {
    func responseEvent(event: Event)
    func responseTrans(trans: Transaction)
    func responseCategory(cate: Category)
    func responseNoEvent()
}
class DetailTransactionUseCase{
    weak var delegate: DetailTransactionUseCaseDelegate?
}

extension DetailTransactionUseCase {
    func getEventInfo(eventid: String){
        var finalEvent: Event!
        if eventid != "" {
            Defined.ref.child(FirebasePath.event).observe(DataEventType.value) { (snapshot) in
                if snapshot.childrenCount > 0 {
                    for artist in snapshot.children.allObjects as! [DataSnapshot] {
                        let art = artist.value as? [String:AnyObject]
                        let id = artist.key
                        if id == eventid {
                            let name = art?["name"]
                            let date = art?["date"]
                            let image = art?["eventImage"]
                            let spent = art?["spent"]
                            let event = Event(id: id, name: name as? String, date: date as? String, eventImage: image as? String, spent: spent as? Int)
                            finalEvent = event
                            self.delegate?.responseEvent(event: finalEvent)
                            break
                        }
                    }
                    
                }
                
            }
        } else {
            delegate?.responseNoEvent()
        }
        
    }
    
    func deleteTransaction(t: Transaction){
        Defined.ref.child(FirebasePath.transaction).child("/\(t.transactionType!)/\(t.id!)").removeValue { (error, reference) in
            //remove old position
        }
    }
    
    func getTransaction(transid: String){Defined.ref.child(FirebasePath.transaction).observe(.value) {[weak self] (snapshot) in
            guard let `self` = self else {
                return
            }
            var allTransactions = [Transaction]()
            for case let snapshots as DataSnapshot in snapshot.children {
                for case let snapshot as DataSnapshot in snapshots.children {
                    guard let dict = snapshot.value as? [String: Any] else {return}
                    let id = snapshot.key
                    if id == transid {
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
                        }
                        self.delegate?.responseTrans(trans: transaction)
                        break
                    }
                }
            }
        }
    }
    
    func getCategory(cid: String){
        Defined.ref.child(FirebasePath.category).observe(.value) {[weak self] (snapshot) in
            guard let `self` = self else {return}
            var categories = [Category]()
            for case let snapshots as DataSnapshot in snapshot.children {
                for case let snapshot as DataSnapshot in snapshots.children {
                    guard let dict = snapshot.value as? [String:Any] else {
                        return
                    }
                    let id = snapshot.key
                    if id == cid {
                        let name = dict["name"] as? String
                        let iconImage = dict["iconImage"] as? String
                        let transactionType =  snapshots.key
                        let category = Category(id: id, name: name, transactionType: transactionType, iconImage: iconImage)
                        self.delegate?.responseCategory(cate: category)
                        break
                    }
                }
            }
        }
    }
}

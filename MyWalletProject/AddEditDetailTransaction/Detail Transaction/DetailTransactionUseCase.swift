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
            Defined.ref.child("Account").child("userid1").child("event").observe(DataEventType.value) { (snapshot) in
                if snapshot.childrenCount > 0 {
                    for artist in snapshot.children.allObjects as! [DataSnapshot] {
                        let art = artist.value as? [String:AnyObject]
                        let id = artist.key
                        if id == eventid {
                            print("my eventid: \(id)")
                            let name = art?["name"]
                            let date = art?["date"]
                            let image = art?["eventImage"]
                            let spent = art?["spent"]
                            let event = Event(id: id, name: name as? String, date: date as? String, eventImage: image as? String, spent: spent as? Int)
                            finalEvent = event
                            
                            break
                        }
                    }
                    self.delegate?.responseEvent(event: finalEvent)
                }
                
            }
        } else {
            delegate?.responseNoEvent()
        }
        
    }
    
    func deleteTransaction(t: Transaction){
        Defined.ref.child("Account/userid1/transaction/\(t.transactionType!)/\(t.id!)").removeValue { (error, reference) in
            //remove old position
        }
    }
    
    func getTransaction(transid: String){
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
                            //if id match
                            if id == transid {
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
                                    }
                                    
                                    self.delegate?.responseTrans(trans: transaction)
                                    break
                                    
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    func getCategory(cid: String){
        Defined.ref.child("Category").observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let `self` = self else {return}
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                //expense/income
                for mySnap in snapshots {
                    let myKey = (mySnap as AnyObject).key as String
                    //key inside expense/income
                    if let mySnap = mySnap.children.allObjects as? [DataSnapshot]{
                        for snap in mySnap {
                            let id = snap.key
                            if id == cid {
                                if let value = snap.value as? [String: Any]{
                                    let name = value["name"] as? String
                                    let iconImage = value["iconImage"] as? String
                                    let transactionType =  myKey
                                    let category = Category(id: id, name: name, transactionType: transactionType, iconImage: iconImage)
                                    self.delegate?.responseCategory(cate: category)
                                    break
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
}

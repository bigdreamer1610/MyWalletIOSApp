//
//  DetailEventUseCase.swift
//  MyWalletProject
//
//  Created by Van Thanh on 10/5/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Firebase

protocol DetailEventUseCaseDelegate: class {
    func marKedCompeleEvent(event: Event)
}

class DetailEventUseCase {
    weak var delegate: DetailEventUseCaseDelegate?
    var idUser = "userid1"
    var transactions = [Transaction]()
    
}
// remove
extension DetailEventUseCase {
    // Xoa event
    func deleteData(event : Event)  {
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
                                     if let eventid1 = value["eventid"] as? String {
                                         transaction.eventid = eventid1
                                        if eventid1 == event.id {
                                            Defined.ref.child("Account/userid1/transaction/\(transactionType)/\(id)/eventid").removeValue { (error, ref) in
                                                
                                            }
                        
                                        }
                                     }
                                 }
                             }
                         }
                     }
                 }
             }
             
        Defined.ref.child("Account").child(idUser).child("event").child(event.id!).removeValue()
    }
    // Danh dau da hoan tat
    func marKedCompele(event: Event)  {
        let event1 = [ "id":event.id,
                       "name": event.name ,
                       "date": event.date,
                       "eventImage": event.eventImage,
                       "spent": event.spent,
                       "status": "false"
            ]
            as [String : Any]
        var eventUpdate = Event(id: event.id, name: event.name , date: event.date, eventImage: event.eventImage, spent: event.spent, status: "false")
        Defined.ref.child("Account").child(idUser).child("event").child(event.id!).updateChildValues(event1,withCompletionBlock: { error , ref in
            if error == nil {
                self.delegate?.marKedCompeleEvent(event: eventUpdate)
            }else{
            }
        })
    }
    
    // Danh dau chưa hoan tat
    func incompleteMarkup(event: Event)  {
        let event1 = [ "id":event.id,
                       "name": event.name ,
                       "date": event.date,
                       "eventImage": event.eventImage,
                       "spent": event.spent,
                       "status": "true"
            ]
            as [String : Any]
        var eventUpdate = Event(id: event.id, name: event.name , date: event.date, eventImage: event.eventImage, spent: event.spent, status: "true")
        Defined.ref.child("Account").child(idUser).child("event").child(event.id!).updateChildValues(event1,withCompletionBlock: { error , ref in
            if error == nil {
            }else{
            }
        })
    }
    
    
}

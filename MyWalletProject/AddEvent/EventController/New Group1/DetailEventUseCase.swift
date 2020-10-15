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
    func resultEvent(event: Event)
}

class DetailEventUseCase {
    weak var delegate: DetailEventUseCaseDelegate?
    var idUser = "userid1"
    var transactions = [Transaction]()
    var detailEvent = Event()
    
}
// remove
extension DetailEventUseCase {
    // Xoa event
    func deleteData(event : Event)  {
        Defined.ref.child(Path.transaction.getPath()).observeSingleEvent(of: .value) {[weak self] (snapshot) in
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
        
        Defined.ref.child(Path.event.getPath()).child(event.id!).removeValue()
        Defined.defaults.set(false, forKey: "travelMode")
        Defined.defaults.removeObject(forKey: "eventTravelId")
        Defined.defaults.removeObject(forKey: "eventTravelImage")
        Defined.defaults.removeObject(forKey: "eventTravelName")
        
    }
    // Danh dau da hoan tat
    func marKedCompele(event: Event)  {
        let event1 = [ "id":event.id,
                       "name": event.name ,
                       "date": event.date,
                       "eventImage": event.eventImage,
                       "spent": 0,
                       "status": "false"
            ]
            as [String : Any]
        var eventUpdate = Event(id: event.id, name: event.name , date: event.date, eventImage: event.eventImage, spent: 0, status: "false")
        Defined.ref.child(Path.event.getPath()).child(event.id!).updateChildValues(event1,withCompletionBlock: { error , ref in
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
                       "spent": 0,
                       "status": "true"
            ]
            as [String : Any]
        var eventUpdate = Event(id: event.id, name: event.name , date: event.date, eventImage: event.eventImage, spent: 0, status: "true")
        Defined.ref.child(Path.event.getPath()).child(event.id!).updateChildValues(event1,withCompletionBlock: { error , ref in
            if error == nil {
            }else{
            }
        })
    }
    // Get data firebase
    func getData(event: Event)  {
        detailEvent = event
        detailEvent.spent! = 0
        Defined.ref.child("Account").child(self.idUser).child("transaction").observeSingleEvent(of: .value) { (snapshot1) in
            if let snapshots = snapshot1.children.allObjects as?[DataSnapshot]
            {
                for mySnap in snapshots {
                    let transactionType = (mySnap as AnyObject).key as String
                    if let snaps = mySnap.children.allObjects as? [DataSnapshot] {
                        for snap in snaps {
                            if let value = snap.value as? [String: Any]{
                                if value["eventid"] != nil {
                                    let eventid1 = value["eventid"] as! String
                                    let amount = value["amount"] as! Int
                                    if eventid1 == event.id! {
                                        self.detailEvent.spent! += amount
                                    }
                                } else {}
                            }
                        }
                    }
                }
                self.delegate?.resultEvent(event: self.detailEvent)
            }
            
        }
    }
    
}

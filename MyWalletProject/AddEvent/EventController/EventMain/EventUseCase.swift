//
//  EventUseCase.swift
//  MyWalletProject
//
//  Created by Van Thanh on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol EventUseCaseDelegate: class {
    func getData(arrEvent: [Event], arrNameEvent: [String])
}

class EventUseCase {
    weak var delegate: EventUseCaseDelegate?
    var idUser = "userid1"
    var checkDay = CheckDate()
    var dayThis = CheckDate().setDate()
    var arrEvent = [Event]()
    var arrNameEvent = [String]()
    
}
extension EventUseCase{
    
    // getdata firebase
    func getCurrenlyApplying1()  {
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        Defined.ref.child("Account").child(idUser).child("event").observe( .value, with: { snapshot in
            self.arrNameEvent.removeAll()
            self.arrEvent.removeAll()
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String: Any] else {
                    return
                }
                let dateEnd = dict["date"] as! String
                let status = dict["status"] as! String
                var check = self.checkDay.checkDate(dateEnd: dateEnd)
                if check && status == "true" {
                    let id = dict["id"] as! String
                    let img = dict["eventImage"] as! String
                    let nameEvent = dict["name"] as! String
                    let spent = dict["spent"] as! Int
                    var event1 = Event(id: id, name: nameEvent, date: dateEnd, eventImage: img, spent: spent, status: status)
                    //eventest = Event(id: id, name: nameEvent, date: dateEnd, eventImage: img, spent: spent, status: status)
                    // check id transaction
                    self.arrNameEvent.append(nameEvent)
                    self.arrEvent.append(event1)
                }
                else {
                    
                }
            }
        })
        dispatchGroup.leave()
        dispatchGroup.notify(queue: .main) {
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
                                        //  self.even.append(test(amout: amount, id: eventid1))
                                        for i in 0..<self.arrEvent.count{
                                            if eventid1 == self.arrEvent[i].id! {
                                                self.arrEvent[i].spent! += amount
                                            }
                                        }
                                    } else {}
                                    
                                }
                            }
                        }
                    }
                    self.delegate?.getData(arrEvent: self.arrEvent, arrNameEvent: self.arrNameEvent)
                }
            }
        }
    }
    // get data Finished
    func getEventFinished()  {
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        Defined.ref.child("Account").child(idUser).child("event").observe( .value, with: { snapshot in
            self.arrNameEvent.removeAll()
            self.arrEvent.removeAll()
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String: Any] else {
                    return
                }
                let dateEnd = dict["date"] as! String
                let status = dict["status"] as! String
                var check = self.checkDay.checkDate(dateEnd: dateEnd)
                if !check || status == "false" {
                    let id = dict["id"] as! String
                    let img = dict["eventImage"] as! String
                    let nameEvent = dict["name"] as! String
                    let spent = dict["spent"] as! Int
                    var event1 = Event(id: id, name: nameEvent, date: dateEnd, eventImage: img, spent: spent, status: status)
                    //eventest = Event(id: id, name: nameEvent, date: dateEnd, eventImage: img, spent: spent, status: status)
                    // check id transaction
                    self.arrNameEvent.append(nameEvent)
                    self.arrEvent.append(event1)
                }
                else {
                    
                }
            }
        })
        dispatchGroup.leave()
        dispatchGroup.notify(queue: .main) {
            Defined.ref.child("Account").child(self.idUser).child("transaction").observe(.value) { (snapshot1) in
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
                                        //  self.even.append(test(amout: amount, id: eventid1))
                                        for i in 0..<self.arrEvent.count{
                                            if eventid1 == self.arrEvent[i].id! {
                                                self.arrEvent[i].spent! += amount
                                            }
                                        }
                                    } else {
                                        
                                    }
                                    
                                }//
                            }
                        }
                    }
                    self.delegate?.getData(arrEvent: self.arrEvent, arrNameEvent: self.arrNameEvent)
                }
            }
        }
        
    }
    func refresh()  {
        Defined.ref.child("Account").child(idUser).child("event").queryOrderedByKey().queryEqual(toValue: "true", childKey: "status").queryLimited(toFirst: 4).observeSingleEvent(of: .value) { (snapshot) in
            guard let children = snapshot.children.allObjects.first as? DataSnapshot else {return}
            if snapshot.childrenCount > 0 {
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let dict = child.value as? [String: Any] else {
                        return
                    }
                    let dateEnd = dict["date"] as! String
                    let status = dict["status"] as! String
                    var check = self.checkDay.checkDate(dateEnd: dateEnd)
                    if check && status == "true" {
                        let id = dict["id"] as! String
                        let img = dict["eventImage"] as! String
                        let nameEvent = dict["name"] as! String
                        let spent = dict["spent"] as! Int
                        
                        var event1 = Event(id: id, name: nameEvent, date: dateEnd, eventImage: img, spent: spent, status: status)
                        print(event1)
                        self.arrNameEvent.append(nameEvent)
                        self.arrEvent.append(event1)
                        
                    }
                }
            }
                
            else
            {
                
            }
        }
        
    }
    
}

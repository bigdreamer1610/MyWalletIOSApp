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
    func getCurrenlyApplying()  {
        arrNameEvent.removeAll()
        arrEvent.removeAll()
        Defined.ref.child("Account").child(idUser).child("event").observeSingleEvent(of: .value, with: { snapshot in
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
                         self.arrNameEvent.append(nameEvent)
                         self.arrEvent.append(event1)
                     }
                     else {
                         
                     }
                 }
            self.delegate?.getData(arrEvent: self.arrEvent, arrNameEvent: self.arrNameEvent)
 
             })
    }
    // get data Finished
    func getEventFinished()  {
        arrNameEvent.removeAll()
        arrEvent.removeAll()
        Defined.ref.child("Account").child(idUser).child("event").observeSingleEvent(of: .value, with: { snapshot in
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
                         self.arrNameEvent.append(nameEvent)
                         self.arrEvent.append(event1)
                     }
                     else {
                     }
                 }
            self.delegate?.getData(arrEvent: self.arrEvent, arrNameEvent: self.arrNameEvent)
                })
    }
    
}


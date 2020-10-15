//
//  AddEventTableUseCase.swift
//  MyWalletProject
//
//  Created by Van Thanh on 10/5/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import FirebaseDatabase
protocol AddEventTableUseCaseDelegate: class {
    func editEvent(event: Event)
}

class AddEventTableUseCase  {
    var userID = "userid1"
    weak var delegate: AddEventTableUseCaseDelegate?
    var int = 1
    
    //add data
    func addData(event: Event , state: Int)  {
        
        if state == 0 {
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            // get child moi
            var  newChild = 1
            Defined.ref.child(Path.event.getPath()).queryLimited(toLast: 1).observeSingleEvent(of: .value, with: {
                snapshot in
                for category in snapshot.children{
                    if  snapshot.childrenCount == 0   {
                        self.int = 1
                        newChild = 1
                    } else{
                        newChild = Int((category as AnyObject).key)! + 1
                        self.int = newChild
                    }
                }
                dispatchGroup.leave()
            })
            
            // Mark: adđ
            dispatchGroup.notify(queue: .main) {
                let event1 = [ "id": String(newChild),
                               "name": event.name ,
                               "date": event.date,
                               "eventImage": event.eventImage,
                               "spent": 0,
                               "status": "true"]
                    as [String : Any]
                Defined.ref.child(Path.event.getPath()).child(String(newChild)).updateChildValues(event1,withCompletionBlock: { error , ref in
                    if error == nil {
                    }else{
                    }
                })
                
            }
        } else {
            let event1 = [ "id":event.id,
                           "name": event.name ,
                           "date": event.date,
                           "eventImage": event.eventImage,
                           "spent": 0,
                           "status": event.status]
                as [String : Any]
            var eventEDit = Event(id: event.id, name: event.name , date: event.date, eventImage: event.eventImage, spent: 0, status: event.status)
            Defined.ref.child(Path.event.getPath()).child(event.id!).updateChildValues(event1,withCompletionBlock: { error , ref in
                self.delegate?.editEvent(event: eventEDit)
//                if error == nil {
////                    self.delegate?.editEvent(event: eventEDit)
//                }else{
//                }
            })
            
        }
    }
    
    
}


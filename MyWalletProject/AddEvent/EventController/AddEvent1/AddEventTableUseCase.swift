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
    var int = 0
    
    //add data
    func addData(event: Event , state: Int)  {
        
        if state == 0 {
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            // get child moi
            var  newChild = 0
            Defined.ref.child("Account").child(userID).child("event").queryLimited(toLast: 1).observeSingleEvent(of: .value, with: {
                snapshot in
                for category in snapshot.children{
                    if  snapshot.childrenCount == 0   {
                        self.int = 0
                        newChild = 0
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
                               "status": "true"
                    ]
                    as [String : Any]
                Defined.ref.child("Account").child(self.userID).child("event").child(String(newChild)).updateChildValues(event1,withCompletionBlock: { error , ref in
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
                           "spent": event.spent,
                           "status": event.status
                ]
                as [String : Any]
            var eventEDit = Event(id: event.id, name: event.name , date: event.date, eventImage: event.eventImage, spent: event.spent, status: event.status)
            Defined.ref.child("Account").child(self.userID).child("event").child(event.id!).updateChildValues(event1,withCompletionBlock: { error , ref in
                if error == nil {
                    self.delegate?.editEvent(event: eventEDit)
                }else{
                }
            })
            
        }
    }
    
    
}

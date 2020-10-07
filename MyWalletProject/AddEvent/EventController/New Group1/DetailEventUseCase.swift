//
//  DetailEventUseCase.swift
//  MyWalletProject
//
//  Created by Van Thanh on 10/5/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

protocol DetailEventUseCaseDelegate: class {
    func marKedCompeleEvent(event: Event)
}

class DetailEventUseCase {
    weak var delegate: DetailEventUseCaseDelegate?
    var idUser = "userid1"
    
}
// remove
extension DetailEventUseCase {
    // Xoa event
    func deleteData(event : Event)  {
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

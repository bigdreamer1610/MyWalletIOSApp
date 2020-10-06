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
}
class DetailTransactionUseCase{
    weak var delegate: DetailTransactionUseCaseDelegate?
}

extension DetailTransactionUseCase {
    func getEventInfo(eventid: String){
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
                        self.delegate?.responseEvent(event: event)
                        break
                    }
                }
                
            }
            
        }
    }
}

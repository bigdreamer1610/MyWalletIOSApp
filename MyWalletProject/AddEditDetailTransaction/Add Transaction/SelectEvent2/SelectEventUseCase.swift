//
//  SelectEventUseCase.swift
//  MyWalletProject
//
//  Created by BAC Vuong Toan (VTI.Intern) on 9/29/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
import FirebaseDatabase

class SelectEventUseCase {
    var events = [Event]()
    func GetListEvent(){
        Defined.ref.child("Account").child("userid1").child("event").observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                //self.events.removeAll()
                for artist in snapshot.children.allObjects as! [DataSnapshot] {
                    let art = artist.value as? [String:AnyObject]
                    let id = artist.key
                    let artName = art?["name"]
                    let artDate = art?["date"]
                    let eventImage = art?["eventImage"]
                    let artSpent = art?["spent"]
                    let arts = Event(id: id, name: artName as? String, date: artDate as? String, eventImage: eventImage as? String, spent: artSpent as? Int)
                    self.events.append(arts)
                }
               // self.tableview.reloadData()
               
            }
        }
    }
}

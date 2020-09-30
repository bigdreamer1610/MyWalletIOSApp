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
                    let artName = art?["name"]
                    let artGoal = art?["goal"]
                    let artDateStart = art?["dateStart"]
                    let artDateEnd = art?["dateEnd"]
                    let artCategory = art?["categoryid"]
                    let artSpent = art?["spent"]
                    let arts = Event(name: artName as? String, goal: artGoal as? Int, dateStart: artDateStart as? String, dateEnd: artDateEnd as? String, category: artCategory as? String)
                    self.events.append(arts)
                }
               // self.tableview.reloadData()
               
            }
        }
    }
}

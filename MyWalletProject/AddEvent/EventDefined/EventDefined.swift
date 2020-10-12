//
//  EventDefined.swift
//  MyWalletProject
//
//  Created by Van Thanh on 10/5/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EventDefined {
    let ref = Database.database().reference()
    func alert(state: Int) -> UIAlertController{
        var alert = UIAlertController()
        if state == 0 {
             alert = UIAlertController(title: "Error", message: "Please enter fully", preferredStyle: UIAlertController.Style.actionSheet)
        } else if state == 3{
             alert = UIAlertController(title: "Error", message: "The event cannot be a date in the past", preferredStyle: UIAlertController.Style.actionSheet)
        } else if state == 4 {
           alert = UIAlertController(title: "Error", message: "This event already exists", preferredStyle: UIAlertController.Style.actionSheet)
                          alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        }
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
    func alert1()  -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: "Please enter fully", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
     return alert
    }
    
    func checkTimer() {
        
    }
    
}



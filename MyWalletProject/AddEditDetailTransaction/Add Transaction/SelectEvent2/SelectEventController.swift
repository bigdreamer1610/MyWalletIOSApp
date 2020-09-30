//
//  SelectEventController.swift
//  MyWallet
//
//  Created by BAC Vuong Toan (VTI.Intern) on 9/25/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseAnalytics

protocol SelectEvent {
    func setEvent(nameEvent:String)
}

class SelectEventController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var cellId = "SelectEventCell"
    var events = [Event]()
    var delegate:SelectEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier:cellId)
        GetListEvent()
    }
    /*
     static let amount = "amount"
     static let categoryid = "categoryid"
     static let date = "date"
     static let note = "note"
     static let detailsTransaction = "ViewTransaction"
     
     // Event
     static let categoryIdEvent = "categoryid"
     static let nameEvent = "name"
     static let dateEndEvent = "dateEnd"
     static let dateStartEvent = "dateStart"
     static let goalEvent = "goal"
     static let spentEvent = "spent"
     */
    func GetListEvent(){
        Defined.ref.child("Account").child("userid1").child("event").observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.events.removeAll()
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
                self.tableView.reloadData()
            }
        }
    }
}

extension SelectEventController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SelectEventCell
        cell.setUp(data: events[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name:Constant.detailsTransaction, bundle: nil).instantiateViewController(withIdentifier: "add") as? AddTransactionController
        let ex = events[indexPath.row]
        delegate?.setEvent(nameEvent: ex.name ?? "" )
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

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
    func setEvent(nameEvent:String, imageEvent:String)
}

class SelectEventController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var cellId = "SelectEventCell"
    
    var events = [Event]()
    var delegate:SelectEvent?
    var presenter: SelectEventPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.responseDataEvent()
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier:cellId)
    }
    func setUp(presenter: SelectEventPresenter) -> <#return type#> {
        <#function body#>
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
        delegate?.setEvent(nameEvent: ex.name ?? "", imageEvent: ex.eventImage ?? "" )
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

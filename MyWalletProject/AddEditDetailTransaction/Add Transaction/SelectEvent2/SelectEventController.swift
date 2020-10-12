//
//  SelectEventController.swift
//  MyWallet
//
//  Created by BAC Vuong Toan (VTI.Intern) on 9/25/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Firebase

protocol SelectEvent {
    func setEvent(nameEvent:String, imageEvent:String, eventid: String)
}

class SelectEventController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var events = [Event]()
    var delegate:SelectEvent?
    var presenter: SelectEventPresenter?
    
    var language = ChangeLanguage.vietnam.rawValue
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        initData()
        setLanguage()
    }
    
    func setLanguage(){
        navigationItem.title = SelectEventDataString.event.rawValue.addLocalizableString(str: language)
        
    }
    
    func initData(){
        presenter?.responseDataEvent()
        tableView.reloadData()
    }
    
    func initComponents(){
        SelectEventCell.registerCellByNib(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setUp(presenter: SelectEventPresenter) {
        self.presenter = presenter
    }
    
}
extension SelectEventController: SelectEventPresenterDelegate{
    func getDataOfEvent(data: [Event]) {
        self.events = data
        self.tableView.reloadData()
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
}

extension SelectEventController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SelectEventCell.loadCell(tableView) as! SelectEventCell
        cell.setUp(data: events[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = RouterType.add.getVc() as! AddTransactionViewController
        let ex = events[indexPath.row]
        delegate?.setEvent(nameEvent: ex.name ?? "", imageEvent: ex.eventImage ?? "", eventid: ex.id ?? "")
        self.navigationController?.popViewController(animated: true)
    }
}

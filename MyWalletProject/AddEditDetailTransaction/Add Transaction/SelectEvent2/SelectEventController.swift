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
    @IBOutlet var centerLabel: UILabel!
    @IBOutlet var centerIcon: UIImageView!
    var events = [Event]()
    var delegate:SelectEvent?
    var presenter: SelectEventPresenter?
    
    var language = ChangeLanguage.english.rawValue
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        initData()
        setLanguage()
        noEvent(status: true)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
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
    
    func noEvent(status: Bool){
        centerIcon.isHidden = status
        centerLabel.isHidden = status
    }
    
}
extension SelectEventController: SelectEventPresenterDelegate{
    func getDataOfEvent(data: [Event]) {
        self.events = data
        if self.events.count == 0 {
            noEvent(status: false)
        } else {
            noEvent(status: true)
        }
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

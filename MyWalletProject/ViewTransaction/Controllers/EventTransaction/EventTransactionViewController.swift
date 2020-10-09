//
//  EventTransactionViewController.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/7/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class EventTransactionViewController: UIViewController {

    var presenter: EventTransactionPresenter?
    
    @IBOutlet var detailTableView: UITableView!
    @IBOutlet var lbNoTransaction: UILabel!
    
    var allTransactionss = [Transaction]()
    var transactionSections = [TransactionSection]()
    var event: Event!
    var amount: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        lbNoTransaction.isHidden = true
        detailTableView.isHidden = true
        initData()
        initComponents()

        // Do any additional setup after loading the view.
    }
    
    func setUp(presenter: EventTransactionPresenter){
        self.presenter = presenter
    }
    
    func setUpData(event: Event){
        self.event = event
    }
    
    func initData(){
        presenter?.setUpEvent(e: event)
        presenter?.fetchCategories()
        presenter?.fetchDataTransactions(eid: event.id!)
    }
    
    func fetchData(trans: [Transaction]){
        presenter?.fetchData(trans: trans)
    }
    
    func initComponents(){
        OverviewCell.registerCellByNib(detailTableView)
        TransactionCell.registerCellByNib(detailTableView)
        HeaderTransactionCell.registerCellByNib(detailTableView)
        detailTableView.dataSource = self
        detailTableView.delegate = self
    }
    

}
extension EventTransactionViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number = 1
        if section != 0 {
            number = transactionSections[section-1].items.count
        }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var myCell = UITableViewCell()
        if indexPath.section == 0 {
            let cell = OverviewCell.loadCell(tableView) as! OverviewCell
            //cell.setUpData(transactionType: budget.transactionType!, amount: amount)
            cell.setUpData(eventName: event.name!, amount: amount)
            myCell.selectionStyle = .none
            myCell = cell
        } else {
            let cell = TransactionCell.loadCell(tableView) as! TransactionCell
            cell.setUpData(data: transactionSections[indexPath.section-1].items[indexPath.row])
            myCell = cell
        }
        
        return myCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionSections.count + 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let transVc = RouterType.transactionDetail(item: transactionSections[indexPath.section - 1].items[indexPath.row], header: transactionSections[indexPath.section - 1].header).getVc()
            self.navigationController?.pushViewController(transVc, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var myView = UIView()
        if section != 0 {
            let cell = HeaderTransactionCell.loadCell(tableView) as! HeaderTransactionCell
            cell.setUpData(data: transactionSections[section-1].header)
            myView = cell
        }
        return myView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
        myView.backgroundColor = UIColor.groupTableViewBackground
        return myView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return Constants.transactionHeader
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return Constants.overviewCell
        } else {
            return Constants.transactionRow
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
}
extension EventTransactionViewController : EventTransactionPresenterDelegate {
    func reloadData() {
        self.detailTableView.reloadData()
    }
    
    func getTransactionSection(section: [TransactionSection]) {
        self.transactionSections = section
        if section.count == 0 {
            lbNoTransaction.isHidden = false
            detailTableView.isHidden = true
        } else {
            lbNoTransaction.isHidden = true
            detailTableView.isHidden = false
        }
        self.detailTableView.reloadData()
    }
    
    func getTotal(total: Int) {
        self.amount = total
        self.detailTableView.reloadData()
        print(total)
    }
    
    func getAllTransactions(trans: [Transaction]) {
        self.allTransactionss = trans
        fetchData(trans: trans)
    }
    
    
}

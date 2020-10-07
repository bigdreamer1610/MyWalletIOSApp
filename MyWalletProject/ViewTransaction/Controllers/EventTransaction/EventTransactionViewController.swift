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
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
    }
    
    func initComponents(){
        
    }
    

}

extension EventTransactionViewController : EventTransactionPresenterDelegate {
    func reloadData() {
        self.detailTableView.reloadData()
    }
    
    func getTransactionSection(section: [TransactionSection]) {
        self.transactionSections = section
    }
    
    func getTotal(total: Int) {
        print(total)
    }
    
    func getAllTransactions(trans: [Transaction]) {
        self.allTransactionss = trans
    }
    
    
}

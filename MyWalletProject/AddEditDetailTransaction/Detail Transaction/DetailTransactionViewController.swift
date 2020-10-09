//
//  DetailTransactionViewController.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class DetailTransactionViewController: UIViewController {

    @IBOutlet var imageEvent: UIImageView!
    @IBOutlet var lbEventName: UILabel!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblEvent: UILabel!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var lbNote: UILabel!
    @IBOutlet var eventView: UIView!
    
    var presenter: DetailTransactionPresenter?
    var transactions = [Transaction]()
    var transactionid: String = ""
    var categoryName:String = ""
    var categoryNote: String = ""
    var categoryDate:String = ""
    var eventName: String = ""
    var type: String = ""
    var amount: Int = 0
    var icon: String = ""
    var dateModel: DateModel!
    
    var event: Event?
    var transaction: Transaction!
    var eventid: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        customizeLayout()
        Defined.formatter.groupingSeparator = "."
        Defined.formatter.numberStyle = .decimal
        initData()
        // Do any additional setup after loading the view.
    }
    
    func setUp(presenter: DetailTransactionPresenter){
        self.presenter = presenter
    }
    
    func customizeLayout(){
        btnDelete.layer.cornerRadius = 6
        if eventid != nil && eventid != "" {
            eventView.isHidden = false
            lbTitle.isHidden = false
        } else {
            lbTitle.isHidden = true
            eventView.isHidden = true
        }
    }
    
    func initData(){
        lblDate.text = categoryDate
        lbNote.text = categoryNote
        lblCategory.text = categoryName
        lblEvent.text = eventName
        lblAmount.text = Defined.formatter.string(from: NSNumber(value: amount))!
        iconImage.image = UIImage(named: icon)
    }
    
    func initComponents(){
        
    }
    
    func fetchTransaction(id: String){
        presenter?.fetchTransaction(id: id)
    }
    
    func setUpDataTransactionView(item: TransactionItem, header: TransactionHeader){
        //presenter?.fetchTransaction(id: item.id)
        transactionid = item.id
        type = item.type
        categoryName = item.categoryName
        categoryNote = item.note ?? ""
        amount = item.amount
        icon = item.iconImage
        dateModel = header.dateModel
        categoryDate = "\(dateModel.weekDay), \(dateModel.date) \(dateModel.month) \(dateModel.year)"
        if let eventid = item.eventid {
            self.eventid = eventid
            print("a1: \(eventid)")
            presenter?.getInfo(id: eventid)
        }
        
    }
    
    func setUpDataCategoryView(item: CategoryItem, header: CategoryHeader){
        //presenter?.fetchTransaction(id: item.id)
        transactionid = item.id
        type = item.type
        categoryName = header.categoryName
        categoryNote = item.note ?? ""
        amount = item.amount
        icon = header.icon
        dateModel = item.dateModel
        categoryDate = "\(dateModel.weekDay), \(dateModel.date) \(dateModel.month) \(dateModel.year)"
        if let eventid = item.eventid {
            self.eventid = eventid
            print("a2: \(eventid)")
            presenter?.getInfo(id: eventid)
        }
        
    }
    // mark: - event nil
    @IBAction func btnEditTransaction(_ sender: Any) {
        AppRouter.routerTo(from: self, router: .edit(trans: self.transaction, event: self.event ?? Event(), cateName: self.categoryName, cateImage: self.icon), options: .push)
    }
    
    
    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDelateTransaction(_ sender: Any) {
        let alert = UIAlertController(title: "Delete transaction", message: "Are you sure to delete this transaction?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.presenter?.deleteTransaction(t: self.transaction)
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
        
    }
    

}

extension DetailTransactionViewController : DetailTransactionPresenterDelegate {
    func getEvent(event: Event) {
        self.event = event
        lbEventName.text = event.name
        imageEvent.image = UIImage(named: event.eventImage!)
    }
    
    func getTransaction(transaction: Transaction) {
        self.transaction = transaction
    }
    
}

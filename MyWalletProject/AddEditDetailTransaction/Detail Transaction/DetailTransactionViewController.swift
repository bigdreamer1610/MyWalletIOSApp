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
    
    var event: Event!
    var eventid: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func setUpDataTransactionView(item: TransactionItem, header: TransactionHeader){
        transactionid = item.id
        type = item.type
        categoryName = item.categoryName
        categoryNote = item.note ?? ""
        amount = item.amount
        icon = item.iconImage
        if let eventid = item.eventid {
            self.eventid = eventid
            print("a1: \(eventid)")
            presenter?.getInfo(id: eventid)
        }
        if let event = event {
            lbEventName.text = event.name
            imageEvent.image = UIImage(named: event.eventImage!)
        }
        dateModel = header.dateModel
        //eventName = item.ev
        categoryDate = "\(dateModel.weekDay), \(dateModel.date) \(dateModel.month) \(dateModel.year)"
    }
    
    func setUpDataCategoryView(item: CategoryItem, header: CategoryHeader){
        transactionid = item.id
        type = item.type
        categoryName = header.categoryName
        categoryNote = item.note ?? ""
        amount = item.amount
        icon = header.icon
        dateModel = item.dateModel
        if let eventid = item.eventid {
            self.eventid = eventid
            print("a2: \(eventid)")
            presenter?.getInfo(id: eventid)
        }
        if let event = event {
            lbEventName.text = event.name
            imageEvent.image = UIImage(named: event.eventImage!)
        }
        categoryDate = "\(dateModel.weekDay), \(dateModel.date) \(dateModel.month) \(dateModel.year)"
    }
    
    @IBAction func btnEditTransaction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "edit") as? EditTransactionController
        vc?.setUpData(type: type, transactionId: transactionid, name: categoryName, note: categoryNote, amount: amount, icon: icon, dateModel: dateModel)
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func btnDelateTransaction(_ sender: Any) {
        let alert = UIAlertController(title: "Delete transaction", message: "Are you sure to delete this transaction?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            Defined.ref.child("Account/userid1/transaction/\(self.type)/\(self.transactionid)").removeValue { (error, reference) in
                if error != nil {
                    print("Error: \(error!)")
                } else {
                    print(reference)
                    print("Remove successfully")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }))
        self.present(alert, animated: true)
        
    }
    

}

extension DetailTransactionViewController : DetailTransactionPresenterDelegate {
    func getEvent(event: Event) {
        self.event = event
        eventid = event.id
        print("my event: \(event)")
        lbEventName.text = event.name
        imageEvent.image = UIImage(named: event.eventImage!)
    }
    
    
}

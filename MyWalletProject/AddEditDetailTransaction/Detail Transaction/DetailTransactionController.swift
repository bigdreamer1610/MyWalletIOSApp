//
//  DetailTransactionController.swift
//  MyWallet
//
//  Created by BAC Vuong Toan (VTI.Intern) on 9/21/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class DetailTransactionController: UIViewController {
    
    
    @IBOutlet var imageEvent: UIImageView!
    
    @IBOutlet var lbEventName: UILabel!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblEvent: UILabel!
    //@IBOutlet weak var iconEvent: UIImageView!
    
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var lbNote: UILabel!
    private var formatter = NumberFormatter()
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
    @IBOutlet var eventView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.3929189782, green: 0.4198221317, blue: 0.8705882353, alpha: 1)
        customizeLayout()
        lblDate.text = categoryDate
        lbNote.text = categoryNote
        lblCategory.text = categoryName
        lblEvent.text = eventName
        lblAmount.text = formatter.string(from: NSNumber(value: amount))!
        iconImage.image = UIImage(named: icon)
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
    }
    
    func customizeLayout(){
        print("eventid: \(eventid!)")
        btnDelete.layer.cornerRadius = 6
        if eventid != nil && eventid != "" {
            eventView.isHidden = false
            lbTitle.isHidden = false
        } else {
            lbTitle.isHidden = true
            eventView.isHidden = true
        }
        
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
            getEventInfo()
            
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
            getEventInfo()
        }
        if let event = event {
                   lbEventName.text = event.name
                   imageEvent.image = UIImage(named: event.eventImage!)
               }
        categoryDate = "\(dateModel.weekDay), \(dateModel.date) \(dateModel.month) \(dateModel.year)"
    }
    
    func getEventInfo() {
        Defined.ref.child("Account").child("userid1").child("event").observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                for artist in snapshot.children.allObjects as! [DataSnapshot] {
                    let art = artist.value as? [String:AnyObject]
                    let id = artist.key
                    
                    if id == self.eventid {
                        print("my eventid: \(id)")
                        let artName = art?["name"]
                        let artDate = art?["date"]
                        let eventImage = art?["eventImage"]
                        let artSpent = art?["spent"]
                        let arts = Event(id: id, name: artName as? String, date: artDate as? String, eventImage: eventImage as? String, spent: artSpent as? Int)
                        self.event = arts
                        print("event image: \(eventImage!)")
                        self.lbEventName.text = artName as! String
                        self.imageEvent.image = UIImage(named: eventImage as! String)
                        break
                    }
                }
                
            }
           
        }
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

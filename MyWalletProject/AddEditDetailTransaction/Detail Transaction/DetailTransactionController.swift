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
    
    
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblEvent: UILabel!
    @IBOutlet weak var iconEvent: UIImageView!
    
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
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeLayout()
        lblDate.text = categoryDate
        lbNote.text = categoryNote
        lblCategory.text = categoryName
        lblEvent.text = eventName
        lblAmount.text = formatter.string(from: NSNumber(value: amount))!
        iconImage.image = UIImage(named: icon)
        iconEvent.image = UIImage(named: eventName)
        
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
    }
    
    func customizeLayout(){
        btnDelete.layer.cornerRadius = 6
    }
    
    func setUpDataTransactionView(item: TransactionItem, header: TransactionHeader){
        transactionid = item.id
        type = item.type
        categoryName = item.categoryName
        categoryNote = item.note ?? ""
        amount = item.amount
        icon = item.iconImage
        dateModel = header.dateModel
        eventName = item.eventName ?? ""
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
            MyDatabase.ref.child("Account/userid1/transaction/\(self.type)/\(self.transactionid)").removeValue { (error, reference) in
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

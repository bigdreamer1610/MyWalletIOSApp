//
//  EditTransactionController.swift
//  MyWallet
//
//  Created by BAC Vuong Toan (VTI.Intern) on 9/21/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class EditTransactionController: UIViewController, UITextFieldDelegate {
    
    var eventid: String? = nil
    var categoryName: String = ""
    var categoryId: String? = nil
    var amount: Int = 0
    var icon: String = ""
    var thisDate = Date()
    var timer = Timer()
    var runAnimation = true
    private let dateFormatter = DateFormatter()
    
    @IBOutlet var btnSave: UIBarButtonItem!
    @IBOutlet weak var iconEvent: UIImageView!
    @IBOutlet var btnCancel: UIBarButtonItem!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var txtNote: UITextField!
    @IBOutlet weak var txtEvent: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet var txtCategory: UITextField!
    @IBOutlet var txtAmount: UITextField!
    
    @IBOutlet var btnTrash: UIButton!
    
    var transaction: Transaction?
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Defined.formatter.groupingSeparator = "."
        Defined.formatter.numberStyle = .decimal
        
        initComponents()
        customizeLayout()
        txtAmount.delegate = self
        addEvent()
        scheduledTimerWithTimeInterval()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func setUpData(trans: Transaction, event: Event?, categoryName: String, categoryImage: String){
        self.transaction = trans
        self.categoryId = trans.categoryid
        self.event = event
        self.eventid = event?.id
        self.categoryName = categoryName
        self.icon = categoryImage
    }
    
    
    func initComponents(){
        txtCategory.text = categoryName
        txtNote.text = transaction?.note!
        txtAmount.text = "\(transaction?.amount ?? 0)"
        iconImage.image = UIImage(named: icon)
        txtDate.text = transaction?.date!
        txtEvent.text = event?.name ?? nil
        iconEvent.image = UIImage(named: event?.eventImage ?? "others")
        categoryId = transaction?.categoryid
    }
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    // add event txtDate,txtCategory
    func addEvent()  {
        txtCategory.addTarget(self, action: #selector(myCategory), for: .touchDown)
        txtDate.addTarget(self, action: #selector(myDate), for: .touchDown)
        txtEvent.addTarget(self, action: #selector(myEvent), for: .touchDown)
    }
    
    @objc func myCategory(textField: UITextField) {
        let vc = UIStoryboard.init(name: Constants.detailsTransaction, bundle: nil).instantiateViewController(withIdentifier: "selectCategory") as? SelectCategoryController
        vc?.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func myDate(textField: UITextField) {
        let vc = UIStoryboard.init(name: Constants.detailsTransaction, bundle: nil).instantiateViewController(withIdentifier: "customDate") as? CustomDateController
        vc?.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func myEvent(textField: UITextField) {
        let vc = RouterType.selectEvent.getVc() as! SelectEventController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func customizeLayout(){
        txtCategory.setRightImage(imageName: "arrowright")
        txtEvent.setRightImage(imageName: "arrowright")
        txtDate.setRightImage(imageName: "arrowright")
    }
    
    @IBAction func clickCancel(_ sender: Any) {
        timer.invalidate()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func clickSave(_ sender: Any) {
        timer.invalidate()
        print("stop time")
        if let strAmount = txtAmount.text,
            let intAmount = Int(strAmount){
            amount = intAmount
            if amount <= 0{
                let alert = UIAlertController(title: "Notification", message: "Amount of money cannot be 0", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        
        let trans = Transaction(id: transaction?.id ?? "", transactionType: transaction?.transactionType ?? "", amount: amount, categoryid: categoryId , date: txtDate.text!, note: txtNote.text!, eventid: eventid ?? "")
        let update = [
            "note":txtNote.text! ,
            "date":txtDate.text!,
            "categoryid": txtCategory.text!,
            "amount": amount,
            "eventid": eventid ?? ""
            ] as [String : Any]
        Defined.ref.child("Account/userid1/transaction/\(transaction?.transactionType ?? "")/\(transaction?.id ?? "")").updateChildValues(update) { (error, reference) in
            if error != nil {
                print("Error: \(error!)")
            } else {
                print(reference)
                print("Remove successfully")
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    
    @IBAction func clickTrash(_ sender: Any) {
        resetEvent()
    }
    
    func resetEvent(){
        eventid?.removeAll()
        txtEvent.text = ""
        iconEvent.image = UIImage(named: "others")
    }
    func scheduledTimerWithTimeInterval(){
        if !runAnimation { return }
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    @objc func updateCounting(){
        var checkAmount = Int(txtAmount.text!)
        
        if checkAmount == 0 || txtCategory.text!.isEmpty || txtDate.text!.isEmpty{
            btnSave.isEnabled = false
        }else{
            btnSave.isEnabled = true
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowCharacters = "0123456789"
        let allowCharacterSet = CharacterSet(charactersIn: allowCharacters)
        let typeCharacterSet = CharacterSet(charactersIn: string)
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if !text.isEmpty {
            btnSave.isEnabled = true
        } else {
            btnSave.isEnabled = false
        }
        if textField == txtAmount{
            return allowCharacterSet.isSuperset(of: typeCharacterSet)
        }
        return true
    }
}

extension EditTransactionController: SelectCategory, SelectDate, SelectEvent{
    func setEvent(nameEvent: String, imageEvent: String, eventid: String) {
        txtEvent.text = nameEvent
        iconEvent.image = UIImage(named: imageEvent)
        self.eventid = eventid
    }
    
    func setDate(date: String) {
        txtDate.text = date
    }
    
    func setCategory(nameCategory: String, iconCategory: String, type: String, id: String) {
        txtCategory.text = nameCategory
        iconImage.image = UIImage(named: iconCategory)
        categoryId = id
        
    }
    
    
}

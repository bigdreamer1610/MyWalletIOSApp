//
//  AddTrasactionController.swift
//  MyWallet
//
//  Created by BAC Vuong Toan (VTI.Intern) on 9/21/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddTransactionController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var tfNote: UITextField!
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var tfCategory: UITextField!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var tfEvent: UITextField!
    @IBOutlet weak var iconEvent: UIImageView!
    @IBOutlet weak var viewShowMore: UIView!
    
    @IBOutlet var btnCancel: UIBarButtonItem!
    @IBOutlet var btnSave: UIBarButtonItem!
    var nameCategory: String = ""
    var iconImages: String = ""
    var date: String = ""
    var amount: Int = 0
    var id: String = ""
    var type: String = ""
    var thisDate = Date()
    private let dateFormatter = DateFormatter()
    override func viewDidLoad() {
        viewShowMore.alpha = 0
        super.viewDidLoad()
        dateFormatter.locale = Locale(identifier: "vi_VN")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        tfCategory.text = nameCategory
        iconImage.image = UIImage(named: iconImages)
        tfDate.text = date
        addEvent()
        tfDate.delegate = self
        tfAmount.delegate = self
        tfCategory.delegate = self
        tfNote.delegate = self
        btnSave.isEnabled = false
        
    }
    
    func addEvent()  {
        tfCategory.addTarget(self, action: #selector(myEvent), for: .touchDown)
        tfDate.addTarget(self, action: #selector(myDate), for: .touchDown)
        tfEvent.addTarget(self, action: #selector(myEven), for: .touchDown)
    }
    
    @objc func myEvent(textField: UITextField) {
        let vc = UIStoryboard.init(name: Constant.detailsTransaction, bundle: nil).instantiateViewController(withIdentifier: "selectCategory") as? SelectCategoryController
        vc?.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func myDate(textField: UITextField) {
        let vc = UIStoryboard.init(name: Constant.detailsTransaction, bundle: nil).instantiateViewController(withIdentifier: "customDate") as? CustomDateController
        if tfDate.text != "" {
            thisDate = dateFormatter.date(from: tfDate.text!)!
        }
        vc?.customDate = thisDate
        vc?.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    @objc func myEven(textField:UITextField){
           let vc = UIStoryboard.init(name: Constant.detailsTransaction, bundle: nil).instantiateViewController(withIdentifier: "selectEvent") as? SelectEventController
           vc?.delegate = self
           self.navigationController?.pushViewController(vc!, animated: true)
       }
    
    
    @IBAction func clickCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func btnSave(_ sender: Any) {
        if let strAmount = tfAmount.text,
            let intAmount = Int(strAmount){
            amount = intAmount
            if amount <= 0{
                let alert = UIAlertController(title: "Notification", message: "Amount of money cannot be 0", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        let writeData: [String: Any] = [
            "date": tfDate.text!,
            "note": tfNote.text!,
            "amount" :amount,
            "categoryid": id,
            "event":tfEvent.text!]
        MyDatabase.ref.child("Account/userid1/transaction/\(type)").childByAutoId().setValue(writeData)
        let alert = UIAlertController(title: "Notification", message: "Add a new transaction successfully", preferredStyle: .alert)
        //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnAddMoreDetails(_ sender: Any) {
        viewShowMore.alpha = 1
    }
    
    @IBAction func btnDeleteMoreDetails(_ sender: Any) {
        tfEvent.text = ""
        iconEvent.image = UIImage(named: "others")
    }
    //TODO: - Fix only enable button all textfields except tfNote is not empty
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
        if textField == tfAmount {
            return allowCharacterSet.isSuperset(of: typeCharacterSet)
        }
        return true
    }
}

extension AddTransactionController: SelectCategory, SelectDate, SelectEvent{
    func setEvent(nameEvent: String) {
        tfEvent.text = nameEvent
        iconEvent.image = UIImage(named: nameEvent)
    }
    func setDate(date: String) {
        tfDate.text = date
    }
    
    func setCategory(nameCategory: String, iconCategory: String, type: String, id: String) {
        self.id = id
        self.type = type
        tfCategory.text = nameCategory
        iconImage.image = UIImage(named: iconCategory)
    }
}


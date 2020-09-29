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
    
    var note:String? = ""
    var date:String = ""
    var categoryName: String = ""
    var transactionId: String = ""
    var type: String = ""
    var amount: Int = 0
    var icon: String = ""
    var dateModel: DateModel!
    @IBOutlet var btnSave: UIBarButtonItem!
    //@IBOutlet weak var txtNote: UITextView!
    
    @IBOutlet var btnCancel: UIBarButtonItem!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var txtNote: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    
    @IBOutlet var txtCategory: UITextField!
    @IBOutlet var txtAmount: UITextField!
    let datePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        ShowDatePicker()
        txtAmount.delegate = self
    }
    
    
    func configure(){
        txtCategory.text = categoryName
        txtNote.text = note
        txtAmount.text = "\(amount)"
        txtDate.text = "\(dateModel.date)/\(dateModel.month)/\(dateModel.year)"
        iconImage.image = UIImage(named: icon)
    }
    func setUpData(type: String, transactionId: String, name: String,
                   note: String?,amount: Int,icon: String, dateModel: DateModel){
        self.type = type
        self.transactionId = transactionId
        self.categoryName = name
        self.note = note
        self.amount = amount
        self.icon = icon
        self.dateModel = dateModel
        
    }
    
    
    @IBAction func clickCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func clickSave(_ sender: Any) {
        if let strAmount = txtAmount.text,
            let intAmount = Int(strAmount){
            amount = intAmount
        }
        let update = [
            "note":txtNote.text! ,
            "date":txtDate.text!,
            "categoryid": txtCategory.text!,
            "amount": amount
            ] as [String : Any]
        MyDatabase.ref.child("Account/userid1/transaction/\(self.type)/\(self.transactionId)").updateChildValues(update) { (error, reference) in
            if error != nil {
                print("Error: \(error!)")
            } else {
                print(reference)
                print("Remove successfully")
                self.navigationController?.popToRootViewController(animated: true)
            
            }
        }
        
    }
    
    func ShowDatePicker(){
        //formate date
        datePicker.datePickerMode = .date
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([btnDone,spaceButton,cancelButton], animated: false)
        
        txtDate.inputAccessoryView = toolbar
        txtDate.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
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
        if textField == txtAmount {
            return allowCharacterSet.isSuperset(of: typeCharacterSet)
        }
        return true
    }
    
}

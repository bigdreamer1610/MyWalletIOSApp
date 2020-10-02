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
    var thisDate = Date()
    private let dateFormatter = DateFormatter()
    
    @IBOutlet var btnSave: UIBarButtonItem!
    
    @IBOutlet var btnCancel: UIBarButtonItem!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var txtNote: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    
    @IBOutlet var tfEvent: UITextField!
    @IBOutlet var txtCategory: UITextField!
    @IBOutlet var txtAmount: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        customizeLayout()
        txtAmount.delegate = self
        addEvent()
    }
    
    // add event txtDate,txtCategory
    func addEvent()  {
        txtCategory.addTarget(self, action: #selector(myCategory), for: .touchDown)
        txtDate.addTarget(self, action: #selector(myDate), for: .touchDown)
    }
    
    @objc func myCategory(textField: UITextField) {
        let vc = UIStoryboard.init(name: Constant.detailsTransaction, bundle: nil).instantiateViewController(withIdentifier: "selectCategory") as? SelectCategoryController
        vc?.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func myDate(textField: UITextField) {
        let vc = UIStoryboard.init(name: Constant.detailsTransaction, bundle: nil).instantiateViewController(withIdentifier: "customDate") as? CustomDateController
        vc?.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func customizeLayout(){
        txtCategory.setRightImage(imageName: "arrowright")
        tfEvent.setRightImage(imageName: "arrowright")
        txtDate.setRightImage(imageName: "arrowright")
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
                  if amount <= 0{
                      let alert = UIAlertController(title: "Notification", message: "Amount of money cannot be 0", preferredStyle: .alert)
                      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                      self.present(alert, animated: true, completion: nil)
                      return
                  }
              }
        let update = [
            "note":txtNote.text! ,
            "date":txtDate.text!,
            "categoryid": txtCategory.text!,
            "amount": amount
            ] as [String : Any]
        Defined.ref.child("Account/userid1/transaction/\(self.type)/\(self.transactionId)").updateChildValues(update) { (error, reference) in
            if error != nil {
                print("Error: \(error!)")
            } else {
                print(reference)
                print("Remove successfully")
                self.navigationController?.popToRootViewController(animated: true)
            }
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
        if textField == txtAmount {
            return allowCharacterSet.isSuperset(of: typeCharacterSet)
        }
        return true
    }
}

extension EditTransactionController: SelectCategory, SelectDate{
    func setDate(date: String) {
        txtDate.text = date
    }
    
    func setCategory(nameCategory: String, iconCategory: String, type: String, id: String) {
        txtCategory.text = nameCategory
        iconImage.image = UIImage(named: iconCategory)
    }
    
    
}

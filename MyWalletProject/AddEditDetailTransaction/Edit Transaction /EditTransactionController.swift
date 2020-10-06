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
    var note:String? = ""
    var date:String = ""
    var categoryName: String = ""
    var transactionId: String = ""
    var type: String = ""
    var amount: Int = 0
    var icon: String = ""
    var dateModel: DateModel!
    var thisDate = Date()
    var event: Event!
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
        txtEvent.addTarget(self, action: #selector(myEvent), for: .touchDown)
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
                        self.txtEvent.text = artName as! String
                        self.iconEvent.image = UIImage(named: eventImage as! String)
                        break
                    }
                }
                
            }
            
        }
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
    
    
    @IBAction func clickTrash(_ sender: Any) {
        eventid?.removeAll()
        txtEvent.text = ""
        iconEvent.image = UIImage(named: "others")
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
    }
    
    
}

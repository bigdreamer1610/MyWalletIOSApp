//
//  EditTransactionViewController.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/8/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class EditTransactionViewController: UIViewController {
    
    var presenter: EditTransactionPresenter?
    var eventid: String? = nil
    var categoryName: String = ""
    var transactionType: String? = nil
    var categoryId: String? = nil
    var amount: Int = 0
    var icon: String = ""
    var timer = Timer()
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
        addTapTarget()
        scheduledTimerWithTimeInterval()
    }
    
    func setUp(presenter: EditTransactionPresenter){
        self.presenter = presenter
    }
    
    func customizeLayout(){
        txtCategory.setRightImage(imageName: "arrowright")
        txtEvent.setRightImage(imageName: "arrowright")
        txtDate.setRightImage(imageName: "arrowright")
    }
    
    func setUpData(trans: Transaction, event: Event?, categoryName: String, categoryImage: String){
        self.transaction = trans
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
        categoryId = transaction?.categoryid!
        transactionType = transaction?.transactionType!
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    func addTapTarget(){
        txtCategory.addTarget(self, action: #selector(clickCategory), for: .touchDown)
        txtDate.addTarget(self, action: #selector(clickDate), for: .touchDown)
        txtEvent.addTarget(self, action: #selector(clickEvent), for: .touchDown)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func clickCategory(textField: UITextField) {
        let vc = RouterType.selectCategory.getVc() as! SelectCategoryController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clickDate(textField: UITextField) {
        let vc = RouterType.selectDate.getVc() as! CustomDateController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clickEvent(textField: UITextField) {
        let vc = RouterType.selectEvent.getVc() as! SelectEventController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickCancel(_ sender: Any) {
        timer.invalidate()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickTrash(_ sender: Any) {
        resetEvent()
    }
    
    func resetEvent(){
        eventid?.removeAll()
        txtEvent.text = ""
        iconEvent.image = UIImage(named: "others")
    }
    
    @IBAction func clickSave(_ sender: Any) {
        timer.invalidate()
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
        
        let trans = Transaction(id: transaction?.id ?? "", transactionType: transactionType, amount: amount, categoryid: categoryId , date: txtDate.text!, note: txtNote.text!, eventid: eventid ?? "")
        presenter?.update(t: trans, oldType: transaction?.transactionType! ?? "")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    @objc func updateCounting(){
        var checkAmount = Int(txtAmount.text!)
        
        if checkAmount == 0 || txtCategory.text!.isEmpty || txtDate.text!.isEmpty || txtAmount.text!.isEmpty{
            btnSave.isEnabled = false
        }else{
            btnSave.isEnabled = true
        }
        
    }
    
    
}

extension EditTransactionViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowCharacters = "0123456789"
        let allowCharacterSet = CharacterSet(charactersIn: allowCharacters)
        let typeCharacterSet = CharacterSet(charactersIn: string)
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        btnSave.isEnabled = !text.isEmpty
        if textField == txtAmount{
            return allowCharacterSet.isSuperset(of: typeCharacterSet)
        }
        return true
    }
}

extension EditTransactionViewController : SelectCategory, SelectDate, SelectEvent {
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
        transactionType = type
        
    }
    
    
}

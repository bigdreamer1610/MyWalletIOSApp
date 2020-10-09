//
//  AddTransactionViewController.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class AddTransactionViewController: UIViewController {
    
    var presenter: AddTransactionPresenter?
    
    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var tfNote: UITextField!
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var tfCategory: UITextField!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var tfEvent: UITextField!
    @IBOutlet weak var iconEvent: UIImageView!
    @IBOutlet weak var viewShowMore: UIView!
    @IBOutlet var btnAddMore: UIButton!
    @IBOutlet var btnCancel: UIBarButtonItem!
    @IBOutlet var btnSave: UIBarButtonItem!
    
    var nameCategory: String? = ""
    var iconImages: String? = ""
    var date: String? = ""
    var note: String? = ""
    var amount: Int? = 0
    var categoryid: String? = ""
    var type: String? = ""
    var eventid: String? = nil
    var thisDate = Date()
    var timer = Timer()
    var budgets = [Budget]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        addTextFieldTarget()
        customizeLayout()
        scheduledTimerWithTimeInterval()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
    }
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    func setUp(presenter: AddTransactionPresenter){
        self.presenter = presenter
    }
    func addTextFieldTarget(){
        tfCategory.addTarget(self, action: #selector(clickCategory(textField:)), for: .touchDown)
        tfDate.addTarget(self, action: #selector(clickDate(textField:)), for: .touchDown)
        tfEvent.addTarget(self, action: #selector(clickEvent(textField:)), for: .touchDown)
    }
    func customizeLayout(){
        btnAddMore.layer.borderWidth = 1
        btnAddMore.layer.borderColor = #colorLiteral(red: 0.3929189782, green: 0.4198221317, blue: 0.8705882353, alpha: 1)
        btnAddMore.layer.cornerRadius = 6
        tfCategory.setRightImage(imageName: "arrowright")
        tfDate.setRightImage(imageName: "arrowright")
        tfEvent.setRightImage(imageName: "arrowright")
        iconEvent.image = UIImage(named: "others")
    }
    
    func initComponents(){
        viewShowMore.isHidden = true
        Defined.dateFormatter.locale = Locale(identifier: "vi_VN")
        Defined.dateFormatter.dateFormat = "dd/MM/yyyy"
        tfCategory.text = nameCategory
        iconImage.image = UIImage(named: iconImages!)
        tfDate.text = date
        tfDate.delegate = self
        tfAmount.delegate = self
        tfCategory.delegate = self
        tfNote.delegate = self
        btnSave.isEnabled = false
    }
    
    @objc func clickCategory(textField: UITextField) {
        let vc = RouterType.selectCategory.getVc() as! SelectCategoryController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clickDate(textField: UITextField) {
        let vc = RouterType.selectDate.getVc() as! CustomDateController
        
        if tfDate.text != "" {
            thisDate = Defined.dateFormatter.date(from: tfDate.text!)!
        }
        vc.customDate = thisDate
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func clickEvent(textField:UITextField){
        let vc = RouterType.selectEvent.getVc() as! SelectEventController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //let vc = RouterType.tabbar.getVc()
        //AppRouter.routerTo(from: vc, options: .curveEaseOut, duration: 0.2, isNaviHidden: true)
        
    }
    
    @IBAction func btnSave(_ sender: Any) {
        timer.invalidate()
        if let strAmount = tfAmount.text,
            let intAmount = Int(strAmount){
            amount = intAmount
            if amount! <= 0{
                let alert = UIAlertController(title: "Notification", message: "Amount of money cannot be 0", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        date = tfDate.text!
        note = tfNote.text!
        let transaction = Transaction(transactionType: type!, amount: amount!, categoryid: categoryid, date: date, note: note, eventid: eventid ?? "")
        presenter?.add(trans: transaction)
        let alert = UIAlertController(title: "Notification", message: "Add a new transaction successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
//            let vc = RouterType.tabbar.getVc()
//            AppRouter.routerTo(from: vc, options: .curveEaseOut, duration: 0.2, isNaviHidden: true)
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func btnAddMoreDetails(_ sender: Any) {
        
        UIView.animate(withDuration: 0.7) {
            self.viewShowMore.isHidden = false
            self.btnAddMore.isHidden = true
        }
        
    }
    @IBAction func btnDeleteMoreDetails(_ sender: Any) {
        eventid?.removeAll()
        tfEvent.text = ""
        iconEvent.image = UIImage(named: "others")
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    @objc func updateCounting(){
        let checkAmount = Int(tfAmount.text!)
        if checkAmount == 0 || tfDate.text!.isEmpty || tfCategory.text!.isEmpty || tfAmount.text!.isEmpty{
            btnSave.isEnabled = false
        }else{
            btnSave.isEnabled = true
        }
        
    }
}

extension AddTransactionViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowCharacters = "0123456789"
        let allowCharacterSet = CharacterSet(charactersIn: allowCharacters)
        let typeCharacterSet = CharacterSet(charactersIn: string)
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        btnSave.isEnabled = !text.isEmpty
        if textField == tfAmount {
            return allowCharacterSet.isSuperset(of: typeCharacterSet)
        }
        return true
    }
}
extension AddTransactionViewController : SelectDate, SelectCategory,SelectEvent {
    func setDate(date: String) {
        tfDate.text = date
    }
    
    func setCategory(nameCategory: String, iconCategory: String, type: String, id: String) {
        self.categoryid = id
        self.type = type
        tfCategory.text = nameCategory
        iconImage.image = UIImage(named: iconCategory)
    }
    
    func setEvent(nameEvent: String, imageEvent: String, eventid: String) {
        tfEvent.text = nameEvent
        iconEvent.image = UIImage(named: imageEvent)
        self.eventid = eventid
    }
    
    
}

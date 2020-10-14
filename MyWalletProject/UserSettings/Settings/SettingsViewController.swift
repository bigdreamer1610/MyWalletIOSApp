//
//  SettingsViewController.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 9/23/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var avaImage: UIImageView!
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtBalance: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtLanguage: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var btnSave: UIButton!

    var user = Account()
    var presenter: SettingsPresenter?
    var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureButton([btnSave])
        setupTextFieldDelegate(textFields: [txtUsername, txtBalance, txtDate, txtPhoneNumber, txtGender, txtAddress, txtLanguage])
        presenter?.requestUserInfo()
        
        self.title = Constants.information
    }
    
    // MARK: - Hide tab bar
    override var hidesBottomBarWhenPushed: Bool {
        get {
            return true
        }
        set {
            super.hidesBottomBarWhenPushed = newValue
        }
    }
    
    // MARK: - Make rounded buttons
    func configureButton(_ buttons: [UIButton]) {
        buttons.forEach { button in
            button.layer.cornerRadius = 10
        }
    }
    
    // MARK: - Setup delegate
    func setupDelegate(presenter: SettingsPresenter) {
        self.presenter = presenter
    }
    
    // MARK: - Setup textfield delegate
    func setupTextFieldDelegate(textFields: [UITextField]) {
        textFields.forEach { textField in
            textField.delegate = self
        }
    }
    
    // MARK: - Hide keyboard when tap on view or hit return key
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.scrollView.endEditing(true)
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Get active textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
        setupKeyboardNotification()
    }
    
    // MARK: - Setup notification for keypad show up and hide
    func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        //Need to calculate keyboard exact size due to Apple suggestions
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)

        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets

        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeTextField = self.activeTextField {
            if (!aRect.contains(activeTextField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeTextField.frame, animated: true)
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        //Once keyboard disappears, restore original positions
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }
    
    // MARK: - Buttons click handler
    @IBAction func btnSaveClicked(_ sender: Any) {
        if let name = txtUsername.text {
            user.name = name
        }
        if let balance = Int(txtBalance.text ?? "")  {
            user.balance = balance
        }
        
        user.email = Defined.defaults.string(forKey: Constants.email)
        
        if let dateOfBirth = txtDate.text {
            user.dateOfBirth = dateOfBirth
        }
        if let phoneNumber = txtPhoneNumber.text {
            user.phoneNumber = phoneNumber
        }
        if let gender = txtGender.text {
            user.gender = gender
        }
        if let address = txtAddress.text {
            user.address = address
        }
        if let language = txtLanguage.text {
            user.language = language
        }
        
        presenter?.validateInput(user)
    }
}

extension SettingsViewController: SettingsPresenterDelegate {
    func setupForViews(_ user: Account) {
        txtBalance.text = "\(user.balance ?? 0)"

        if let name = user.name {
            txtUsername.text = name
        }
        if let dateOfBirth = user.dateOfBirth {
            txtDate.text = dateOfBirth
        }
        if let phoneNumber = user.phoneNumber {
            txtPhoneNumber.text = phoneNumber
        }
        if let gender = user.gender {
            txtGender.text = gender
        }
        if let address = user.address {
            txtAddress.text = address
        }
        if let language = user.language {
            txtLanguage.text = language
        }
    }
    
    func showAlertMessage(_ message: String, _ state: Bool) {
        if !state {
            AlertUtil.showAlert(from: self, with: Constants.alertInvalidInputTitle, message: message)
        } else {
            AlertUtil.showAlert(from: self, with: Constants.alertSuccessTitle, message: Constants.alertSuccessInfomationUpdate)
        }
    }
}

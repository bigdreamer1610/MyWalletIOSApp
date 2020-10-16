//
//  ScanBillViewController.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 9/23/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class ScanBillViewController: UIViewController, UITextFieldDelegate {
    
    var presenter: ScanBillPresenter?

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var imageInput: UIImageView!
    
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnGallery: UIButton!
    @IBOutlet weak var btnScan: UIButton!
    
    @IBOutlet weak var btnAddTransaction: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        configureButton([btnCamera, btnGallery, btnScan, btnAddTransaction])
        borderImageView(imageInput)
        setupTextFieldDelegate(textFields: [txtNote])
        
        self.title = Constants.billScanner
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
    
    // MARK: - Border image view
    func borderImageView(_ imageView: UIImageView) {
        imageView.setImageColor(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
    }
    
    // MARK: - Setup delegate
    func setupDelegate(presenter: ScanBillPresenter) {
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
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Get bill's image from user with photo library
    @IBAction func btnGalleryClicked(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Get bill's image from user with camera
    @IBAction func btnCameraClicked(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        imagePicker.showsCameraControls = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Process image to presenter to handle
    @IBAction func btnScanClicked(_ sender: Any) {
        presenter?.handleImage(imageInput.image!)
    }
    
    // MARK: - Save transaction to DB
    @IBAction func btnAddTransactionClicked(_ sender: Any) {
        var userTransaction = Transaction()
        
        var amount = lblTotal.text!.replacingOccurrences(of: " VND", with: "")
        amount = amount.replacingOccurrences(of: ".", with: "")
        
        userTransaction.amount = Int(amount)
        userTransaction.categoryid = "Bill"
        userTransaction.note = txtNote.text
        userTransaction.date = lblDate.text
        
        presenter?.saveTransaction(userTransaction)
    }
}

extension ScanBillViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Get image from photo library and place it in image view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageInput.contentMode = .scaleAspectFit
            imageInput.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ScanBillViewController: ScanBillPresenterDelegate {
    // Show alert to inform user depend on state (fail or success)
    func showAlertMessage(_ state: Bool) {
        if !state {
            AlertUtil.showAlert(from: self, with: Constants.alertInvalidTransactionTitle, message: Constants.billNotScan)
        } else {
            AlertUtil.showAlert(from: self, with: Constants.alertSuccessTitle, message: Constants.alertSuccessSaveBill)
        }
    }
    
    // Set up views with processed data from presenter
    func setupForViews(_ transaction: Transaction) {
        self.lblDate.text = transaction.date ?? "Undefined"
        
        if let value = transaction.amount {
            if let total = Defined.formatter.string(from: NSNumber(value: value)) {
                self.lblTotal.text = "\(String(describing: total)) VND"
            }
        }

        self.txtNote.text = transaction.note ?? "Undefined"
    }
}


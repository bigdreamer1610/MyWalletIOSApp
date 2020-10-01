//
//  ScanBillViewController.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 9/23/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

protocol ScanBillViewControllerProtocol: class {
    func setupForViews(_ transaction: Transaction)
    func showAlert(_ state: Bool)
}

class ScanBillViewController: UIViewController {
    
    var presenter: ScanBillPresenter = ScanBillPresenter()

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtNote: UITextView!
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var imageInput: UIImageView!
    
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnGallery: UIButton!
    @IBOutlet weak var btnScan: UIButton!
    
    @IBOutlet weak var btnAddTransaction: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        
        configureButton(btnCamera)
        configureButton(btnGallery)
        configureButton(btnScan)
        configureButton(btnAddTransaction)
        configureButton(btnCancel)
        
        borderImageView(imageInput)
        
        removeTextViewLeftPadding(txtNote)
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
    func configureButton(_ button: UIButton) {
        button.layer.cornerRadius = 10
    }
    
    // MARK: - Remove left padding of text view
    func removeTextViewLeftPadding(_ textView: UITextView) {
        textView.textContainer.lineFragmentPadding = 0
    }
    
    // MARK: - Border image view
    func borderImageView(_ imageView: UIImageView) {
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
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
        presenter.viewDelegate = self
        presenter.handleImage(imageInput.image!)
    }
    
    // MARK: - Save transaction to DB
    @IBAction func btnAddTransactionClicked(_ sender: Any) {
        var userTransaction = Transaction()
        
        userTransaction.amount = Int(lblTotal.text!.replacingOccurrences(of: " VND", with: ""))
        userTransaction.categoryid = "Bill"
        userTransaction.note = txtNote.text
        userTransaction.date = lblDate.text
        
        presenter.viewDelegate = self
        presenter.saveTransaction(userTransaction)
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        // TODO: Implementation of cancelling
    }
}

extension ScanBillViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Get image from photo library and place it in image view
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

extension ScanBillViewController: ScanBillViewControllerProtocol {
    // MARK: - Show alert to inform user depend on state (fail or success)
    func showAlert(_ state: Bool) {
        if !state {
            let alert = UIAlertController(title: "INVALID TRANSACTION", message: "You might haven't scanned your bill yet, please try again!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "SUCCESS", message: "Your transaction has successfully been saved!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Set up views with processed data from presenter
    func setupForViews(_ transaction: Transaction) {
        self.lblDate.text = transaction.date ?? "Undefined"
        self.lblTotal.text = "\(transaction.amount ?? 0) VND"
        self.txtNote.text = transaction.note ?? "Undefined"
    }
}

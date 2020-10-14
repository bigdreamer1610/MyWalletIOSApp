//
//  AddEditCategoryViewController.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

protocol AddEditCategoryViewControllerDelegate {
    func finishManagingCategory(_ category: Category)
}

class AddEditCategoryViewController: UIViewController {

    @IBOutlet weak var selectCategoryView: UIView!
    @IBOutlet weak var categoryTypeView: UIView!
    @IBOutlet weak var selectImageView: UIView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var imageCategory: UIImageView!
    
    @IBOutlet weak var txtCategoryName: UITextField!
    
    var listImageName: [String] = []
    var imageIndex = -1
    var categoryType = ""
    var presenter: AddEditCategoryPresenter?
    var delegate: AddEditCategoryViewControllerDelegate?
    var isFinish = false
    var action = ""
    var category: Category = Category()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTopBorder([selectCategoryView])
        addBottomBorder([selectCategoryView, categoryTypeView])
        setupGestureForView([selectImageView])
        addRightBorder([selectImageView])
        
        setupView()
        setupSegmentTextColor()
    }
    
    // MARK: - Setup view depends on which screen call this view
    func setupView() {
        if action == "add" {
            self.title = Constants.addCategory
            self.categoryType = "income"
            self.segmentControl.selectedSegmentIndex = 0
        } else {
            self.title = Constants.editCategory
            
            if self.category.transactionType == "Income" {
                self.segmentControl.selectedSegmentIndex = 0
            } else {
                self.segmentControl.selectedSegmentIndex = 1
            }
            
            if let imageName = self.category.iconImage {
                imageCategory.image = UIImage(named: imageName)
            }
            if let categoryName = self.category.name {
                txtCategoryName.text = categoryName
            }
            
            segmentControl.isEnabled = false
        }
    }
    
    // MARK: - Setup color for segment text
    func setupSegmentTextColor() {
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.colorFromHexString(hex: "646BDE")], for: UIControl.State.selected)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
    }
    
    // MARK: - Setup delegate
    func setupDelegate(presenter: AddEditCategoryPresenter) {
        self.presenter = presenter
    }
    
    // MARK: - Add borders for views
    func addBottomBorder(_ views: [UIView]) {
        views.forEach { (view) in
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: 0.0, y: view.frame.size.height-1, width: view.frame.width, height: 1.0)
            bottomBorder.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            view.layer.addSublayer(bottomBorder)
        }
    }
    func addTopBorder(_ views: [UIView]) {
        views.forEach { (view) in
            let topBorder = CALayer()
            topBorder.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 1.0)
            topBorder.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            view.layer.addSublayer(topBorder)
        }
    }
    func addRightBorder(_ views: [UIView]) {
        views.forEach { (view) in
            let rightBorder = CALayer()
            rightBorder.frame = CGRect(x: view.frame.width - 1.0, y: 0.0, width: 1.0, height: view.frame.height)
            rightBorder.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            view.layer.addSublayer(rightBorder)
        }
    }
    
    // MARK: - Set text for back button
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        backItem.tintColor = UIColor.init(displayP3Red: 52, green: 199, blue: 90, alpha: 1.0)
        navigationItem.backBarButtonItem = backItem
    }
    
    // MARK: - Setup gesture on view
    func setupGestureForView(_ views: [UIView]) {
        views.forEach { (view) in
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            view.addGestureRecognizer(tap)
            view.isUserInteractionEnabled = true
        }
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let selectIconController = UIStoryboard.init(name: "Categories", bundle: nil).instantiateViewController(identifier: "selectIconVC") as! SelectIconViewController
        selectIconController.listImageName = self.listImageName
        selectIconController.delegate = self
        self.navigationController?.pushViewController(selectIconController, animated: true)
    }
    
    // MARK: - Show success alert depends on activity: Add or Edit
    func showSuccessAlert(_ message: String) {
        AlertUtil.showAlert(from: self, with: Constants.alertSuccessTitle, message: message, completion: { action in self.finish() })
    }
    func finish() {
        self.delegate?.finishManagingCategory(self.category)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Button clicked
    @IBAction func btnCancelClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveClick(_ sender: Any) {
        if action == "add" {
            presenter?.validateInput(txtCategoryName.text, imageIndex)
        } else {
            if let categoryType = self.category.transactionType {
                var editedCategory = Category()
                editedCategory.id = self.category.id
                editedCategory.iconImage = self.category.iconImage
                if let categoryName = txtCategoryName.text {
                    editedCategory.name = categoryName
                }
                
                self.category = editedCategory
                
                presenter?.saveUserCategory(editedCategory, categoryType)
                showSuccessAlert(Constants.alertSuccessAddCategory)
            }
        }
    }
    
    @IBAction func segmentClick(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            self.categoryType = "income"
        default:
            self.categoryType = "expense"
        }
    }
}

extension AddEditCategoryViewController: SelectIconViewControllerDelegate {
    func setupForAddCategory(_ index: Int, _ listImageName: [String]) {
        self.listImageName = listImageName
        self.imageIndex = index
        
        imageCategory.image = UIImage(named: listImageName[imageIndex])
    }
}

extension AddEditCategoryViewController: AddEditCategoryPresenterDelegate {
    func showAlertMessage(_ message: String, _ state: Bool) {
        if !state {
            AlertUtil.showAlert(from: self, with: Constants.alertInvalidCategoryTitle, message: message)
        } else {
            var userCategory = Category()
            userCategory.iconImage = listImageName[imageIndex]
            if let categoryName = txtCategoryName.text {
                userCategory.name = categoryName
                userCategory.id = categoryName
            }
            presenter?.saveUserCategory(userCategory, self.categoryType)
            
            showSuccessAlert(Constants.alertSuccessAddCategory)
        }
    }
}

//
//  AddEditCategoryViewController.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

protocol AddEditCategoryViewControllerDelegate {
    func finishAddingCategory(_ state: Bool)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTopBorder([selectCategoryView])
        addBottomBorder([selectCategoryView, categoryTypeView])
        setupGestureForView([selectImageView])
        addRightBorder([selectImageView])
        
        self.title = "Add category"
        self.categoryType = "income"
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
    
    func finish() {
        self.delegate?.finishAddingCategory(isFinish)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Button clicked
    @IBAction func btnCancelClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveClick(_ sender: Any) {
        presenter?.validateInput(txtCategoryName.text, imageIndex)
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
            let alert = UIAlertController(title: "INVALID CATEGORY", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            var userCategory = Category()
            userCategory.iconImage = listImageName[imageIndex]
            if let categoryName = txtCategoryName.text {
                userCategory.name = categoryName
            }
            presenter?.saveUserCategory(userCategory, self.categoryType)
            
            self.isFinish = state
            
            let alert = UIAlertController(title: "SUCCESS", message: "Your category has successfully been added!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in self.finish()}))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

//
//  DetailCategoryViewController.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 10/8/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

protocol DetailCategoryViewControllerDelegate {
    func finishHandleCategory()
}

class DetailCategoryViewController: UIViewController {
    
    var category: Category = Category()

    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var txtCategoryName: UITextField!
    @IBOutlet weak var lblCategoryType: UILabel!

    @IBOutlet weak var imgCategoryView: UIView!
    @IBOutlet weak var categoryNameView: UIView!
    @IBOutlet weak var typeIconView: UIView!
    @IBOutlet weak var categoryTypeView: UIView!
    @IBOutlet weak var deleteView: UIView!
    
    var delegate: DetailCategoryViewControllerDelegate?
    var presenter: DetailCategoryPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addTopBorder([imgCategoryView, categoryNameView, deleteView])
        addBottomBorder([categoryNameView, typeIconView, categoryTypeView, deleteView])
        setupGestureForView([deleteView])
        txtCategoryName.isUserInteractionEnabled = false
    }
    
    // MARK: - Setup view
    func setupView() {
        if let iconImage = self.category.iconImage {
            categoryImage.image = UIImage(named: iconImage)
        }
        if let categoryName = self.category.name {
            txtCategoryName.text = categoryName
        }
        if var categoryType = self.category.transactionType {
            categoryType = categoryType.capitalizingFirstLetter()
            lblCategoryType.text = categoryType
        }
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
    
    // MARK: - Setup delegate
    func setupDelegate(presenter: DetailCategoryPresenter) {
        self.presenter = presenter
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
        let deleteAlert = UIAlertController(title: Constants.alertDeleteWarning, message: Constants.alertDeleteMessage, preferredStyle: UIAlertController.Style.alert)

        deleteAlert.addAction(UIAlertAction(title: Constants.alertButtonDelete, style: .default, handler: { (action: UIAlertAction!) in self.finish()}))
        deleteAlert.addAction(UIAlertAction(title: Constants.alertButtonCancel, style: .cancel, handler: nil))

        present(deleteAlert, animated: true, completion: nil)
    }
    func finish() {
        self.presenter?.deleteCategory(self.category)
        self.presenter?.deleteAllTransactionOfCategory(self.category)
        self.presenter?.deleteAllBudgetOfCategory(self.category)
    }
    
    // MARK: - Handle buttons click
    @IBAction func btnCancelClick(_ sender: Any) {
        delegate?.finishHandleCategory()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnEditClick(_ sender: Any) {
        let addEditCategoryController = UIStoryboard.init(name: "Categories", bundle: nil).instantiateViewController(identifier: "settingsAddCategoryVC") as! AddEditCategoryViewController
        addEditCategoryController.action = "edit"
        addEditCategoryController.category = self.category
        addEditCategoryController.delegate = self
        let presenter = AddEditCategoryPresenter(delegate: addEditCategoryController, usecase: AddEditCategoryUseCase())
        addEditCategoryController.setupDelegate(presenter: presenter)
        self.navigationController?.pushViewController(addEditCategoryController, animated: true)
    }
}

extension DetailCategoryViewController: AddEditCategoryViewControllerDelegate {
    func finishManagingCategory(_ category: Category) {
        if let imageName = category.iconImage {
            categoryImage.image = UIImage(named: imageName)
        }
        if let categoryName = category.name {
            txtCategoryName.text = categoryName
        }
    }
}

extension DetailCategoryViewController: DetailCategoryPresenterDelegate {
    func finishDeleteCategory() {
        delegate?.finishHandleCategory()
        self.navigationController?.popViewController(animated: true)
    }
}

//
//  AddCategoryViewController.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class ViewCategoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var presenter: ViewCategoryPresenter?
    var categoriesIncome: [Category] = []
    var categoriesExpense: [Category] = []
    var listImage: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Constants.categories
        
        setupTableView()
        requestData()
        tableView.reloadData()
    }
    
    // MARK: - Request data for view
    func requestData() {
        presenter?.requestIncomeCategories()
        presenter?.requestExpenseCategories()
        presenter?.requestListImage()
    }
    
    // MARK: - Setup for table view
    func setupTableView() {
        CategoryTableViewCell.registerCellByNib(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = false
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
    
    // MARK: - Setup delegate
    func setupDelegate(presenter: ViewCategoryPresenter) {
        self.presenter = presenter
    }

    @IBAction func btnCancelClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddClick(_ sender: Any) {
        let addEditCategoryController = UIStoryboard.init(name: "Categories", bundle: nil).instantiateViewController(identifier: "settingsAddCategoryVC") as! AddEditCategoryViewController
        addEditCategoryController.listImageName = self.listImage
        addEditCategoryController.action = "add"
        addEditCategoryController.delegate = self
        let presenter = AddEditCategoryPresenter(delegate: addEditCategoryController, usecase: AddEditCategoryUseCase())
        addEditCategoryController.setupDelegate(presenter: presenter)
        self.navigationController?.pushViewController(addEditCategoryController, animated: true)
    }
}

extension ViewCategoryViewController: ViewCategoryPresenterDelegate {
    func receiveListImage(_ listImage: [String]) {
        self.listImage = listImage
    }
    
    func receiveIncomeCategories(_ listCategoryIncome: [Category]) {
        categoriesIncome = listCategoryIncome
        tableView.reloadData()
    }
    
    func receiveExpenseCategories(_ listCategoryExpense: [Category]) {
        categoriesExpense = listCategoryExpense
        tableView.reloadData()
    }
}

extension ViewCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return categoriesExpense.count
        }
        
        return categoriesIncome.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = CategoryTableViewCell.loadCell(tableView) as! CategoryTableViewCell
            cell.setupForView(categoriesExpense[indexPath.row].iconImage!, categoriesExpense[indexPath.row].name!)
            
            return cell
        } else {
            let cell = CategoryTableViewCell.loadCell(tableView) as! CategoryTableViewCell
            cell.setupForView(categoriesIncome[indexPath.row].iconImage!, categoriesIncome[indexPath.row].name!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Expense"
        }
        
        return "Income"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var category = Category()
        if indexPath.section == 0 {
            if let iconImage = categoriesExpense[indexPath.row].iconImage {
                category.iconImage = iconImage
            }
            if let categoryName = categoriesExpense[indexPath.row].name {
                category.name = categoryName
            }
            if let categoryId = categoriesExpense[indexPath.row].id {
                category.id = categoryId
            }
            category.transactionType = "expense"
        } else {
            if let iconImage = categoriesIncome[indexPath.row].iconImage {
                category.iconImage = iconImage
            }
            if let categoryName = categoriesIncome[indexPath.row].name {
                category.name = categoryName
            }
            if let categoryId = categoriesIncome[indexPath.row].id {
                category.id = categoryId
            }
            category.transactionType = "income"
        }
        
        let detailCategoryController = UIStoryboard.init(name: "Categories", bundle: nil).instantiateViewController(identifier: "detailCategoryVC") as! DetailCategoryViewController
        detailCategoryController.category = category
        detailCategoryController.delegate = self
        let presenter = DetailCategoryPresenter(delegate: detailCategoryController, usecase: DetailCategoryUseCase())
        detailCategoryController.setupDelegate(presenter: presenter)
        self.navigationController?.pushViewController(detailCategoryController, animated: true)
    }
}

extension ViewCategoryViewController: AddEditCategoryViewControllerDelegate {
    func finishManagingCategory(_ category: Category) {
        requestData()
    }
}

extension ViewCategoryViewController: DetailCategoryViewControllerDelegate {
    func finishHandleCategory() {
        requestData()
    }
}

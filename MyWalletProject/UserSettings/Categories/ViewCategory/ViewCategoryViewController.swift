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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Categories"
        
        setupTableView()
        
        presenter?.requestIncomeCategories()
        presenter?.requestExpenseCategories()
        
        tableView.reloadData()
    }
    
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
    
    @IBAction func btnSaveClick(_ sender: Any) {
    }
}

extension ViewCategoryViewController: ViewCategoryPresenterDelegate {
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
}

//
//  BudgetDetailController.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 10/1/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Firebase

protocol DetailBudgetTappedButton : class {
    func btnDeleteTapped()
    func btnListTransactionTapped()
}

protocol BudgetDetailControllerDelegate {
    func reloadDataListBudgetintoBudgetDetailController()
}

class BudgetDetailController: UIViewController {
    @IBOutlet weak var tblBudget: UITableView!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var btnEdit: UIBarButtonItem!
    
    var presenter:BudgetDetailPresenter?
    var budgetObject:Budget = Budget()
    var spent:Int = 0
    var delegateBudgetDetail:BudgetDetailControllerDelegate?
    
    var language = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizableDetailBudget()
        tblBudget.dataSource = self
        tblBudget.delegate = self
        tblBudget.register(UINib(nibName: "DetailBudgetCell", bundle: nil), forCellReuseIdentifier: "DetailBudgetCell")
    }
    
    // Localizable (change language)
    func localizableDetailBudget(){
        btnBack.title = BudgetDetailDataString.back.rawValue.addLocalizableString(str: language)
        btnEdit.title = BudgetDetailDataString.edit.rawValue.addLocalizableString(str: language)
        navigationItem.title = BudgetDetailDataString.budgetDetail.rawValue.addLocalizableString(str: language)
    }
    
    func setUp(presenter:BudgetDetailPresenter){
        self.presenter = presenter
    }
    
    // btn back click
    @IBAction func btnBackClick(_ sender: Any) {
        self.delegateBudgetDetail?.reloadDataListBudgetintoBudgetDetailController()
        navigationController?.popViewController(animated: true)
    }
    
    // btn edit click
    @IBAction func btnEditClick(_ sender: Any) {
        let vc = RouterType.budgetAddEdit.getVc() as! BudgetController
        vc.type = BudgetAddEditDataString.editBudget.rawValue
        vc.budgetObject = budgetObject
        vc.language = language
        vc.delegateBudgetController = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: table view datasource , delegate
extension BudgetDetailController: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailBudgetCell", for: indexPath) as! DetailBudgetCell
        cell.prgSpend.layer.cornerRadius = cell.prgSpend.bounds.height / 2
        cell.prgSpend.layer.masksToBounds = true
        cell.setDataBackground(cateImage: budgetObject.categoryImage!, cateName: budgetObject.categoryName!, amount: budgetObject.amount!, startdate: budgetObject.startDate!, endDate: budgetObject.endDate!, spend: spent , language: language)
        UserDefaults.standard.set(budgetObject.categoryName!, forKey: "name")
        UserDefaults.standard.set(budgetObject.startDate!, forKey: "startdate")
        UserDefaults.standard.set(budgetObject.endDate!, forKey: "enddate")
        cell.btnDelete.addTarget(self, action: #selector(btnDeleteTapped), for: .touchUpInside)
        cell.btnTransaction.addTarget(self, action: #selector(btnListTransactionTapped), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tblBudget.frame.height
    }
}

//MARK: tap button delete and list transaction in Detail controller
extension BudgetDetailController : DetailBudgetTappedButton {
    
    @objc func btnDeleteTapped(){
        let alertController = UIAlertController(title: BudgetDetailDataString.dialogConfirmDelete.rawValue.addLocalizableString(str: language), message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: BudgetDetailDataString.dialogItemOK.rawValue.addLocalizableString(str: language), style: .default) { (_) in
            self.presenter?.deleteBudgetDB(id: self.budgetObject.id!)
            self.delegateBudgetDetail?.reloadDataListBudgetintoBudgetDetailController()
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: BudgetDetailDataString.dialogItemCancel.rawValue.addLocalizableString(str: language), style: .cancel) { (_) in
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func btnListTransactionTapped() {
        let vc = RouterType.budgetTransaction(budgetObject: budgetObject).getVc()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: parse data budget detail into budget controller
extension BudgetDetailController : BudgetControllerDelegate {
    func reloadDataDetailBudgetintoBudgetController(budget: Budget, spend: Int) {
        self.spent = spend
        self.budgetObject = budget
        tblBudget.reloadData()
    }
    func reloadDataListBudgetintoBudgetController() {
    }
}



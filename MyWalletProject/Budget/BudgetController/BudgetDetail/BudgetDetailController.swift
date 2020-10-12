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

class BudgetDetailController: UIViewController {
    @IBOutlet weak var tblBudget: UITableView!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var btnEdit: UIBarButtonItem!
    
    var refreshControl = UIRefreshControl()
    var presenter:BudgetDetailPresenter?
    var budgetObject:Budget = Budget()
    var budgetID = 0
    var spent:Int = 0
    var listTransaction = [Transaction]()
    
    var language = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.getDataBudgetId(id: budgetID)
        localizableDetailBudget()
        tblBudget.dataSource = self
        tblBudget.delegate = self
        tblBudget.register(UINib(nibName: "DetailBudgetCell", bundle: nil), forCellReuseIdentifier: "DetailBudgetCell")
        refreshControl.attributedTitle = NSAttributedString(string: BudgetListDataString.refresh.rawValue.addLocalizableString(str: language))
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblBudget.addSubview(refreshControl)
        tblBudget.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getDataBudgetId(id: budgetID)
        tblBudget.reloadData()
    }
    
    // func refresh table when pull down
    @objc func refresh(_ sender: AnyObject){
        presenter?.getDataBudgetId(id: budgetID)
        tblBudget.reloadData()
        refreshControl.endRefreshing()
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
        navigationController?.popViewController(animated: true)
    }
    
    // btn edit click
    @IBAction func btnEditClick(_ sender: Any) {
        let vc = RouterType.budgetAddEdit.getVc() as! BudgetController
        vc.type = BudgetAddEditDataString.editBudget.rawValue
        vc.budgetObject = budgetObject
        vc.language = language
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
        presenter?.getAmountListTransaction(budget: budgetObject, listTransaction: listTransaction)
        cell.setDataBackground(cateImage: budgetObject.categoryImage ?? "", cateName: budgetObject.categoryName ?? "", amount: budgetObject.amount ?? 0, startdate: budgetObject.startDate ?? "", endDate: budgetObject.endDate ?? "", spend: spent , language: language)
        UserDefaults.standard.set(budgetObject.categoryName ?? "", forKey: Constants.budgetCateName)
        UserDefaults.standard.set(budgetObject.startDate ?? "", forKey: Constants.budgetStartDate)
        UserDefaults.standard.set(budgetObject.endDate ?? "", forKey: Constants.budgetEndDate)
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
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: BudgetDetailDataString.dialogItemCancel.rawValue.addLocalizableString(str: language), style: .cancel) { (_) in
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func btnListTransactionTapped() {
        let vc = RouterType.budgetTransaction(budgetObject: budgetObject).getVc() as! BudgetTransactionViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension BudgetDetailController : BudgetDetailPresenterDelegate {
    func getBudget(budget: Budget, listTransaction: [Transaction]) {
        self.budgetObject = budget
        self.listTransaction = listTransaction
        tblBudget.reloadData()
    }
    
    func getAmount(amount: Int) {
        self.spent = amount
    }
    
}





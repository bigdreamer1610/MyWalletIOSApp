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
    
    var ref = Database.database().reference()
    
    var budgetObject:Budget = Budget()
    var spent:Int = 0
    
    var delegateBudgetDetail:BudgetControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblBudget.dataSource = self
        tblBudget.delegate = self
        
        tblBudget.register(UINib(nibName: "DetailBudgetCell", bundle: nil), forCellReuseIdentifier: "DetailBudgetCell")
    }
 
    @IBAction func btnBackClick(_ sender: Any) {
        self.delegateBudgetDetail?.reloadDataListBudgetintoBudgetController()
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnEditClick(_ sender: Any) {
        let vc = UIStoryboard.init(name: "budget", bundle: nil).instantiateViewController(withIdentifier: "TestController") as! BudgetController
        
//        UserDefaults.standard.set(lblNameCate.text!, forKey: "name")
        
        vc.type = "Edit Budget"
        vc.budgetObject = budgetObject
        vc.delegateBudgetController = self
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BudgetDetailController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailBudgetCell", for: indexPath) as! DetailBudgetCell
        
        cell.prgSpend.layer.cornerRadius = cell.prgSpend.bounds.height / 2
        cell.prgSpend.layer.masksToBounds = true
        
        cell.setDataBackground(cateImage: budgetObject.categoryImage!, cateName: budgetObject.categoryName!, amount: budgetObject.amount!, startdate: budgetObject.startDate!, endDate: budgetObject.endDate!, spend: spent)
        
        cell.btnDelete.addTarget(self, action: #selector(btnDeleteTapped), for: .touchUpInside)
        
        cell.btnTransaction.addTarget(self, action: #selector(btnListTransactionTapped), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tblBudget.frame.height
    }
    
}

extension BudgetDetailController : DetailBudgetTappedButton {
    
    @objc func btnDeleteTapped(){
        let alertController = UIAlertController(title: "Do you want exit", message: nil, preferredStyle: .alert)
        
         let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
        
            self.ref.child("Account").child("userid1").child("budget").child("\(self.budgetObject.id!)").removeValue()
            
            self.delegateBudgetDetail?.reloadDataListBudgetintoBudgetController()
            self.navigationController?.popViewController(animated: true)
            
         }
        
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            print("cancel")
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func btnListTransactionTapped() {
        print("Transaction")
    }
}

extension BudgetDetailController : BudgetControllerDelegate {
    func reloadDataDetailBudgetintoBudgetController(budget: Budget, spend: Int) {
        self.spent = spend
        self.budgetObject = budget
        tblBudget.reloadData()
    }
    
    func reloadDataListBudgetintoBudgetController() {
    }
}


//
//  BudgetDetailViewController.swift
//  MyWallet
//
//  Created by Hoang Lam on 9/22/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Firebase

class BudgetDetailViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var imgCate: UIImageView!
    @IBOutlet weak var lblNameCate: UILabel!
    @IBOutlet weak var lblAmout: UILabel!
    @IBOutlet weak var lblSpent: UILabel!
    @IBOutlet weak var lblRest: UILabel!
    @IBOutlet weak var lblSpentAllow: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnListTran: UIButton!
    @IBOutlet weak var btnDeleteBudget: UIButton!
    @IBOutlet weak var prgSpent: UIProgressView!
    
    var ref = Database.database().reference()
    
    var budgetObject:Budget = Budget()
    var spent:Int = 0
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnListTran.layer.cornerRadius = btnListTran.bounds.height / 2
        btnDeleteBudget.layer.cornerRadius = btnDeleteBudget.bounds.height / 2
        prgSpent.layer.cornerRadius = prgSpent.bounds.height / 2
        prgSpent.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rest = budgetObject.amount! - spent
        
        imgCate.image = UIImage(named: budgetObject.categoryImage ?? "")
        lblNameCate.text = budgetObject.categoryName
        lblAmout.text = "\(budgetObject.amount ?? 0)"
        lblSpent.text = "\(spent)"
        lblSpentAllow.text = "\(budgetObject.amount ?? 0)"
        lblDate.text = "\(budgetObject.startDate ?? "") - \(budgetObject.endDate ?? "")"
        
        lblRest.text = "\(rest)"
        
        prgSpent.setProgress((Float(spent))/Float(budgetObject.amount ?? 1), animated: true)
        
        if((Float(spent))/Float(budgetObject.amount ?? 1) > 1.0){
            prgSpent.progressTintColor = UIColor.red
        }
        else{
            prgSpent.progressTintColor = UIColor.green
        }
    }

    
    @IBAction func btnEditClick(_ sender: Any) {
//        let vc = UIStoryboard.init(name: "Lam", bundle: nil).instantiateViewController(withIdentifier: "BudgetEditViewController") as! BudgetEditViewController
        
        let vc = UIStoryboard.init(name: "Lam", bundle: nil).instantiateViewController(withIdentifier: "TestController") as! BudgetController
        
        UserDefaults.standard.set(lblNameCate.text!, forKey: "name")
        
        vc.type = "Edit Budget"
        vc.budgetObject = budgetObject
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnListTransClick(_ sender: Any) {
        
    }
    
    
    @IBAction func btnDeleteClick(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Do you want exit", message: nil, preferredStyle: .alert)
        
         let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
        
            self.ref.child("Account").child("userid1").child("budget").child("\(self.budgetObject.id!)").removeValue()
            
            let vc = UIStoryboard.init(name: "Lam", bundle: nil).instantiateViewController(withIdentifier: "BudgetListViewController") as! BudgetListViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
         }
        
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            print("cancel")
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

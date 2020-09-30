//
//  TimeRangerViewController.swift
//  MyWallet
//
//  Created by Hoang Lam on 9/23/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class TimeRangerViewController: UIViewController {

    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    
    var type = ""
    
    var budgetObject:Budget = Budget()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        loadValue()
        
        txtStartDate.text = budgetObject.startDate ?? ""
        txtEndDate.text = budgetObject.endDate ?? ""
        
        txtStartDate.addTarget(self, action: #selector(pushCalendarStartClick), for: .touchDown)
        
        txtEndDate.addTarget(self, action: #selector(pushCalendarEndClick), for: .touchDown)
       
    }
    
    @objc func pushCalendarStartClick() {
        let vc = UIStoryboard.init(name: "Lam", bundle: nil).instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController

        vc.type = type
        vc.key = "Start"
        vc.budgetObject = budgetObject
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func pushCalendarEndClick() {
        let vc = UIStoryboard.init(name: "Lam", bundle: nil).instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController

        vc.type = type
        vc.key = "End"
        vc.budgetObject = budgetObject
        
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDoneClick(_ sender: Any) {
        
        if (budgetObject.startDateSecondWith1970 == 0.0 || budgetObject.endDateSecondWith1970 == 0.0){
            let alertController = UIAlertController(title: nil, message: "Select full Start and End date", preferredStyle: .alert)
            
                let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
                }
            
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        else if (budgetObject.startDateSecondWith1970! - budgetObject.endDateSecondWith1970! > 0.0){
            
            let alertController = UIAlertController(title: nil, message: "Start date is less than End date", preferredStyle: .alert)
            
                let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
                }
            
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        else{
//            if type == "Add budget" {
////                let vc = UIStoryboard.init(name: "Lam", bundle: nil).instantiateViewController(withIdentifier: "BudgetViewController") as! BudgetViewController
//
//                let vc = UIStoryboard.init(name: "Lam", bundle: nil).instantiateViewController(withIdentifier: "TestController") as! TestController
//                vc.budgetObject = budgetObject
//
//                navigationController?.pushViewController(vc, animated: true)
//            }
//
//            else if type == "Edit budget" {
//                let vc = UIStoryboard.init(name: "Lam", bundle: nil).instantiateViewController(withIdentifier: "BudgetEditViewController") as! BudgetEditViewController
//
//                vc.budgetObject = budgetObject
//
//                navigationController?.pushViewController(vc, animated: true)
//            }
            
            let vc = UIStoryboard.init(name: "Lam", bundle: nil).instantiateViewController(withIdentifier: "TestController") as! BudgetController
            vc.budgetObject = budgetObject
            vc.type = type
            
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}

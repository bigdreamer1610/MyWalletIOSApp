//
//  TimeRangerViewController.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 9/30/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

protocol TimeRangerViewControllerDelegate {
    func fetchDataTimeRanger(budget:Budget,type:String)
}

class TimeRangerViewController: UIViewController {

    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    
    var type = ""
    
    var budgetObject:Budget = Budget()
    
    var delegateTimeRanger:TimeRangerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtStartDate.text = budgetObject.startDate ?? ""
        txtEndDate.text = budgetObject.endDate ?? ""
        
        txtStartDate.addTarget(self, action: #selector(pushCalendarStartClick), for: .touchDown)
        
        txtEndDate.addTarget(self, action: #selector(pushCalendarEndClick), for: .touchDown)
       
    }
    
    @objc func pushCalendarStartClick() {
        let vc = UIStoryboard.init(name: "budget", bundle: nil).instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController

        vc.type = type
        vc.key = "Start"
        vc.budgetObject = budgetObject
        vc.delegateCalendar = self
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func pushCalendarEndClick() {
        let vc = UIStoryboard.init(name: "budget", bundle: nil).instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController

        vc.type = type
        vc.key = "End"
        vc.budgetObject = budgetObject
        vc.delegateCalendar = self
        
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func btnBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDoneClick(_ sender: Any) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let startDate = formatter.date(from: budgetObject.startDate ?? "")
        let endDate = formatter.date(from: budgetObject.endDate ?? "")
        
        if (startDate == nil || endDate == nil){
            let alertController = UIAlertController(title: nil, message: "Select full Start and End date", preferredStyle: .alert)
            
                let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
                }
            
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        else if let start = startDate , let end = endDate , start >= end {
            
            let alertController = UIAlertController(title: nil, message: "Start date is less than End date", preferredStyle: .alert)
            
                let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
                }
            
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        else{
            delegateTimeRanger?.fetchDataTimeRanger(budget: budgetObject, type: type)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension TimeRangerViewController : CalendarViewControllerDelegate {
    func fetchDataCalendar(budget: Budget, type: String) {
        self.budgetObject = budget
        self.type = type
        self.txtStartDate.text = budget.startDate
        self.txtEndDate.text = budget.endDate
    }
}


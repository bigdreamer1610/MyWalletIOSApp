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

// Shared dialog box
protocol Dialog {
    func dialogMess(title:String,message:String)
}

class TimeRangerViewController: UIViewController {
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtEndDate: UITextField!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var lblStartDateTitle: UILabel!
    @IBOutlet weak var lblEndDateTitle: UILabel!
    
    var type = ""
    var budgetObject:Budget = Budget()
    var delegateTimeRanger:TimeRangerViewControllerDelegate?
    
    var language = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeLayout()
        txtStartDate.text = budgetObject.startDate ?? ""
        txtEndDate.text = budgetObject.endDate ?? ""
        // txt click
        txtStartDate.addTarget(self, action: #selector(pushCalendarStartClick), for: .touchDown)
        txtEndDate.addTarget(self, action: #selector(pushCalendarEndClick), for: .touchDown)
        // change language
        navigationItem.title = TimeRangerDataString.timeRanger.rawValue.addLocalizableString(str: language)
        btnBack.title = TimeRangerDataString.back.rawValue.addLocalizableString(str: language)
        btnDone.title = TimeRangerDataString.done.rawValue.addLocalizableString(str: language)
        lblStartDateTitle.text = TimeRangerDataString.startingDateUp.rawValue.addLocalizableString(str: language)
        lblEndDateTitle.text = TimeRangerDataString.endDateUp.rawValue.addLocalizableString(str: language)
        txtStartDate.placeholder = TimeRangerDataString.startingDateLow.rawValue.addLocalizableString(str: language)
        txtEndDate.placeholder = TimeRangerDataString.endDateLow.rawValue.addLocalizableString(str: language)
    }
    
    // set image to right textField Start Date and End Date
    func customizeLayout(){
        txtStartDate.setRightImage2(imageName: "arrowright")
        txtEndDate.setRightImage2(imageName: "arrowright")
    }
    
    // click textField Start Date
    @objc func pushCalendarStartClick() {
        let vc = UIStoryboard.init(name: "budget", bundle: nil).instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        // push data Start CalendarViewController
        vc.type = type
        vc.key = TimeRangerDataString.start.rawValue
        vc.budgetObject = budgetObject
        vc.language = language
        vc.delegateCalendar = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // click textField End Date
    @objc func pushCalendarEndClick() {
        let vc = UIStoryboard.init(name: "budget", bundle: nil).instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        // push data End CalendarViewController
        vc.type = type
        vc.key = TimeRangerDataString.end.rawValue
        vc.budgetObject = budgetObject
        vc.language = language
        vc.delegateCalendar = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Button Back click
    @IBAction func btnBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // Button Done click
    @IBAction func btnDoneClick(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let startDate = formatter.date(from: budgetObject.startDate ?? "")
        let endDate = formatter.date(from: budgetObject.endDate ?? "")
        if startDate == nil || endDate == nil{
            self.dialogMess(title: "" , message: TimeRangerDataString.dialogWarningSelectFullStartandEnd.rawValue.addLocalizableString(str: language))
           
        } else if let start = startDate , let end = endDate , start >= end {
            self.dialogMess(title: "" , message: TimeRangerDataString.dialogWarningStartLessThanEnd.rawValue.addLocalizableString(str: language))
            
        } else{
            delegateTimeRanger?.fetchDataTimeRanger(budget: budgetObject, type: type)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: - Get data into CalendarViewControllerDelegate
extension TimeRangerViewController : CalendarViewControllerDelegate {
    func fetchDataCalendar(budget: Budget, type: String) {
        self.budgetObject = budget
        self.type = type
        self.txtStartDate.text = budget.startDate
        self.txtEndDate.text = budget.endDate
    }
}

extension TimeRangerViewController : Dialog {
    func dialogMess(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: TimeRangerDataString.dialogItemOK.rawValue.addLocalizableString(str: language), style: .default) { (_) in
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

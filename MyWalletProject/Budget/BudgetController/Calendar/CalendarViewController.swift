//
//  CalendarViewController.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 9/30/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import FSCalendar

protocol CalendarViewControllerDelegate {
    func fetchDataCalendar(budget:Budget,type:String)
}

class CalendarViewController: UIViewController, FSCalendarDelegate {
    @IBOutlet weak var viewCalendar: FSCalendar!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    
    var type = ""
    var key = ""
    var budgetObject:Budget = Budget()
    var delegateCalendar:CalendarViewControllerDelegate?
    
    var language = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBack.title = TimeRangerDataString.back.rawValue.addLocalizableString(str: language)
        navigationItem.title = TimeRangerDataString.calendar.rawValue.addLocalizableString(str: language)
        viewCalendar.delegate = self
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        let dateFormat = formatter.string(from: date)
        if key == TimeRangerDataString.start.rawValue{
            budgetObject.startDate = dateFormat
        } else if key == TimeRangerDataString.end.rawValue{
            budgetObject.endDate = dateFormat
        }
        delegateCalendar?.fetchDataCalendar(budget: budgetObject, type: type)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}


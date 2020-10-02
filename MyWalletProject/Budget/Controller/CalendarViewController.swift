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
    
    var type = ""
    var key = ""
    
    var budgetObject:Budget = Budget()
    
    var delegateCalendar:CalendarViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCalendar.delegate = self
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        
        let dateFormat = formatter.string(from: date)
        
        if (key == "Start"){
            budgetObject.startDate = dateFormat
        }
        else if (key == "End"){
            budgetObject.endDate = dateFormat
        }
        
        delegateCalendar?.fetchDataCalendar(budget: budgetObject, type: type)
        self.navigationController?.popViewController(animated: true)
    }

}


//
//  CalendarViewController.swift
//  MyWallet
//
//  Created by Hoang Lam on 9/23/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate {

    
    @IBOutlet weak var viewCalendar: FSCalendar!
    
    var type = ""
    var key = ""
    
    var budgetObject:Budget = Budget()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCalendar.delegate = self
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        
        let dateFormat = formatter.string(from: date)
        let dateSecondWith1970 = date.timeIntervalSince1970
        
        // push
        let vc = UIStoryboard.init(name: "Lam", bundle: nil).instantiateViewController(withIdentifier: "TimeRangerViewController") as! TimeRangerViewController
        
        if (key == "Start"){
            budgetObject.startDate = dateFormat
            budgetObject.startDateSecondWith1970 = dateSecondWith1970
        }
        else if (key == "End"){
            budgetObject.endDate = dateFormat
            budgetObject.endDateSecondWith1970 = dateSecondWith1970
        }
        
        vc.type = type
        vc.budgetObject = budgetObject
        
        navigationController?.pushViewController(vc, animated: true)
    }

}

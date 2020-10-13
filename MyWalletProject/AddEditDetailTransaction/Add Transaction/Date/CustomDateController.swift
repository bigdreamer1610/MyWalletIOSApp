//
//  CustomDateController.swift
//  MyWallet
//
//  Created by BAC Vuong Toan (VTI.Intern) on 9/23/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import FSCalendar

protocol SelectDate {
    func setDate(date: String)
}

class CustomDateController: UIViewController {
    var delegate:SelectDate?
    var calendar:FSCalendar!
    var formatter = DateFormatter()
    var customDate = Date()
    
    var language = ChangeLanguage.vietnam.rawValue

    override func viewDidLoad() {
        super.viewDidLoad()
        CreactCalendar()
        navigationItem.title  = TimeRangerDataString.calendar.rawValue.addLocalizableString(str: language)
    }
    
    func CreactCalendar() {
        calendar = FSCalendar(frame: CGRect(x: 0, y: 50, width: self.view.frame.size.width, height: self.view.frame.size.height))
        calendar.scrollDirection = .horizontal
        calendar.scope = .month
        //calendar.select(calendar)
        self.view.addSubview(calendar)
        calendar.delegate = self
        calendar.dataSource = self
    }
}

extension CustomDateController: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        _ = formatter.dateFormat = "dd/MM/yyyy"
        _ = RouterType.add.getVc() as! AddTransactionViewController
        
        delegate?.setDate(date: formatter.string(from: date))
        self.navigationController?.popViewController(animated: true)
    }
    
}


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
    override func viewDidLoad() {
        super.viewDidLoad()
        CreactCalendar()
    }
    
    func CreactCalendar() {
        calendar = FSCalendar(frame: CGRect(x: 0, y: 50, width: self.view.frame.size.width, height: self.view.frame.size.height))
        calendar.scrollDirection = .vertical
        calendar.scope = .month
        calendar.select(customDate)
        self.view.addSubview(calendar)
        calendar.delegate = self
        calendar.dataSource = self
        
    }
    
}
extension CustomDateController: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        var dates = formatter.dateFormat = "dd/MM/yyyy"
        let vc = UIStoryboard.init(name: Constant.detailsTransaction, bundle: nil).instantiateViewController(withIdentifier: "add") as? AddTransactionController
        delegate?.setDate(date: formatter.string(from: date))
        self.navigationController?.popViewController(animated: true)
    }
    
}


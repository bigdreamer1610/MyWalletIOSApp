//
//  CalendarController.swift
//  MyWallet
//
//  Created by Van Thanh on 9/22/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import FSCalendar
import SwiftDate



class CalendarController: UIViewController, FSCalendarDelegate {
    var completionHandler: ((String) -> Void)?
    var textFomat: String?
    var dateLich: String?
    var  dayThis = Date()
    var dayThis1 = ""
    
    
    @IBOutlet weak var vCalendar: FSCalendar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vCalendar.delegate = self
        dayThis1 =  setDate()
        
        // Do any additional setup after loading the view.
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy"
        let formatDate = format.string(from: date)
        var check = checkDay(dayThis: dayThis1, dateEnd: formatDate)
        print(check)
        if check {
            
            print("day la ngay \(formatDate)")
            dateLich = formatDate
            completionHandler?(formatDate)
            self.navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "error", message: "Sự kiện không thể là ngày trong quá khứ ", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func checkDay( dayThis: String , dateEnd: String) -> Bool {
        var checkday1 = false
        let dateFormat = "dd-MM-yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let startDate = dateFormatter.date(from: dayThis)
        let endDate = dateFormatter.date(from: dateEnd)
        
        guard let startDate1 = startDate, let endDate2 = endDate else {
            fatalError("Date Format does not match ⚠️")
        }
        
        if startDate1 <= endDate2 {
            print(checkday1)
            checkday1 = true
        } else if startDate1 > endDate2 {
            print(checkday1)
            checkday1 = false
        }
        return checkday1
        
    }
    func setDate() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy"
        let formatDate = format.string(from: date)
        return formatDate
    }
    
    
    
}

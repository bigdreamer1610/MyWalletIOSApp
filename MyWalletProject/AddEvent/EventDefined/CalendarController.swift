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
    var checkDate = CheckDate()
    var defined = EventDefined()
    var state = 3
    
    
    @IBOutlet weak var vCalendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vCalendar.delegate = self
      
        
        // Do any additional setup after loading the view.
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy"
        let formatDate = format.string(from: date)
        var check = checkDate.checkDate(dateEnd: formatDate)
        if check {
            dateLich = formatDate
            completionHandler?(formatDate)
            self.navigationController?.popViewController(animated: true)
        } else {
           var alert = defined.alert(state: state)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
}

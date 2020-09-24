//
//  CalendarController.swift
//  MyWallet
//
//  Created by Van Thanh on 9/22/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarController: UIViewController, FSCalendarDelegate {
    var completionHandler: ((String) -> Void)?
    var textFomat: String?
    var dateLich: String?

    @IBOutlet weak var vCalendar: FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()
        vCalendar.delegate = self
        

        // Do any additional setup after loading the view.
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
         let formatter = DateFormatter()
               formatter.dateFormat = "dd/MM/yyyy"
               let string = formatter.string(from: date)
               print("day la ngay \(string)")
                dateLich = string
        
        completionHandler?(string)
//
        
        
          self.navigationController?.popViewController(animated: true)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEvent" {
            let date12 = segue.destination as! AddEventController
            date12.txtDate = dateLich
        }
    }

   

}

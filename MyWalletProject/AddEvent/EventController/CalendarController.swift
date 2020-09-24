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

    @IBOutlet weak var vCalendar: FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()
        vCalendar.delegate = self
       // setDate()

        // Do any additional setup after loading the view.
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        
       
        
        if dayThis.year <= date.year {
            if dayThis.month <= date.month {
                if  dayThis.day  <= date.day + 1 && dayThis.month <= date.month && dayThis.year <= date.year {
                     let formatter = DateFormatter()
                                   formatter.dateFormat = "dd/MM/yyyy"
                                let string = formatter.string(from: date)
                                   print("day la ngay \(string)")
                                      dateLich = string
                                      
                                      completionHandler?(string)
                                self.navigationController?.popViewController(animated: true)
                } else {
                     let alert = UIAlertController(title: "error", message: "Mời bạn chọn lại ngày", preferredStyle: UIAlertController.Style.actionSheet)
                                                                     alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                                                                      self.present(alert, animated: true, completion: nil)
                }
                
            } else {
                let alert = UIAlertController(title: "error", message: "Mời bạn chọn lại tháng", preferredStyle: UIAlertController.Style.actionSheet)
                                                 alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                                                  self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "error", message: "Mời bạn chọn lại năm", preferredStyle: UIAlertController.Style.actionSheet)
                                             alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                                              self.present(alert, animated: true, completion: nil)
        }
        
        

        
        
         
        
    }



}

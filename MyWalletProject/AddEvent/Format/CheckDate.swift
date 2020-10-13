//
//  CheckDate.swift
//  MyWalletProject
//
//  Created by Van Thanh on 10/5/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import SwiftDate

class CheckDate: NSObject {
    
    func setDate() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy"
        let formatDate = format.string(from: date)
        return formatDate
    }
    
    // check ngay
    func checkDate(dateEnd: String) -> Bool {
        var checkday1 = false
        let dateFormat = "dd-MM-yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let startDate = dateFormatter.date(from: setDate())
        let endDate = dateFormatter.date(from: dateEnd)
        
        guard let startDate1 = startDate, let endDate2 = endDate else {
            fatalError("Date format does not match! ⚠️")
        }
        
        if startDate1 <= endDate2 {
            checkday1 = true
        } else  {
            checkday1 = false
        }
        return checkday1
        
    }
    
    
    // Ngay con lai
    func stillDate(endDate: String) -> String {
        let now = Date()
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy"
        let nowString = format.string(from: now)
        let dateNowFormater = format.date(from: nowString)
        let date2 = format.date(from: endDate)
        let estimateDay = Calendar.current.dateComponents([.day], from: dateNowFormater ?? now, to: date2! ).day ?? 0
        if estimateDay >= 0 {
            if estimateDay == 1 {
                return String(estimateDay) + " day left"
            } else {
                return String(estimateDay) + " days left"
            }
        } else {
            return "Finished"
        }
       
    }
}

//
//  MyDatabase.swift
//  MyWallet
//
//  Created by THUY Nguyen Duong Thu on 9/21/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

enum Mode: String {
    case transaction = "transaction"
    case category = "income"
    
    func getValue() -> String{
        return self.rawValue
    }
}



class Defined {
    static let defaults = UserDefaults.standard
    static let ref = Database.database().reference()
    static let formatter = NumberFormatter()
    static let dateFormatter = DateFormatter()
    static let calendar = Calendar.current
    
    //MARK: - Convert String to DateComponents
    class func convertToDate(resultDate: String) -> DateComponents {
        let myDate = resultDate
        let date = dateFormatter.date(from: myDate)
        let components = calendar.dateComponents([.day, .month, .year, .weekday], from: date!)
        return components
    }
    
    class func convertStringToDate(str: String) -> Date {
        let date = dateFormatter.date(from: str)!
        return date
    }
    
    
    
}

class Constants {
    static let mode = "mode"
    static let balance = "balance"
    static let userid = "userid"
    static let currentMonth = "currentMonth"
    static let currentYear = "currentYear"
    static let currentDate = "currentDate"
    //MARK: HEIGHT FOR CELL & HEADER
    static let transactionHeader: CGFloat = 60
    static let categoryHeader: CGFloat = 65
    static let categoryRow: CGFloat = 70
    static let transactionRow: CGFloat = 65
    static let detailCell: CGFloat = 135
    static let menuCell: CGFloat = 60
}

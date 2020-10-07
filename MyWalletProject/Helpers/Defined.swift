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
    
    class func getAllDayArray(allTransactions: [Transaction]) -> [String]{
        var checkArray = [String]()
        //MARK: - Get all distinct date string
        for a in allTransactions {
            var check = false
            for b in checkArray {
                if a.date == b {
                    check = true
                }
            }
            if !check {
                checkArray.append(a.date!)
            }
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "vi_VN")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        //MARK: - Sort date string
        let sortedArray = checkArray.sorted { (first, second) -> Bool in
            dateFormatter.date(from: first)?.compare(dateFormatter.date(from: second)!) == ComparisonResult.orderedDescending
        }
        print("sortedArray: \(sortedArray)")
        return sortedArray
    }
}

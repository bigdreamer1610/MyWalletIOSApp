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
    
    //MARK: - Get all day string array sorted descending
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
        return sortedArray
    }
    
    // Get date model from datecomponents
    class func getDateModel(components: DateComponents) -> DateModel{
        let months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
        let weekdays = ["Sunday","Monday","Tuesday","Wednesday","Thurday","Friday","Saturday"]
        let weekDay = components.weekday!
        let month = components.month!
        let date = components.day!
        let year = components.year!
        let model = DateModel(date: date, month: months[month-1], year: year, weekDay: weekdays[weekDay-1])
        return model
    }
    
    // get all transactions in specific time range
    class func getTransactionbyDate(dateArr: [TransactionDate],allTrans: [Transaction]) -> [Transaction]{
        var list = [Transaction]()
        for day in dateArr {
            for tran in allTrans {
                if tran.date == day.dateString {
                    list.append(tran)
                }
            }
        }
        return list
    }
    
    class func getTransactionDates(dates: [Date]) -> [TransactionDate]{
        var list = [TransactionDate]()
        // sort descending
        let mDates = dates.sorted { (first, second) -> Bool in
            first.compare(second) == ComparisonResult.orderedDescending        }
        Defined.dateFormatter.dateStyle = .short
        for d in mDates {
            let t = TransactionDate(dateString: Defined.dateFormatter.string(from: d), date: d)
            //add into TransactionDate list
            list.append(t)
        }
        return list
    }
    
}

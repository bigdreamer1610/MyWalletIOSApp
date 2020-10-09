//
//  Constant.swift
//  MyWallet
//
//  Created by BAC Vuong Toan (VTI.Intern) on 9/21/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
class Constants {
    static let amount = "amount"
    static let categoryid = "categoryid"
    static let date = "date"
    static let note = "note"
    static let detailsTransaction = "ViewTransaction"
    
    // Event
    static let categoryIdEvent = "categoryid"
    static let nameEvent = "name"
    static let dateEndEvent = "dateEnd"
    static let dateStartEvent = "dateStart"
    static let goalEvent = "goal"
    static let spentEvent = "spent"
    
    // Date format
    let dateFormat = "dd/MM/yyyy"
    
    // Invalid input alert message
    let usernameBlank = "Username can not be blank, please try again!"
    let balanceBlank = "Balance can not be blank, please try again!"
    let dobBlank = "Date of birth can not be blank, please try again!"
    let dobNotMatchFormat = "Date of birth does not match with out format, please try again!"
    let phoneNumberBlank = "Phone number can not be blank, please try again!"
    let phoneNumberContainNumber = "Phone number contains numbers only, please try again!"
    let genderBlank = "Gender can not be blank, please try again!"
    let genderNotMatchFormat = "Gender does not match with our format, please try again!"
    let addressBlank = "Address can not be blank, please try again!"
    let languageBlank = "Language can not be blank, please try again!"
    let languageNotMatchFormat = "Language does not match with our format, please try again!"
    
    
    static let mode = "mode"
    static let balance = "balance"
    static let userid = "userid"
    static let username = "username"
    static let email = "email"
    static let loginStatus = "login"
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
    static let overviewCell: CGFloat = 80
    
}

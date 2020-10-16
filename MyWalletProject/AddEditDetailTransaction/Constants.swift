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
    static let dateFormat = "dd/MM/yyyy"
    
    // API URL
    static let apiUrl = "https://api.currencyfreaks.com/latest?apikey=ae28c3231f23426b80da6acb5bc27c63&symbols=VND,EUR,JPY,KRW,CNY,SGD,AUD,CAD"
    
    // Invalid input alert message
    static let usernameBlank = "Username can not be blank, please try again!"
    static let balanceBlank = "Balance can not be blank, please try again!"
    static let dobBlank = "Date of birth can not be blank, please try again!"
    static let dobNotMatchFormat = "Date of birth does not match with out format, please try again!"
    static let phoneNumberBlank = "Phone number can not be blank, please try again!"
    static let phoneNumberContainNumber = "Phone number contains numbers only, please try again!"
    static let genderBlank = "Gender can not be blank, please try again!"
    static let genderNotMatchFormat = "Gender does not match with our format, please try again!"
    static let addressBlank = "Address can not be blank, please try again!"
    static let languageBlank = "Language can not be blank, please try again!"
    static let languageNotMatchFormat = "Language does not match with our format, please try again!"
    static let categoryNameBlank = "Category name can not be blank, please try again!"
    static let imageBlank = "Please choose an image for your category"
    static let moneyCurrencyBlank = "You might haven't filled in the amount of money you want to exchange, please try again!"
    static let billNotScan = "You might haven't scanned your bill yet, please try again!"
    
    // alert message
    static let alertDeleteWarning = "DO YOU REALLY WANT TO DELETE IT?"
    static let alertDeleteMessage = "You're about to delete this category, all of your transaction, budget in this category will be lost!"
    static let alertSuccessAddCategory = "Your category has been successfully added!"
    static let alertSuccessEditCategory = "Your category has been successfully edited!"
    static let alertSuccessSaveBill = "Your transaction has successfully been saved!"
    static let alertSuccessInfomationUpdate = "Your information has successfully been updated"
    
    // alert titles and buttons name
    static let alertInvalidInputTitle = "INVALID INPUT"
    static let alertInvalidCategoryTitle = "INVALID CATEGORY"
    static let alertInvalidActionTitle = "INVALID ACTION"
    static let alertInvalidTransactionTitle = "INVALID TRANSACTION"
    static let alertSuccessTitle = "SUCCESS"
    static let alertButtonOk = "OK"
    static let alertButtonCancel = "Cancel"
    static let alertButtonDelete = "Delete"
    
    // Screen title
    static let information = "Information"
    static let categories = "Categories"
    static let addCategory = "Add category"
    static let editCategory = "Edit category"
    static let currencyExchange = "Currencies Exchange"
    static let travelMode = "Travel Mode"
    static let billScanner = "Bill Scanner"
    
    static let mode = "mode"
    static let balance = "balance"
    static let userid = "userid"
    static let username = "username"
    static let email = "email"
    static let loginStatus = "login"
    static let currentMonth = "currentMonth"
    static let currentYear = "currentYear"
    static let currentDate = "currentDate"
    
    //report
    static let income = "Income"
    static let expense = "Expense"
    static let done = "Done"
    static let other = "Other"
    static let netIncome = "Net Income"
    
    //travel mode
    static let travelState = "travelMode"
    static let eventTravelId = "eventTravelId"
    static let eventTravelImage = "eventTravelImage"
    static let eventTravelName = "eventTravelName"
    //MARK: HEIGHT FOR CELL & HEADER
    static let transactionHeader: CGFloat = 60
    static let categoryHeader: CGFloat = 65
    static let categoryRow: CGFloat = 70
    static let transactionRow: CGFloat = 65
    static let detailCell: CGFloat = 135
    static let menuCell: CGFloat = 60
    static let overviewCell: CGFloat = 80
    static let detailPCCell: CGFloat = 80
    
    // MARK: Budget Detail
    static let budgetCateName = "budgetCateName"
    static let budgetStartDate = "budgetStartDate"
    static let budgetEndDate = "budgetEndDate"
}

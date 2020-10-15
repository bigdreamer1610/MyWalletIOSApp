//
//  ApiFirebase.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/13/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

class FirebasePath {
//    static var transaction = "Account/\(Defined.defaults.string(forKey: Constants.userid) ?? "")/transaction"
//    static var expense = "Account/\(Defined.defaults.string(forKey: Constants.userid) ?? "")/transaction/expense"
//    static var income = "Account/\(Defined.defaults.string(forKey: Constants.userid) ?? "")/transaction/income"
//    static var information = "Account/\(Defined.defaults.string(forKey: Constants.userid) ?? "")/information"
//    static var balance = "Account/\(Defined.defaults.string(forKey: Constants.userid) ?? "")/information/balance"
//    static var budget = "Account/\(Defined.defaults.string(forKey: Constants.userid) ?? "")/budget"
//    static var event = "Account/\(Defined.defaults.string(forKey: Constants.userid) ?? "")/event"
//    static var category = "Category"
//    static var cateExpense = "Category/expense"
//    static var cateIncome = "Category/income"
//    static var imagelibrary = "ImageLibrary"
    
    static var transaction = "Account/userid1/transaction"
    static var expense = "Account/userid1/transaction/expense"
    static var income = "Account/userid1/transaction/income"
    static var information = "Account/userid1/information"
    static var balance = "Account/userid1/information/balance"
    static var budget = "Account/userid1/budget"
    static var event = "Account/userid1/event"
    static var category = "Category"
    static var cateExpense = "Category/expense"
    static var cateIncome = "Category/income"
    static var imagelibrary = "ImageLibrary"
}

enum Path {
    case transaction
    case expense
    case income
    case information
    case balance
    case budget
    case event
    case category
    case cateExpense
    case cateIncome
    case imageLibrary
}

extension Path {
    func getPath() -> String {
        var path = ""
        var userid = Defined.defaults.string(forKey: Constants.userid) ?? ""
        switch self {
        case .transaction:
            path = "Account/\(userid)/transaction"
            return path
        case .expense:
            path = "Account/\(userid)/transaction/expense"
            return path
        case .income:
            path = "Account/\(userid)/transaction/income"
            return path
        case .information:
            path = "Account/\(userid)/information"
            return path
        case .balance:
            path = "Account/\(userid)/information/balance"
            return path
        case .budget:
            path = "Account/\(userid)/budget"
            return path
        case .event:
            path = "Account/\(userid)/event"
            return path
        case .category:
            path = "Category"
            return path
        case .cateExpense:
            path = "Category/expense"
            return path
        case .cateIncome:
            path = "Category/income"
            return path
        case .imageLibrary:
            path = "ImageLibrary"
            return path
    }
}
}

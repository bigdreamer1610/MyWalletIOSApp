//
//  SumAmout.swift
//  MyWalletProject
//
//  Created by Nguyen Thi Huong on 10/8/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

struct SumByCate {
    var category: String
    var amount: Int
}

struct SumInfo {
    var sumIncome: Int
    var sumExpense: Int
    var netIncome: Int
    var date: String
    var incomeArray: [Transaction]
    var expenseArray: [Transaction]
    var categories: [Category]
}

struct SumArr {
    var sum: Int
    var sumByCategory: [SumByCate]
    var transations: [Transaction]
    var date: String
}

struct SumForPieChart {
    var sumIncome: Int
    var sumExpense: Int
    var sumByCateIncome: [SumByCate]
    var sumByCateExpense: [SumByCate]
}

struct DetailPC {
    var state: State?
    var transactions: [Transaction]
    var categoryImage: String
    var sumByCategory: Int
    var category: String
    var date: String
}

struct DetailDayPC {
    var imageName: String
    var category: String
    var money: Int
    var date: String
}

struct DetailDayPCByCate {
    var day: String
    var date: String
    var amount: Int
    var note: String
}

struct DetailDaySBC {
    var sumIncome: Int
    var sumExpense: Int
    var incomeArray: [Transaction]
    var expenseArray: [Transaction]
    var date: String
    var categories: [Category]
}

struct DetailDaySBCCell {
    var date: String
    var day: String
    var amount: Int
    var longDate: String
}

struct DetailSBCByDate {
    var category: String
    var amount: Int
    var note: String
    var imageName: String
}

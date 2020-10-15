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

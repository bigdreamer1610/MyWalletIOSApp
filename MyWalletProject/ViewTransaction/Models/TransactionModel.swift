//
//  TransactionModel.swift
//  MyWallet
//
//  Created by THUY Nguyen Duong Thu on 9/25/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import Foundation

struct BottomMenu {
    var icon: String
    var title: String
}

//MARK: - Struct for cell table view
//MARK: --TRANSACTION VIEW MODE
struct TransactionHeader {
    var dateModel: DateModel
    var amount: Int
}

struct TransactionItem {
    var id: String
    var categoryName: String
    var note: String? = nil
    var amount: Int
    var iconImage: String
    var type: String
}

struct TransactionSection {
    var header: TransactionHeader
    var items: [TransactionItem]
}

//MARK: - CATEGORY VIEWMODE
struct CategoryHeader {
    var categoryName: String
    var noOfTransactions: Int
    var amount: Int
    var icon: String
}

struct CategoryItem {
    var id: String
    var dateModel: DateModel
    var amount: Int
    var type: String
    var note: String? = ""
}

struct CategorySection {
    var header: CategoryHeader
    var items: [CategoryItem]
}

struct DateModel {
    var date: Int
    var month: String
    var year: Int
    var weekDay: String
}

struct TransactionDate {
    var dateString: String
    var date: Date
}

//Detail cell

struct DetailInfo {
    var opening: Int
    var ending: Int
}

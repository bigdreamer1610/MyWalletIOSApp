//
//  Transaction.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 9/23/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

struct Transaction {
    var id: String? = nil
    var transactionType: String? = nil
    var amount: Int? = nil
    var categoryid: String? = nil
    var date: String? = nil
    var note: String? = nil
    var eventid: String? = nil
    //MARK: Bỏ budgetid
    //var budgetid: String? = nil
}

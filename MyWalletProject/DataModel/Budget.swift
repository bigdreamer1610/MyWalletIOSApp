//
//  Budget.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 9/23/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

struct Budget: Codable {
    var id: Int? = nil
    var categoryId:String? = nil
    var categoryName: String? = nil
    var categoryImage: String? = nil
    var transactionType: String? = nil
    var amount: Int? = nil
    var startDate: String? = nil
    var endDate: String? = nil
}

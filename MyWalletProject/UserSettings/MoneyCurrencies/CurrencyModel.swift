//
//  CurrencyModel.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 9/24/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

// MARK: - Struct for nested JSON from API call
struct CurrencyData: Codable {
    var date: String
    var base: String
    var rates: Rate
}
struct Rate: Codable {
    var VND: String
    var EUR: String
    var JPY: String
    var KRW: String
    var CNY: String
    var SGD: String
    var AUD: String
    var CAD: String
}

// MARK: - Result struct after exchange
struct ResultData {
    var USD: Double
    var EUR: Double
    var JPY: Double
    var KRW: Double
    var CNY: Double
    var SGD: Double
    var AUD: Double
    var CAD: Double
}

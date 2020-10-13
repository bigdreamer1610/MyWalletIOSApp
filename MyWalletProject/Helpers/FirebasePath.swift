//
//  ApiFirebase.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/13/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

struct FirebasePath {
    static let transaction = "Account/\(Defined.defaults.string(forKey: Constants.userid)!)/transaction"
    static let information = "Account/\(Defined.defaults.string(forKey: Constants.userid)!)/information"
    static let budget = "Account/\(Defined.defaults.string(forKey: Constants.userid)!)/budget"
    static let event = "Account/\(Defined.defaults.string(forKey: Constants.userid)!)/event"
    static let category = "Category"
    static let imagelibrary = "ImageLibrary"
}

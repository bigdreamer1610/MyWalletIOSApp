//
//  MyDatabase.swift
//  MyWallet
//
//  Created by THUY Nguyen Duong Thu on 9/21/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Defined {
    static let defaults = UserDefaults.standard
    static let ref = Database.database().reference()
    static let formatter = NumberFormatter()
}

class Constants {
    static let mode = "mode"
    static let balance = "balance"
    static let userid = "userid"
    //MARK: HEIGHT FOR CELL & HEADER
    static let transactionHeader: CGFloat = 60
    static let categoryHeader: CGFloat = 65
    static let categoryRow: CGFloat = 70
    static let transactionRow: CGFloat = 65
    static let detailCell: CGFloat = 135
    static let menuCell: CGFloat = 60
}

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

struct MyDatabase {
    static let defaults = UserDefaults.standard
    static let ref = Database.database().reference()
}

class Key {
    static let mode = "mode"
    static let balance = "balances"
    static let userid = "userid"
}

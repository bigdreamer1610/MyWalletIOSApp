//
//  BaseProtocol.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/13/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

protocol BaseProtocol: class {
    func showError(message: String)
    func responseDataCategories(cate: [Category])
}

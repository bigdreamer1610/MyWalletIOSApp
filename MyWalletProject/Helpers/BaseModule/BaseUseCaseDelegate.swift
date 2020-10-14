//
//  BaseUseCaseDelegate.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/14/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

protocol BaseUseCaseDelegate: class {
    func responseDataCategories(cate: [Category])
}

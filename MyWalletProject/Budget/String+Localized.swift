//
//  String+Localized.swift
//  MyWalletProject
//
//  Created by Hoang Tung Lam on 10/9/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

extension String {
    func addLocalizableString(str:String) -> String {
        let path = Bundle.main.path(forResource: str, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

enum ChangeLanguage : String {
    case english = "en"
    case vietnam = "vi"
}


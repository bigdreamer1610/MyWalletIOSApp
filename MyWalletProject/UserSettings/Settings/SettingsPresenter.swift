//
//  SettingsPresenter.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 9/23/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

enum Gender: String {
    case male = "Male"
    case female = "Female"
    case others = "Others"
}

enum Language: String {
    case vietnamese = "Vietnamese"
    case english = "English"
}

protocol SettingsPresenterDelegate {
    func showAlertMessage(_ message: String, _ state: Bool)
}

class SettingsPresenter {
    
    var delegate: SettingsPresenterDelegate?
    var usecase: SettingsUseCase?
    
    init(delegate: SettingsPresenterDelegate, usecase: SettingsUseCase) {
        self.delegate = delegate
        self.usecase = usecase
    }
    
    func validateInput(_ user: Account) {
        var message = ""
        var state = false
        
        let constant = Constant()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = constant.dateFormat
        
        // MARK: - Handle invalid cases
        // Username field
        if let name = user.name, name == "" {
            message = constant.usernameBlank
        }
        // Balance field
        else if let balance =  user.balance, balance == -1 {
            message = constant.balanceBlank
        }
        // Date of birth field
        else if let dob = user.dateOfBirth, dob == "" {
            message = constant.dobBlank
        } else if let dob = user.dateOfBirth, dateFormatter.date(from: dob) == nil {
            message = constant.dobNotMatchFormat
        }
        // Phone number field
        else if let phone = user.phoneNumber, phone == "" {
            message = constant.phoneNumberBlank
        } else if let phone = user.phoneNumber, !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: phone)) {
            message = constant.phoneNumberContainNumber
        }
        // Gender field
        else if let gender = user.gender, gender == "" {
            message = constant.genderBlank
        } else if let gender = user.gender, gender != Gender.male.rawValue, gender != Gender.female.rawValue, gender != Gender.others.rawValue {
            message = constant.genderNotMatchFormat
        }
        // Address field
        else if let address = user.address, address == "" {
            message = constant.addressBlank
        }
        // Language field
        else if let language = user.language, language == "" {
            message = constant.languageBlank
        } else if let language = user.language, language != Language.english.rawValue, language != Language.vietnamese.rawValue {
            message = constant.languageNotMatchFormat
        }
        else {
            // Input passes all validation
            state = true
            usecase?.saveUserInfoToDB(user)
        }

        delegate?.showAlertMessage(message, state)
    }
}

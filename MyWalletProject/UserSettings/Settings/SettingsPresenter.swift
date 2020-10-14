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
    func setupForViews(_ user: Account)
}

class SettingsPresenter {
    
    var delegate: SettingsPresenterDelegate?
    var usecase: SettingsUseCase?
    
    init(delegate: SettingsPresenterDelegate, usecase: SettingsUseCase) {
        self.delegate = delegate
        self.usecase = usecase
        self.usecase?.delegate = self
    }
    
    func requestUserInfo() {
        usecase?.getUserInfoFromDB()
    }
    
    func validateInput(_ user: Account) {
        var message = ""
        var state = false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormat
        
        // MARK: - Handle invalid cases
        // Username field
        if let name = user.name, name == "" {
            message = Constants.usernameBlank
        }
        // Balance field
        else if user.balance == nil {
            message = Constants.balanceBlank
        }
        // Date of birth field
        else if let dob = user.dateOfBirth, dob == "" {
            message = Constants.dobBlank
        } else if let dob = user.dateOfBirth, dateFormatter.date(from: dob) == nil {
            message = Constants.dobNotMatchFormat
        }
        // Phone number field
        else if let phone = user.phoneNumber, phone == "" {
            message = Constants.phoneNumberBlank
        } else if let phone = user.phoneNumber, !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: phone)) {
            message = Constants.phoneNumberContainNumber
        }
        // Gender field
        else if let gender = user.gender, gender == "" {
            message = Constants.genderBlank
        } else if let gender = user.gender, gender != Gender.male.rawValue, gender != Gender.female.rawValue, gender != Gender.others.rawValue {
            message = Constants.genderNotMatchFormat
        }
        // Address field
        else if let address = user.address, address == "" {
            message = Constants.addressBlank
        }
        // Language field
        else if let language = user.language, language == "" {
            message = Constants.languageBlank
        } else if let language = user.language, language != Language.english.rawValue, language != Language.vietnamese.rawValue {
            message = Constants.languageNotMatchFormat
        }
        else {
            // Input passes all validation
            state = true
            usecase?.saveUserInfoToDB(user)
        }

        delegate?.showAlertMessage(message, state)
    }
}

extension SettingsPresenter: SettingsUseCaseDelegate {
    func responseData(_ user: Account) {
        delegate?.setupForViews(user)
    }
}

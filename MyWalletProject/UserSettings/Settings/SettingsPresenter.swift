//
//  SettingsPresenter.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 9/23/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

class SettingsPresenter {
    
    var viewDelegate: SettingsViewControllerProtocol?
    var usecase: SettingsUseCase = SettingsUseCase()
    
    func validateInput(_ user: Account) {
        var message = ""
        var state = false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        // MARK: - Handle invalid cases
        // Username field
        if user.name! == "" {
            message = "Username can not be blank, please try again!"
        }
        // Balance field
        else if user.balance! == -1 {
            message = "Balance can not be blank, please try again!"
        }
        // Date of birth field
        else if user.dateOfBirth! == "" {
            message = "Date of birth can not be blank, please try again!"
        } else if dateFormatter.date(from: user.dateOfBirth!) == nil {
            message = "Date of birth does not match with out format, please try again!"
        }
        // Phone number field
        else if user.phoneNumber! == "" {
            message = "Phone number can not be blank, please try again!"
        } else if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: user.phoneNumber!)) {
            message = "Phone number contains numbers only, please try again!"
        }
        // Gender field
        else if user.gender! == "" {
            message = "Gender can not be blank, please try again!"
        } else if user.gender! != "Male" && user.gender! != "Female" && user.gender! != "Others" {
            message = "Gender does not match with our format, please try again!"
        }
        // Address field
        else if user.address! == "" {
            message = "Address can not be blank, please try again!"
        }
        // Language field
        else if user.language! == "" {
            message = "Language can not be blank, please try again!"
        } else if user.language! != "English" && user.language! != "Vietnamese" {
            message = "Language does not match with our format, please try again!"
        }
        else {
            // Input passes all validation
            state = true
        }

        viewDelegate?.showAlert(message, state)
    }
    
    func saveUserInfo(_ user: Account) {
        usecase.saveUserInfoToDB(user)
    }
}

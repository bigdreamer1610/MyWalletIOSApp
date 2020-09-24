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
    
    func validateInput(_ user: Account) {
        var message = ""
        var state = false
        
        // MARK: - Handle invalid cases
        // Username field
        if user.name! == "" {
            message = "Username can not be blank, please try again!"
            state = false
        } else {
            state = true
        }
        
        // Balance field
        if user.balance! == -1 {
            message = "Balance can not be blank, please try again!"
            state = false
        } else {
            state = true
        }
        
        // Date of birth field
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if user.dateOfBirth! == "" {
            message = "Date of birth can not be blank, please try again!"
            state = false
        } else if dateFormatter.date(from: user.dateOfBirth!) == nil {
            message = "Date of birth does not match with out format, please try again!"
            state = false
        } else {
            state = true
        }
        
        // Phone number field
        if user.phoneNumber! == "" {
            message = "Phone number can not be blank, please try again!"
            state = false
        } else if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: user.phoneNumber!)) {
            message = "Phone number contains numbers only, please try again!"
            state = false
        } else {
            state = true
        }
        
        // Gender field
        if user.gender! == "" {
            message = "Gender can not be blank, please try again!"
            state = false
        } else if user.gender! != "Male" && user.gender! != "Female" && user.gender! != "Others" {
            message = "Gender does not match with our format, please try again!"
            state = false
        } else {
            state = true
        }
        
        // Address field
        if user.address! == "" {
            message = "Address can not be blank, please try again!"
            state = false
        } else {
            state = true
        }
        
        // Language field
        if user.language! == "" {
            message = "Language can not be blank, please try again!"
            state = false
        } else if user.language! != "English" && user.language! != "Vietnamese" {
            message = "Language does not match with our format, please try again!"
            state = false
        } else {
            state = true
        }
        
        viewDelegate?.showAlert(message, state)
    }
}

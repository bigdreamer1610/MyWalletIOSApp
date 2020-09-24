//
//  SettingsPresenter.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 9/23/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation

class SettingsPresenter {
    
    func validateInput(_ user: Account) -> (message: String, state: Bool) {
        var message = ""
        var state = false
        
        // MARK: - Handle invalid cases
        // Username field
        if user.name! == "" {
            message = "Username can not be blank, please try again!"
            state = false
        }
        
        // Username field
        if user.balance! == -1 {
            message = "Username can not be blank, please try again!"
            state = false
        }
        
        return (message: message, state: state)
    }
}

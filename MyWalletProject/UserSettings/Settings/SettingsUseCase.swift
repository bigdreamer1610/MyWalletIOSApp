//
//  SettingsUseCase.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 9/23/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol SettingsUseCaseDelegate {
    func saveUserInfoToDB(_ user: Account)
}

class SettingsUseCase {
    var delegate: SettingsUseCaseDelegate?
}

extension SettingsUseCase: SettingsUseCaseDelegate {
    func saveUserInfoToDB(_ user: Account) {
        let userInfo = [
            "name": user.name!,
            "email": user.email!,
            "balance": user.balance!,
            "dateOfBirth": user.dateOfBirth!,
            "phoneNumber": user.phoneNumber!,
            "address": user.address!,
            "gender": user.gender!,
            "language": user.language!] as [String : Any]

        Defined.ref.child("Account").child("userid1").child("information").setValue(userInfo, withCompletionBlock: {
            error, ref in
            if error == nil {}
            else {}
        })
    }
}


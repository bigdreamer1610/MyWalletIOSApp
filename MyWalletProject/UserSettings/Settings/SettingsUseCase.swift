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
    func responseData(_ user: Account)
}

class SettingsUseCase {
    var delegate: SettingsUseCaseDelegate?
}

extension SettingsUseCase {
    // MARK: - Save user info to DB
    func saveUserInfoToDB(_ user: Account, _ userId: String) {
        let userInfo = [
            "name": user.name!,
            "email": user.email!,
            "balance": user.balance!,
            "dateOfBirth": user.dateOfBirth!,
            "phoneNumber": user.phoneNumber!,
            "address": user.address!,
            "gender": user.gender!,
            "language": user.language!] as [String : Any]

        Defined.ref.child("Account").child(userId).child("information").setValue(userInfo, withCompletionBlock: {
            error, ref in
            if error == nil {}
            else {}
        })
    }
    
    // MARK: - Get user info from DB to display in view
    func getUserInfoFromDB(_ userId: String) {
        var userInfo: Account = Account()
        
        Defined.ref.child("Account").child(userId).child("information").observeSingleEvent(of: .value, with: { snapshot in
            guard let dict = snapshot.value as? NSDictionary else {
                return
            }
            
            userInfo.address = dict["address"] as? String
            userInfo.balance = dict["balance"] as? Int
            userInfo.dateOfBirth = dict["dateOfBirth"] as? String
            userInfo.email = dict["email"] as? String
            userInfo.gender = dict["gender"] as? String
            userInfo.language = dict["language"] as? String
            userInfo.name = dict["name"] as? String
            userInfo.phoneNumber = dict["phoneNumber"] as? String
            
            self.delegate?.responseData(userInfo)
        })
    }
}


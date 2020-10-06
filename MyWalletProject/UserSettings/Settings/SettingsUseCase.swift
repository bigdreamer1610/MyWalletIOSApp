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
    
    // MARK: - Dang bi loi khong biet vi sao!!!!!!
    func getUserInfoFromDB(_ userId: String) {
        var user: Account = Account()
        Defined.ref.child("Account").child("userid1").child("information").observe(.value, with: { snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    print("Error")
                    return
                }
                
                user.address = dict["address"] as? String
                user.balance = dict["balance"] as? Int
                user.dateOfBirth = dict["dateOfBirth"] as? String
                user.email = dict["email"] as? String
                user.gender = dict["gender"] as? String
                user.language = dict["language"] as? String
                user.name = dict["name"] as? String
                user.phoneNumber = dict["phoneNumber"] as? String
            }
            
            self.delegate?.responseData(user)
        })
    }
}


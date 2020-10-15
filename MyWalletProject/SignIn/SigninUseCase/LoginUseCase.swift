//
//  LoginUseCase.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 9/30/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
import Firebase

class LoginUseCase {
//    var ref = Database.database().reference()
    
    var loginController:LoginViewController = LoginViewController()

    //MARK: - Check account exist
    func checkAccountExist(id : String , name :String , email : String){
        Defined.ref.child("Account").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(id){
                return
            } else{
                let profile = [
                    "name" : name,
                    "email" : email,
                    "balance" : 0
                    ] as [String : Any]
                
                Defined.ref.child("Account").child(String(id)).child("information").setValue(profile,withCompletionBlock: { error , ref in
                    if error == nil {
                    }else{
                    }
                } )
            }
        })
    }
}


//
//  LoginUseCase.swift
//  MyWallet
//
//  Created by Hoang Lam on 9/28/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import Foundation
import  Firebase

class LoginUseCase {
    var ref = Database.database().reference()
    
    //MARK: - Save account to DB

    func createProfileAccountFirebase(id : String , name : String , email : String){
        let profile = [
            "name" : name,
            "email" : email,
            "balance" : 0
            ] as [String : Any]
        
        ref.child("Account").child(String(id)).child("information").setValue(profile,withCompletionBlock: { error , ref in
            if error == nil {
            }else{}
        } )
        
    }
    
    //MARK: Check account da ton tai chua
    func checkAccountExist(id : String , name :String , email : String){
        ref.child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(id){
                print("account exist")
                
            }else{
                self.createProfileAccountFirebase(id: id, name: name ,email: email)
                print("do create exist")
            }
        })
        
    }

}

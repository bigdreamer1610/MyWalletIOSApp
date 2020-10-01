//
//  LoginPresenterGG.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 9/30/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
import GoogleSignIn

//MARK: - Login Google
extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        let currentUser = GIDSignIn.sharedInstance()?.currentUser
        
        let id = currentUser?.userID
        let username = currentUser?.profile.name
        let email = currentUser?.profile.email
    
        LoginUseCase().checkAccountExist(id: id!, name: username! , email: email!)
    
        UserDefaults.standard.set(id, forKey: "idUser")
        UserDefaults.standard.set(username, forKey: "nameUser")
        UserDefaults.standard.set(email, forKey: "emailUser")
        UserDefaults.standard.set(true, forKey: "login")
        
        nextCategory(viewController: self)
        
    }
}


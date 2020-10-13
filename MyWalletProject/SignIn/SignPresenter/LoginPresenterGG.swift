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
        
        if let id = id , let username = username , let email = email {
            LoginUseCase().checkAccountExist(id: id, name: username , email: email)
            Defined.defaults.set(id, forKey: Constants.userid)
            Defined.defaults.set(username, forKey: Constants.username)
            Defined.defaults.set(email, forKey: Constants.email)
            Defined.defaults.set(true, forKey: Constants.loginStatus)
            nextCategory(viewController: self)
        }
        else{
            return
        }
    }
}


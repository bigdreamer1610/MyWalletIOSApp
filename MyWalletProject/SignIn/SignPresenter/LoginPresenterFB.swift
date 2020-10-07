//
//  LoginPresenterFB.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 9/30/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
import FBSDKLoginKit


class LoginFbPresenter {
    
    var parentViewController:UIViewController?
    
    //MARK: - Login facebook
    func fbLogin(viewController:UIViewController) {
        parentViewController = viewController
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [ "public_profile", "email"], viewController: viewController, completion: { loginResult in
            switch loginResult {
                
            case .success(granted: _, declined: _, token: _):
                self.getFBUserData()
                
            case .cancelled:
                print("User Canceled login process")
                
            case .failed(let error):
                print(error)
            }
        })
    }
    
    //MARK: - Get data data fb
    func getFBUserData() {
        if ((AccessToken.current) != nil) {
            
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, gender"]).start(completionHandler: { (connection, result, error) -> Void in
                
                // nếu không xảy ra lỗi
                if (error == nil){
                    
                    
                    let dict = result as! [String : AnyObject]
                    
                    let picutreDic = dict as NSDictionary
                    
                    // id
                    let idOfUser = picutreDic.object(forKey: "id") as! String
                    // name
                    let nameOfUser = picutreDic.object(forKey: "name") as! String
                    // email
                    var tmpEmailAdd = ""
                    
                    if let emailAddress = picutreDic.object(forKey: "email") {
                        tmpEmailAdd = emailAddress as! String
                        print(tmpEmailAdd)
                    }
                    else {
                        var usrName = nameOfUser
                        usrName = usrName.lowercased().replacingOccurrences(of: " ", with: "")
                        tmpEmailAdd = usrName+"@facebook.com"
                    }
                    LoginUseCase().checkAccountExist(id: idOfUser, name: nameOfUser, email: tmpEmailAdd)
                    
                    Defined.defaults.set(idOfUser, forKey: Constants.userid)
                    Defined.defaults.set(nameOfUser, forKey: Constants.username)
                    Defined.defaults.set(tmpEmailAdd, forKey: Constants.email)
                    Defined.defaults.set(true, forKey: Constants.loginStatus)
                    if let controller = self.parentViewController as? LoginViewController {
                        controller.nextCategory(viewController: controller)
                        
                    }
                }
                
                print(error?.localizedDescription as Any)
            })
        }
    }
}


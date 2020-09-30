//
//  LoginViewController.swift
//  MyWallet
//
//  Created by Hoang Lam on 9/21/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import Firebase

protocol LoginViewControllerProtocol {
    func nextToCategoryScreen()
    func fbLogin()
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var btnLoginFacebook: UIButton!
    @IBOutlet weak var btnLoginGoogle: UIButton!
    @IBOutlet weak var btnLoginApple: UIButton!
    
    var ref = Database.database().reference()
    
    var presenter:LoginPresenter = LoginPresenter()
    
    var isLogined:Bool = UserDefaults.standard.bool(forKey: "login")
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnLoginFacebook.layer.borderWidth = 1
        btnLoginFacebook.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btnLoginFacebook.layer.cornerRadius = btnLoginFacebook.bounds.height / 4
        btnLoginGoogle.layer.borderWidth = 1
        btnLoginGoogle.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btnLoginGoogle.layer.cornerRadius = btnLoginGoogle.bounds.height / 4
        btnLoginApple.layer.borderWidth = 1
        btnLoginApple.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btnLoginApple.layer.cornerRadius = btnLoginApple.bounds.height / 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autoLogin()
        
        GIDSignIn.sharedInstance().presentingViewController = self
    }
    
    @IBAction func btnLoginFacebookClick(_ sender: Any) {
        fbLogin()
    }
    
    @IBAction func btnLoginGoogleClick(_ sender: Any) {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    @IBAction func btnLoginAppleClick(_ sender: Any) {
        
    }
    
    func autoLogin(){
        print(isLogined)
        if isLogined == true {
        print("vao auto login")
        nextToCategoryScreen()
        }
    }
    
}

//MARK: aaa
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
        
        nextToCategoryScreen()
        
    }
}

extension LoginViewController: LoginViewControllerProtocol{
    func nextToCategoryScreen(){
        let vc = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "TestLoginViewController") as! TestLoginViewController
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Hàm login FaceBook
    func fbLogin() {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [ "public_profile", "email"], viewController: self, completion: { loginResult in
            switch loginResult {
                
            case .success(granted: _, declined: _, token: _):
                self.presenter.getFBUserData()
                
            case .cancelled:
                print("User Canceled login process")
                
            case .failed(let error):
                print(error)
            }
        })
    }
}

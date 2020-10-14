//
//  LoginViewController.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 9/30/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import Firebase

protocol LoginViewControllerDelegate {
    func nextCategory(viewController:UIViewController)
    func autoLogin()
}


class LoginViewController: UIViewController {
    
    var window: UIWindow?
    @IBOutlet weak var btnLoginFacebook: UIButton!
    @IBOutlet weak var btnLoginGoogle: UIButton!
    
    var isLogined:Bool = UserDefaults.standard.bool(forKey: Constants.loginStatus) ?? false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customizeLayout(buttons: [btnLoginFacebook, btnLoginGoogle])
    }
    
    func customizeLayout(buttons: [UIButton]){
        buttons.forEach { (button) in
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.colorFromHexString(hex: "776d8a").cgColor
            button.layer.cornerRadius = 10
        }
    }
    //MARK: - viewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.colorFromHexString(hex: "f3e6e3")
        autoLogin()
        
        GIDSignIn.sharedInstance().presentingViewController = self
    }
    
    //MARK: - Login facebook click
    @IBAction func btnLoginFacebookClick(_ sender: Any) {
        LoginFbPresenter().fbLogin(viewController: self)
    }
    
    @IBAction func btnLoginGoogleClick(_ sender: Any) {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    
}

extension LoginViewController:LoginViewControllerDelegate{
    func nextCategory(viewController: UIViewController) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let navigationController = UINavigationController(rootViewController: RouterType.tabbar.getVc())
        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
    }
    
    func autoLogin(){
        print(isLogined)
        if isLogined == true {
            nextCategory(viewController: self)
        }
    }
}


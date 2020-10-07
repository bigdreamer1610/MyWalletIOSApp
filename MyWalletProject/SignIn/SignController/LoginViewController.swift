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
    
    var isLogined:Bool = UserDefaults.standard.bool(forKey: "login")
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customizeLayout(buttons: [btnLoginFacebook, btnLoginGoogle])
    }
    
    func customizeLayout(buttons: [UIButton]){
        buttons.forEach { (button) in
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.cornerRadius = 6
        }
    }
    //MARK: - viewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func btnLoginAppleClick(_ sender: Any) {
        
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

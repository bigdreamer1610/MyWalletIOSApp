//
//  AppDelegate.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 9/22/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.makeKeyAndVisible()
//        let navigationController = UINavigationController(rootViewController: RouterType.tabbar.getVc())
//        navigationController.isNavigationBarHidden = true
//        window?.rootViewController = navigationController
        
        
        // google
        GIDSignIn.sharedInstance().clientID = "530496501963-pkmcpemkjme33b511eof2i60mkcsmuus.apps.googleusercontent.com"
        
        // facebook
        FBSDKCoreKit.ApplicationDelegate.shared.application( application,
                                                didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handlerGoogle = GIDSignIn.sharedInstance().handle(url)
        let handledFB = FBSDKCoreKit.ApplicationDelegate.shared.application(
        app,
        open: url,
        sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
        
        return handlerGoogle || handledFB
    }
}


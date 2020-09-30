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
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let tabbar = MainTabViewController.createTabbar()
        let navigationController = UINavigationController(rootViewController: tabbar)
        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.makeKeyAndVisible()
//        let vc = RouterType.viewTransaction.getVc()
//        let navigationController = UINavigationController(rootViewController: vc)
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
    
    

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        ApplicationDelegate.shared.application( UIApplication.shared,
                                                open: url,
                                                sourceApplication: nil,
                                                annotation: [UIApplication.OpenURLOptionsKey.annotation])
        
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}


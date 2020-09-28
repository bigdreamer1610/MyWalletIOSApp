//
//  MainTabViewController.swift
//  IVM
//
//  Created by an.trantuan on 7/2/20.
//  Copyright © 2020 an.trantuan. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMiddleButton()
        self.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // TabBarButton – Setup Middle Button
    func setupMiddleButton() {
        let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - middleButtonRadius, y: -middleButtonRadius/2, width: middleButtonHeight, height: middleButtonHeight))
        middleBtn.setImage(#imageLiteral(resourceName: "add120"), for: .normal)
        middleBtn.layer.cornerRadius = middleButtonRadius
        middleBtn.layer.masksToBounds = true
        //add to the tabbar and add click event
        self.tabBar.addSubview(middleBtn)
        middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)
        self.view.layoutIfNeeded()
    }
    
    // Menu Button Touch Action
    @objc func menuButtonAction(sender: UIButton) {
        let vc = UIStoryboard.init(name: "Thuy", bundle: nil).instantiateViewController(withIdentifier: "BacNavigationController") as! BacNavigationController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true)
    }
    
    class func createTabbar() -> MainTabViewController {
        let tabbar = UIStoryboard(name: "Thuy", bundle: nil).instantiateViewController(withIdentifier: "MainTabViewController") as! MainTabViewController
        let transaction = UIStoryboard(name: "Thuy", bundle: nil).instantiateViewController(withIdentifier: "ViewTransactionController") as! ViewTransactionController
        let report = UIStoryboard(name: "Thuy", bundle: nil).instantiateViewController(withIdentifier: "ViewTransactionController") as! ViewTransactionController
        let scan = UIViewController()
        let planning = UIStoryboard(name: "Thuy", bundle: nil).instantiateViewController(withIdentifier: "ViewTransactionController") as! ViewTransactionController
        let account = UIStoryboard(name: "Thuy", bundle: nil).instantiateViewController(withIdentifier: "ViewTransactionController") as! ViewTransactionController
        
        let homeItem = UITabBarItem(title: "Transactions", image: #imageLiteral(resourceName: "transaction"), tag: 0)
        let home1Item = UITabBarItem(title: "Report", image: #imageLiteral(resourceName: "report"), tag: 1)
        let scanItem = UITabBarItem(title: nil, image: nil, tag: 2)
        let home2Item = UITabBarItem(title: "Planning", image: #imageLiteral(resourceName: "planning"), tag: 3)
        let home3Item = UITabBarItem(title: "Account", image: #imageLiteral(resourceName: "account"), tag: 4)
        
        
        transaction.tabBarItem = homeItem
        report.tabBarItem = home1Item
        scan.tabBarItem = scanItem
        planning.tabBarItem = home2Item
        account.tabBarItem = home3Item
        tabbar.tabBar.isTranslucent = false
        tabbar.viewControllers = [transaction, report,scan, planning, account]
        return tabbar
    }
}

extension MainTabViewController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        viewController.navigationController?.setNavigationBarHidden(true, animated: true)
        //let selected = tabBarController.selectedIndex
        //print("SELECTED INDEX IS : \(selected)")
        return true
    }
}

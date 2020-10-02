//
//  File.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 9/28/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
import UIKit

enum RouterType {
    case transactionDetail(item: TransactionItem, header: TransactionHeader)
    case categoryDetail(item: CategoryItem, header: CategoryHeader)
    case balance
    case add
    case planning
    case budget
    case event
    case tabbar
    case test
    
    //case viewTransaction
}

class AppRouter {
    class func routerTo(from vc: UIViewController,options: UIView.AnimationOptions, duration: TimeInterval, isNaviHidden: Bool){
        if let window = UIApplication.shared.keyWindow {
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.isNavigationBarHidden = isNaviHidden
            window.rootViewController = navigationController
            UIView.transition(with: window, duration: duration, options: options, animations: {}) { (completed) in
                
            }
            window.makeKeyAndVisible()
        }
    }
    
    //    class func setRootView(){
    //        DispatchQueue.main.async {
    //            if let window = UIApplication.shared.keyWindow {
    //                window.rootViewController = nil
    //                let navigationController = UINavigationController(rootViewController: RouterType.viewTransaction.getVc())
    //                navigationController.isNavigationBarHidden = true
    //                window.rootViewController = navigationController
    //                let options: UIView.AnimationOptions = .transitionCrossDissolve
    //                UIView.transition(with: window, duration: 0.3, options: options, animations: {}) { (completed) in
    //
    //                }
    //                window.makeKeyAndVisible()
    //            }
    //        }
    //    }
}
extension RouterType{
    func getVc() -> UIViewController {
        switch self {
        case .transactionDetail(let item, let header):
            let vc = UIStoryboard(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "detail") as! DetailTransactionController
            vc.setUpDataTransactionView(item: item, header: header)
            return vc
        case .categoryDetail(let item, let header):
            let vc = UIStoryboard(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "detail") as! DetailTransactionController
            vc.setUpDataCategoryView(item: item, header: header)
            return vc
        case .balance:
            let vc = UIStoryboard(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "BalanceViewController") as! BalanceViewController
            return vc
        case .add:
            let vc = UIStoryboard(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "add") as! AddTransactionController
            return vc
        case .planning:
            let vc = UIStoryboard(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "planning_vc") as! PlanningViewController
            return vc
        case .budget:
            let vc = UIStoryboard(name: "budget", bundle: nil).instantiateViewController(withIdentifier: "BudgetListViewController") as! BudgetListViewController
            return vc
        case .event:
            let vc = UIStoryboard(name: "AddEvent", bundle: nil).instantiateViewController(withIdentifier: "EventController") as! EventController
            return vc
        case .tabbar:
            let vc = MainTabViewController.createTabbar()
            return vc
        case .test:
            let vc = UIStoryboard(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "transaction") as! TransactionViewController
            let presenter = TransactionPresenter(delegate: vc, usecase: TransactionUseCase())
            vc.setUp(presenter: presenter)
            return vc
            
            //        default:
            //            let vc = UIStoryboard(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "ViewTransactionController") as! ViewTransactionViewController
            //            let presenter = ViewTransactionPresenter(delegate: vc, viewTransUseCase: ViewTransactionUseCase())
            //            vc.setUp(presenter: presenter)
            //            return vc
            
        }
    }
}

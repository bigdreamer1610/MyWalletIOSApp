//
//  File.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 9/28/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import Foundation
import UIKit

enum RouterOption: Int {
    case present = 0
    case push = 1
}

enum RouterType {
    case transactionDetail(item: TransactionItem, header: TransactionHeader)
    case categoryDetail(item: CategoryItem, header: CategoryHeader)
    case balance
    case add
    case planning
    case budget
    case budgetDetail
    case selectCateBudget
    case budgetAddEdit
    case event
    case tabbar
    case test
    case viewTransaction
    case report
    case account
    case planningNavi
    case barChartDetail
    case pieChartDetail
    case dayBarChartDetail
    case budgetTransaction(budgetObject: Budget)
    case eventTransaction(event: Event)
    case selectEvent
    case selectCategory
    case selectDate
    case edit(trans: Transaction, event: Event, cateName: String,cateImage: String)
    
    // Settings and Tools
    case settings
    case categories
    case currencies
    case travelMode
    case billScanner
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
    
    class func routerTo(from vc: UIViewController, router: RouterType, options: RouterOption) {
        switch options {
        case .present:
            let vct = router.getVc()
            vct.modalPresentationStyle = .fullScreen
            vc.present(vct, animated: true, completion: nil)
        default:
            vc.navigationController?.pushViewController(router.getVc(), animated: true)
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
            let vc = UIStoryboard(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "detail") as! DetailTransactionViewController
            let presenter = DetailTransactionPresenter(delegate: vc, usecase: DetailTransactionUseCase())
            vc.setUp(presenter: presenter)
            vc.fetchTransaction(id: item.id)
            vc.setUpDataTransactionView(item: item, header: header)
            return vc
        case .categoryDetail(let item, let header):
            let vc = UIStoryboard(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "detail") as! DetailTransactionViewController
            let presenter = DetailTransactionPresenter(delegate: vc, usecase: DetailTransactionUseCase())
            vc.setUp(presenter: presenter)
            vc.fetchTransaction(id: item.id)
            vc.setUpDataCategoryView(item: item, header: header)
            return vc
        case .balance:
            let vc = UIStoryboard(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "BalanceViewController") as! BalanceViewController
            let presenter = BalancePresenter(usecase: BalanceUseCase())
            vc.setUp(presenter: presenter)
            return vc
        case .add:
            let vc = UIStoryboard(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "add") as! AddTransactionViewController
            let presenter = AddTransactionPresenter(usecase: AddTransactionUseCase())
            vc.setUp(presenter: presenter)
            return vc
        case .planning:
            let vc = UIStoryboard(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "planning_vc") as! PlanningViewController
            return vc
        case .budget:
            let vc = UIStoryboard(name: "budget", bundle: nil).instantiateViewController(withIdentifier: "BudgetListViewController") as! BudgetListViewController
            let presenter = BudgetListPresenter(delegate: vc, budgetlistUseCase: BudgetListUseCase())
            vc.setUp(presenter: presenter)
            return vc
        case .budgetDetail:
            let vc = UIStoryboard(name: "budget", bundle: nil).instantiateViewController(withIdentifier: "BudgetDetailController") as! BudgetDetailController
            let presenter = BudgetDetailPresenter(usecase: BudgetDetailUseCase())
            vc.setUp(presenter: presenter)
            return vc
        case .selectCateBudget:
            let vc = UIStoryboard(name: "budget", bundle: nil).instantiateViewController(withIdentifier: "SelectCategoryViewController") as! SelectCategoryViewController
            let presenter = SelectCategoryBudgetPresenter(delegate: vc, selectCateBudgetUseCase: SelectCategoryBudgetUseCase())
            vc.setUp(presenter: presenter)
            return vc
        case .budgetAddEdit:
            let vc = UIStoryboard(name: "budget", bundle: nil).instantiateViewController(withIdentifier: "TestController") as! BudgetController
            let presenter = BudgetPresenter(delegate: vc, budgetUseCase: BudgetUseCase())
            vc.setUp(presenter: presenter)
            return vc
        case .event:
            let vc = UIStoryboard(name: "AddEvent", bundle: nil).instantiateViewController(withIdentifier: "EventController") as! EventControllerView
            let presenter = EventPresenter(delegate: vc, usecase: EventUseCase())
            vc.setUp(presenter: presenter)
            return vc
        case .tabbar:
            let vc = MainTabViewController.createTabbar()
            return vc
        case .test:
            let vc = UIStoryboard(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "transaction") as! TransactionViewController
            let presenter = TransactionPresenter(delegate: vc, usecase: TransactionUseCase())
            vc.setUp(presenter: presenter)
            return vc
        case .viewTransaction:
            let vc = UIStoryboard(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "transaction_vc") as! ViewTransactionViewController
            let front = UINavigationController(rootViewController: vc)
            let presenter = ViewTransactionPresenter(delegate: vc, usecase: ViewTransactionUseCase())
            vc.setUp(presenter: presenter)
            return front
        case .account:
             let vc = UIStoryboard(name: "UserSettings", bundle: nil).instantiateViewController(withIdentifier: "userSettingsNav") as! UINavigationController
            return vc
        case .report:
             let vc = UIStoryboard(name: "Report", bundle: nil).instantiateViewController(withIdentifier: "ReportViewController") as! ReportViewController
            return vc
        case .planningNavi:
            let vc = UIStoryboard(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "navi_second") as! SecondNavigationController
            return vc
        case .barChartDetail:
            let vc = UIStoryboard.init(name: "Report", bundle: Bundle.main).instantiateViewController(identifier: "detailSBC") as! DetailStackedBarChartVC
            return vc
        case .pieChartDetail:
            let vc = UIStoryboard.init(name: "Report", bundle: Bundle.main).instantiateViewController(identifier: "detailPC") as! DetailPieChartVC
            return vc
        case .dayBarChartDetail:
            let vc = UIStoryboard.init(name: "Report", bundle: Bundle.main).instantiateViewController(identifier: "dayDetailSBC") as! DayDetailSBC
            return vc
        case .budgetTransaction(let budgetObject):
            let vc = UIStoryboard(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "budgetTransaction_vc") as! BudgetTransactionViewController
            vc.setUpBudget(budget: budgetObject)
            let presenter = BudgetTransactionPresenter(delegate: vc, usecase: BudgetTransactionUseCase())
            vc.setUp(presenter: presenter)
            return vc
        case .settings:
            let vc = UIStoryboard.init(name: "UserSettings", bundle: Bundle.main).instantiateViewController(identifier: "settingsVC") as! SettingsViewController
            let presenter = SettingsPresenter(delegate: vc, usecase: SettingsUseCase())
            vc.setupDelegate(presenter: presenter)
            return vc
            
            // MARK: - Settings and Tools
        case .categories:
            let vc = UIStoryboard.init(name: "Categories", bundle: Bundle.main).instantiateViewController(identifier: "settingsCategoryVC") as! ViewCategoryViewController
            let presenter = ViewCategoryPresenter(delegate: vc, usecase: ViewCategoryUseCase())
            vc.setupDelegate(presenter: presenter)
            return vc
        case .currencies:
            let vc = UIStoryboard.init(name: "UserSettings", bundle: Bundle.main).instantiateViewController(identifier: "currencyVC") as! CurrencyViewController
            let presenter = CurrencyPresenter(delegate: vc, usecase: CurrencyUseCase())
            vc.setupDelegate(presenter: presenter)
            return vc
        case .travelMode:
            let vc = UIStoryboard.init(name: "UserSettings", bundle: Bundle.main).instantiateViewController(identifier: "travelModeVC") as! TravelModeViewController
            return vc
        case .billScanner:
            let vc = UIStoryboard.init(name: "ScanBill", bundle: Bundle.main).instantiateViewController(identifier: "scanBillVC") as! ScanBillViewController
            let presenter = ScanBillPresenter(delegate: vc, usecase: ScanBillUseCase())
            vc.setupDelegate(presenter: presenter)
            return vc
            
            
        case .selectEvent:
            let vc = UIStoryboard.init(name: Constants.detailsTransaction, bundle: nil).instantiateViewController(withIdentifier: "selectEvent") as! SelectEventController
            let presenter = SelectEventPresenter(delegate: vc, usecase: SelectEventUserCase())
            vc.setUp(presenter: presenter)
            return vc
        case .selectDate:
            let vc = UIStoryboard.init(name: Constants.detailsTransaction, bundle: nil).instantiateViewController(withIdentifier: "customDate") as! CustomDateController
            return vc
        case .selectCategory:
            let vc = UIStoryboard.init(name: Constants.detailsTransaction, bundle: nil).instantiateViewController(withIdentifier: "selectCategory") as! SelectCategoryController
            return vc
        case .eventTransaction(let event):
            let vc = UIStoryboard.init(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "eventTransaction_vc") as! EventTransactionViewController
            let presenter = EventTransactionPresenter(delegate: vc, eventUseCase: EventTransactionUseCase(), viewTransUseCase: ViewTransactionUseCase())
            vc.setUpData(event: event)
            vc.setUp(presenter: presenter)
            return vc
        case .edit(let trans, let event, let name, let icon):
            let vc = UIStoryboard.init(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "edit") as! EditTransactionViewController
            vc.setUpData(trans: trans, event: event, categoryName: name, categoryImage: icon)
            let presenter = EditTransactionPresenter(usecase: EditTransactionUseCase())
            vc.setUp(presenter: presenter)
            return vc
    }
}
}

//
//  BudgetListViewController.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 9/30/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class BudgetListViewController: UIViewController {
    @IBOutlet weak var tblBudget: UITableView!
    @IBOutlet weak var lblTotalMoney: UILabel!
    
    var refreshControl = UIRefreshControl()
    var budget: Budget?
    var listBudgetCurrent:[Budget] = []
    var listBudgetFinish:[Budget] = []
    var listTransaction:[Transaction] = []
    var totalMoneyCurrent = 0
    var totalMoneyFinish = 0
    var segmentIndex = 0
    var amount = 0
    var time = Date()
    
    var presenter : BudgetListPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        presenter?.getDataBudget()
        tblBudget.dataSource = self
        tblBudget.delegate = self
        let nibName = UINib(nibName: "BudgetCell", bundle: nil)
        tblBudget.register(nibName, forCellReuseIdentifier: "BudgetCell")
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblBudget.addSubview(refreshControl)
        tblBudget.reloadData()
        tblBudget.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblBudget.frame.width, height: 0))
    }
    
    // func refresh table when pull down
    @objc func refresh(_ sender: AnyObject){
        presenter?.getDataBudget()
        tblBudget.reloadData()
        refreshControl.endRefreshing()
    }
    
    // set presenter
    func setUp(presenter: BudgetListPresenter){
        self.presenter = presenter
    }
    
    // click back
    @IBAction func btnBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        //AppRouter.routerTo(from: RouterType.tabbar.getVc(), options: .transitionCrossDissolve, duration: 0.2, isNaviHidden: true)
    }
    
    //click Add
    @IBAction func btnAddClick(_ sender: Any) {
        let vc = RouterType.budgetAddEdit.getVc() as! BudgetController
        vc.type = "Add Budget"
        vc.delegateBudgetController = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // click Segment control
    @IBAction func segmentTime(_ uiSegmentedControl: UISegmentedControl) {
        segmentIndex = uiSegmentedControl.selectedSegmentIndex
        tblBudget.reloadData()
    }
}

// MARK: - TableView Datasource , Delegate
extension BudgetListViewController : UITableViewDataSource , UITableViewDelegate {
    // number of cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.totalMoneyCurrent = 0
        self.totalMoneyFinish = 0
        if segmentIndex == 0{
            totalMoneyFinish = 0
            for budget in self.listBudgetCurrent {
                self.totalMoneyCurrent += budget.amount ?? 0
                self.lblTotalMoney.text = "Total: \(self.totalMoneyCurrent)"
            }
            return listBudgetCurrent.count
        }
        else{
            totalMoneyCurrent = 0
            for budget in self.listBudgetFinish {
                self.totalMoneyFinish += budget.amount ?? 0
                self.lblTotalMoney.text = "Total: \(self.totalMoneyFinish)"
            }
            return listBudgetFinish.count
        }
    }
    
    // set cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetCell", for: indexPath) as! BudgetCell
        DispatchQueue.main.async {
            cell.prgFormCate.layer.cornerRadius = cell.prgFormCate.bounds.height / 2
            cell.prgFormCate.layer.masksToBounds = true
        }
        switch segmentIndex {
        case 0:
            presenter?.getAmountListTransaction(budget: listBudgetCurrent[indexPath.row], listTransaction: listTransaction)
            cell.setLayout(budget: listBudgetCurrent[indexPath.row], spend: amount)
        default:
            presenter?.getAmountListTransaction(budget: listBudgetFinish[indexPath.row], listTransaction: listTransaction)
            cell.setLayout(budget: listBudgetFinish[indexPath.row], spend: amount)
        }
        return cell
    }
    
    // height cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    // click cell table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = RouterType.budgetDetail.getVc() as? BudgetDetailController {
            switch segmentIndex {
            case 0:
                vc.budgetObject = listBudgetCurrent[indexPath.row]
                presenter?.getAmountListTransaction(budget: listBudgetCurrent[indexPath.row], listTransaction: listTransaction)
                vc.spent = amount
            default:
                vc.budgetObject = listBudgetFinish[indexPath.row]
                presenter?.getAmountListTransaction(budget: listBudgetFinish[indexPath.row], listTransaction: listTransaction)
                vc.spent = amount
            }
            vc.delegateBudgetDetail = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - BudgetControllerDelegate
extension BudgetListViewController : BudgetControllerDelegate {
    func reloadDataDetailBudgetintoBudgetController(budget: Budget, spend:Int) {
        presenter?.getDataBudget()
        tblBudget.reloadData()
    }
    
    func reloadDataListBudgetintoBudgetController() {
        presenter?.getDataBudget()
        tblBudget.reloadData()
    }
}

// MARK: - BudgetDetailControllerDelegate
extension BudgetListViewController : BudgetDetailControllerDelegate {
    func reloadDataListBudgetintoBudgetDetailController() {
        presenter?.getDataBudget()
        tblBudget.reloadData()
    }
}

//MARK: - BudgetListPresenterDelegate
extension BudgetListViewController : BudgetListPresenterDelegate{
    
    func getDataListBudgetPresenter(budgetCurrents: [Budget], budgetFinishs: [Budget], transactions: [Transaction]) {
        self.listBudgetCurrent = budgetCurrents
        self.listBudgetFinish = budgetFinishs
        self.listTransaction = transactions
        tblBudget.reloadData()
    }
    
    func getAmount(amount: Int) {
        self.amount = amount
    }
}

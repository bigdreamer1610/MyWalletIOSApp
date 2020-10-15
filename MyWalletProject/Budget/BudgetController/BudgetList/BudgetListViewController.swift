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
    @IBOutlet weak var segmentTime: UISegmentedControl!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var imgNoneData: UIImageView!
    
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
    
    var language = ChangeLanguage.english.rawValue
    
    var presenter : BudgetListPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizableListBudget()
        self.navigationItem.largeTitleDisplayMode = .never
        presenter?.getDataBudget()
        tblBudget.dataSource = self
        tblBudget.delegate = self
        let nibName = UINib(nibName: "BudgetCell", bundle: nil)
        tblBudget.register(nibName, forCellReuseIdentifier: "BudgetCell")
        refreshControl.attributedTitle = NSAttributedString(string: BudgetListDataString.refresh.rawValue.addLocalizableString(str: language))
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblBudget.addSubview(refreshControl)
        tblBudget.reloadData()
        tblBudget.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblBudget.frame.width, height: 0))
        segmentTime.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3929189782, green: 0.4198221317, blue: 0.8705882353, alpha: 1)], for: UIControl.State.selected)
        segmentTime.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getDataBudget()
        tblBudget.reloadData()
    }
    
    // Localizable (change language)
    func localizableListBudget(){
        segmentTime.setTitle(BudgetListDataString.currentlyApplying.rawValue.addLocalizableString(str: language), forSegmentAt: 0)
        segmentTime.setTitle(BudgetListDataString.finish.rawValue.addLocalizableString(str: language), forSegmentAt: 1)
        btnBack.title = BudgetListDataString.back.rawValue.addLocalizableString(str: language)
        navigationItem.title = BudgetListDataString.budgets.rawValue.addLocalizableString(str: language)
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
    }
    
    //click Add
    @IBAction func btnAddClick(_ sender: Any) {
        let vc = RouterType.budgetAddEdit.getVc() as! BudgetController
        vc.type = BudgetAddEditDataString.addBudget.rawValue
        vc.language = language
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
            self.totalMoneyFinish = 0
            for budget in self.listBudgetCurrent {
                self.totalMoneyCurrent += budget.amount ?? 0
            }
            if (self.listBudgetCurrent.count < 1){
                self.imgNoneData.isHidden = false
                self.lblTotalMoney.isHidden = true
            } else {
                self.imgNoneData.isHidden = true
                self.lblTotalMoney.isHidden = false
            }
            self.lblTotalMoney.text = "\(BudgetListDataString.total.rawValue.addLocalizableString(str: language)): \(self.totalMoneyCurrent)"
            return listBudgetCurrent.count
        }
        else{
            self.totalMoneyCurrent = 0
            for budget in self.listBudgetFinish {
                self.totalMoneyFinish += budget.amount ?? 0
            }
            if (self.listBudgetFinish.count < 1){
                self.imgNoneData.isHidden = false
                self.lblTotalMoney.isHidden = true
            } else {
                self.imgNoneData.isHidden = true
                self.lblTotalMoney.isHidden = false
            }
            self.lblTotalMoney.text = "\(BudgetListDataString.total.rawValue.addLocalizableString(str: language)): \(self.totalMoneyFinish)"
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
            cell.setLayout(budget: listBudgetCurrent[indexPath.row], spend: amount, language: language)
        default:
            presenter?.getAmountListTransaction(budget: listBudgetFinish[indexPath.row], listTransaction: listTransaction)
            cell.setLayout(budget: listBudgetFinish[indexPath.row], spend: amount, language: language)
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
                vc.budgetID = listBudgetCurrent[indexPath.row].id!
                vc.language = language
            default:
                vc.budgetID = listBudgetFinish[indexPath.row].id!
                vc.language = language
            }
            navigationController?.pushViewController(vc, animated: true)
        }
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

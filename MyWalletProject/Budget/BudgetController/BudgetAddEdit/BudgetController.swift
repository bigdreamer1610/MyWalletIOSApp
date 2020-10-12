//
//  BudgetController.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 9/30/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Firebase

protocol AddEditBudgetControll {
    func addBudget()
    func editBudget()
    func dialogMess(title:String,message:String)
}

protocol BudgetControllerDelegate {
    func reloadDataListBudgetintoBudgetController()
    func reloadDataDetailBudgetintoBudgetController(budget:Budget , spend:Int)
}

class BudgetController: UIViewController {
    @IBOutlet weak var tblAddBudget: UITableView!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    var presenter : BudgetPresenter?
    var budgetObject:Budget = Budget()
    var newChild = 0
    var listBudgetName:[Budget] = []
    var listTransaction:[Transaction] = []
    var ref = Database.database().reference()
    var type = ""
    var delegateBudgetController:BudgetControllerDelegate?
    var spend = 0
    
    var language = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.getListBudgetName()
        presenter?.getlistTransaction()
        if type == BudgetAddEditDataString.addBudget.rawValue {
            presenter?.getNewId()
            navigationItem.title = type.addLocalizableString(str: language)
        } else if type == BudgetAddEditDataString.editBudget.rawValue {
            navigationItem.title = type.addLocalizableString(str: language)
        }
        // table budget
        tblAddBudget.dataSource = self
        tblAddBudget.delegate = self
        tblAddBudget.register(UINib(nibName: "CateCell", bundle: nil), forCellReuseIdentifier: "CateCell")
        tblAddBudget.register(UINib(nibName: "AmountCell", bundle: nil), forCellReuseIdentifier: "AmountCell")
        tblAddBudget.register(UINib(nibName: "TimeCell", bundle: nil), forCellReuseIdentifier: "TimeCell")
        tblAddBudget.reloadData()
        tblAddBudget.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblAddBudget.bounds.width, height: 0))
        // hiden keyboard when tap background table
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        tblAddBudget.addGestureRecognizer(tapGestureRecognizer)
        // Change language btn back and save
        btnBack.title = BudgetAddEditDataString.back.rawValue.addLocalizableString(str: language)
        btnSave.title = BudgetAddEditDataString.save.rawValue.addLocalizableString(str: language)
    }
    
    // func hide keyboard when tap tableview 
    @objc func hideKeyboard(){
        tblAddBudget.endEditing(true)
    }
    
    func setUp(presenter : BudgetPresenter){
        self.presenter = presenter
    }
    
    // btn save click
    @IBAction func btnSaveClick(_ sender: Any) {
        if(budgetObject.categoryName == "" || budgetObject.startDate == "" || budgetObject.amount == nil){
            self.dialogMess(title: "" , message:BudgetAddEditDataString.dialogWarningChooseEnoughAttributes.rawValue.addLocalizableString(str: language))
            
        } else if let amount = budgetObject.amount , amount > 2000000000{
            self.dialogMess(title: "" , message: BudgetAddEditDataString.dialogWarningAmountLessThanTwoBillions.rawValue.addLocalizableString(str: language))
            
        } else {
            if type == BudgetAddEditDataString.addBudget.rawValue {
                if listBudgetName.count < 1 {
                    addBudget()
                    
                } else{
                    var checkExist = true
                    for budget in listBudgetName {
                        if (budgetObject.categoryName == budget.categoryName){
                            if (budgetObject.startDate == budget.startDate && budgetObject.endDate == budget.endDate){
                                checkExist = false
                            }
                        }
                    }
                    
                    if (checkExist == false){
                        self.dialogMess(title: "" , message: BudgetAddEditDataString.dialogWarningStartAndEndisCoexist.rawValue.addLocalizableString(str: language))
                        
                    }else {
                        addBudget()
                    }
                }
            }
            else if type == BudgetAddEditDataString.editBudget.rawValue {
                var checkExist = true
                
                if let catename = UserDefaults.standard.string(forKey: Constants.budgetCateName), let startdate = UserDefaults.standard.string(forKey: Constants.budgetStartDate) , let endDate = UserDefaults.standard.string(forKey: Constants.budgetEndDate) {
                    listBudgetName = listBudgetName.filter({ $0.categoryName != catename || $0.startDate != startdate || $0.endDate != endDate })
                }
                
                for budget in listBudgetName {
                    if budget.categoryName == budgetObject.categoryName {
                        if budgetObject.startDate == budget.startDate && budgetObject.endDate == budget.endDate {
                            checkExist = false
                        }
                    }
                }
                
                if (checkExist == false){
                    self.dialogMess(title: "" , message: BudgetAddEditDataString.dialogWarningStartAndEndisCoexist.rawValue.addLocalizableString(str: language))
                    
                }else {
                    editBudget()
                }
            }
        }
    }
    
    // btn back click
    @IBAction func btnBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        UserDefaults.standard.removeObject(forKey: Constants.budgetCateName)
        UserDefaults.standard.removeObject(forKey: Constants.budgetStartDate)
        UserDefaults.standard.removeObject(forKey: Constants.budgetEndDate)
    }
}

// MARK: - table datasource , delegate
extension BudgetController: UITableViewDataSource , UITableViewDelegate {
    
    // number of cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    // set cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CateCell", for: indexPath) as? CateCell {
                cell.imgCate.image = UIImage(named: budgetObject.categoryImage ?? "")
                if budgetObject.categoryName != nil {
                    cell.lblCateName.text = budgetObject.categoryName ?? ""
                    cell.lblCateName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    
                }else{
                    cell.lblCateName.text = BudgetAddEditDataString.selectCategory.rawValue.addLocalizableString(str: language)
                    cell.lblCateName.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                }
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AmountCell", for: indexPath) as? AmountCell {
                cell.lblAmount.placeholder = BudgetAddEditDataString.inputAmount.rawValue.addLocalizableString(str: language)
                if budgetObject.amount != nil {
                    cell.lblAmount.text = "\(budgetObject.amount!)"
                    
                }else{
                    cell.lblAmount.text = ""
                }
                cell.delegate = self
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as? TimeCell {
                if budgetObject.startDate != nil {
                    cell.lblTime.text = "\(budgetObject.startDate ?? "") - \(budgetObject.endDate ?? "")"
                    cell.lblTime.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    
                }else{
                    cell.lblTime.text = BudgetAddEditDataString.selectTime.rawValue.addLocalizableString(str: language)
                    cell.lblTime.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                }
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    // height cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    // click cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
        if indexPath.row == 0 {
            let vc = RouterType.selectCateBudget.getVc() as! SelectCategoryViewController
            vc.budgetObject = budgetObject
            vc.type = type
            vc.language = language
            vc.delegateCategory = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 2 {
            let vc = UIStoryboard.init(name: "budget", bundle: nil).instantiateViewController(withIdentifier: "TimeRangerViewController") as! TimeRangerViewController
            vc.type = type
            vc.budgetObject = budgetObject
            vc.language = language
            vc.delegateTimeRanger = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - add , edit budget , dialogMes
extension BudgetController: AddEditBudgetControll {
    
    func dialogMess(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: BudgetAddEditDataString.dialogItemOK.rawValue.addLocalizableString(str: language), style: .default) { (_) in
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // func add budget
    func addBudget() {
        let alertController = UIAlertController(title: "\(BudgetAddEditDataString.addBudget.rawValue.addLocalizableString(str: language)) ?", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: BudgetAddEditDataString.dialogItemOK.rawValue.addLocalizableString(str: language), style: .default) { (_) in
            self.presenter?.addBudget(budget: self.budgetObject, id: self.newChild)
            self.delegateBudgetController?.reloadDataListBudgetintoBudgetController()
            self.navigationController?.popViewController(animated:true)
        }
        let cancelAction = UIAlertAction(title: BudgetAddEditDataString.dialogItemCancel.rawValue.addLocalizableString(str: language), style: .cancel) { (_) in
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // func edit budget
    func editBudget() {
        let alertController = UIAlertController(title: "\(BudgetAddEditDataString.editBudget.rawValue.addLocalizableString(str: language)) ?", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: BudgetAddEditDataString.dialogItemOK.rawValue.addLocalizableString(str: language), style: .default) { (_) in
            self.presenter?.editBudget(budget: self.budgetObject)
            self.presenter?.getAmountTrans(budget: self.budgetObject, listTransaction: self.listTransaction)
//            self.delegateBudgetController?.reloadDataDetailBudgetintoBudgetController(budget: self.budgetObject , spend: self.spend)
            UserDefaults.standard.removeObject(forKey: Constants.budgetCateName)
            UserDefaults.standard.removeObject(forKey: Constants.budgetStartDate)
            UserDefaults.standard.removeObject(forKey: Constants.budgetEndDate)
            self.navigationController?.popViewController(animated:true)
        }
        let cancelAction = UIAlertAction(title: BudgetAddEditDataString.dialogItemCancel.rawValue.addLocalizableString(str: language), style: .cancel) { (_) in
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

//MARK: - Get data cell Amount
extension BudgetController: AmountCellDelegete {
    func amoutDidChange(value: String) {
        budgetObject.amount = Int(value)
    }
}

//MARK: - Reload data budget controller into TimeRanger and SelectCategory
extension BudgetController : TimeRangerViewControllerDelegate , SelectCategoryViewControllerDelegate{
    
    func fetchDataCategory(budget: Budget, type: String) {
        self.budgetObject = budget
        self.type = type
        tblAddBudget.reloadData()
    }
    
    func fetchDataTimeRanger(budget: Budget, type: String) {
        self.budgetObject = budget
        self.type = type
        tblAddBudget.reloadData()
    }
}

//MARK: - Get data into BudgetPresenterDelegate
extension BudgetController : BudgetPresenterDelegate {
    func getNewChildID(id: Int) {
        self.newChild = id
    }
    
    func getListBudgetName(listBudgetName: [Budget]) {
        self.listBudgetName = listBudgetName
    }
    
    func getListTransaction(listTransaction: [Transaction]) {
        self.listTransaction = listTransaction
    }
    
    func getAmount(amount: Int) {
        self.spend = amount
    }
}

//
//  TestController.swift
//  MyWallet
//
//  Created by Hoang Lam on 9/28/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Firebase

protocol CheckBudgetControll {
    func getDataNameBudget()
}

protocol AddBudgetControll {
    func getNewChildTitle()
    func addBudget()
}

protocol EditBudgetControll {
    func editBudget()
}

class BudgetController: UIViewController {

    @IBOutlet weak var tblAddBudget: UITableView!
    
    var budgetObject:Budget = Budget()
    
    var newChild = 0
    
    var listBudgetName:[String] = []
    
    var ref = Database.database().reference()
    
    var type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataNameBudget()
        
        if type == "Add Budget" {
            
            getNewChildTitle()
            
            navigationItem.title = type
        }
        
        else if type == "Edit Budget" {
            navigationItem.title = type
        }

        tblAddBudget.dataSource = self
        tblAddBudget.delegate = self
        
        tblAddBudget.register(UINib(nibName: "CateCell", bundle: nil), forCellReuseIdentifier: "CateCell")
        tblAddBudget.register(UINib(nibName: "AmountCell", bundle: nil), forCellReuseIdentifier: "AmountCell")
        tblAddBudget.register(UINib(nibName: "TimeCell", bundle: nil), forCellReuseIdentifier: "TimeCell")
        
        tblAddBudget.reloadData()
        
        tblAddBudget.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblAddBudget.bounds.width, height: 0))
        
    }
    
    
    @IBAction func btnSaveClick(_ sender: Any) {
        
        if(budgetObject.categoryName == "" || budgetObject.startDate == "" || budgetObject.amount == nil){
            let alertController = UIAlertController(title: nil, message: "Please Choose Enough Attributes", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .default) { (_) in
                print("cancel")
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        else{
            if type == "Add Budget" {
                if listBudgetName.count < 1 {
                    addBudget()
                }
                
                else{
                    
                    var checkExist = true
                    
                    for budgetName in listBudgetName {
                        if (budgetObject.categoryName == budgetName){
                            checkExist = false
                        }
                    }
                    
                    if (checkExist == false){
                        let alertController = UIAlertController(title: nil, message: "Category name is exist", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "OK", style: .default) { (_) in
                            print("cancel")
                        }
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                    else {
                        addBudget()
                    }
                }
            }
            
            else if type == "Edit Budget" {
                listBudgetName = listBudgetName.filter({ $0 != UserDefaults.standard.string(forKey: "name")! })
                
                var checkExist = true
                
                for budgetName in listBudgetName {
                    if (budgetObject.categoryName == budgetName){
                        checkExist = false
                    }
                }
                
                if (checkExist == false){
                    let alertController = UIAlertController(title: nil, message: "Category name is exist", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .default) { (_) in
                        print("cancel")
                    }
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
                else {
                    editBudget()
                }
            }
            
        }
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension BudgetController: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        var cell: UITableViewCell?
    
        switch indexPath.row {
        case 0:
           if let cell = tableView.dequeueReusableCell(withIdentifier: "CateCell", for: indexPath) as? CateCell {
            
            cell.imgCate.image = UIImage(named: budgetObject.categoryImage ?? "")
            
            if budgetObject.categoryName != nil {
                cell.lblCateName.text = budgetObject.categoryName ?? ""
                cell.lblCateName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            else{
                cell.lblCateName.text = "Select category"
                cell.lblCateName.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
            
              return cell
           }
        case 1:
           if let cell = tableView.dequeueReusableCell(withIdentifier: "AmountCell", for: indexPath) as? AmountCell {
            
            if budgetObject.amount != nil {
                cell.lblAmount.text = "\(budgetObject.amount!)"
            }
            else{
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
            }
            else{
                cell.lblTime.text = "Select time"
                cell.lblTime.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
        
              return cell
           }
        default:
            return UITableViewCell()
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
        
        if indexPath.row == 0 {
            let vc = UIStoryboard.init(name: "Lam", bundle: nil).instantiateViewController(withIdentifier: "SelectCategoryViewController") as! SelectCategoryViewController
            
            vc.budgetObject = budgetObject
    
            vc.type = type
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        else if indexPath.row == 2 {
            let vc = UIStoryboard.init(name: "Lam", bundle: nil).instantiateViewController(withIdentifier: "TimeRangerViewController") as! TimeRangerViewController
            
            vc.type = type
            vc.budgetObject = budgetObject
        
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension BudgetController: AmountCellDelegete {
    func amoutDidChange(value: String) {
        budgetObject.amount = Int(value)
    }
}

extension BudgetController: CheckBudgetControll {
    func getDataNameBudget() {
           
           listBudgetName.removeAll()
           
           ref.child("Account").child("userid1").child("budget").observeSingleEvent(of: .value) { (data) in
           
               for case let child as DataSnapshot in data.children{
                   guard let dict = child.value as? [String:Any] else{
                       print("Error")
                       return
                   }
      
                   let cateName = dict["categoryName"] as! String
                   
                   self.listBudgetName.append(cateName)
                   
               }
           
           }
       }
}

extension BudgetController: AddBudgetControll {
    //MARK: get new Child database (increament)
    func getNewChildTitle(){
        ref.child("Account").child("userid1").child("budget").observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let `self` = self else {
                return
            }
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                if snapshots.count < 1{
                    self.newChild = 1
                }
                else{
                    for snap in snapshots.reversed() {
                        let keyString = snap.key
                        if let keyInt = Int(keyString){
                            self.newChild = keyInt + 1
                        }
                        break;
                    }
                }
                
            }
        }
    }
    
    //MARK: add db
    func addBudget() {
        let alertController = UIAlertController(title: "Add Budget ?", message: nil, preferredStyle: .alert)
        
         let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
        
            let vc = UIStoryboard.init(name: "Lam", bundle: nil).instantiateViewController(withIdentifier: "BudgetListViewController") as! BudgetListViewController
            
            let budget = [
                "id" : self.newChild,
                "categoryName" : self.budgetObject.categoryName!,
                "categoryImage" : self.budgetObject.categoryImage!,
                "transactionType" : self.budgetObject.transactionType!,
                "amount" : self.budgetObject.amount!,
                "startDate" : self.budgetObject.startDate!,
                "endDate" : self.budgetObject.endDate!,
                "startDateSecondWith1970" : self.budgetObject.startDateSecondWith1970!,
                "endDateSecondWith1970" : self.budgetObject.endDateSecondWith1970!
                ] as [String : Any]
            
            self.ref.child("Account").child("userid1").child("budget").child("\(self.newChild)").updateChildValues(budget,withCompletionBlock: { error , ref in
                if error == nil {
                    self.dismiss(animated: true, completion: nil)
                }else{
                    //handle
                }
            } )
            
            self.navigationController?.pushViewController(vc, animated: true)
         }
        
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            print("cancel")
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension BudgetController: EditBudgetControll{
    func editBudget() {
        let alertController = UIAlertController(title: "Edit Budget ?", message: nil, preferredStyle: .alert)
        
         let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
        
            let vc = UIStoryboard.init(name: "Lam", bundle: nil).instantiateViewController(withIdentifier: "BudgetListViewController") as! BudgetListViewController
            
            let budget = [
                "id" : self.budgetObject.id!,
                "categoryName" : self.budgetObject.categoryName!,
                "categoryImage" : self.budgetObject.categoryImage!,
                "transactionType" : self.budgetObject.transactionType!,
                "amount" : self.budgetObject.amount!,
                "startDate" : self.budgetObject.startDate!,
                "endDate" : self.budgetObject.endDate!,
                "startDateSecondWith1970" : self.budgetObject.startDateSecondWith1970!,
                "endDateSecondWith1970" : self.budgetObject.endDateSecondWith1970!
                ] as [String : Any]
            
            self.ref.child("Account").child("userid1").child("budget").child("\(self.budgetObject.id!)").updateChildValues(budget,withCompletionBlock: { error , ref in
                if error == nil {
                    self.dismiss(animated: true, completion: nil)
                }else{
                }
            } )
            
            self.navigationController?.pushViewController(vc, animated: true)
         }
        
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            print("cancel")
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

//
//  SelectCategoryViewController.swift
//  MyWallet
//
//  Created by Hoang Lam on 9/22/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Firebase

class SelectCategoryViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet weak var headerSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tblCategory: UITableView!
    
    var segmentIndex = 0
    
    var budgetObject:Budget = Budget()
    
    var listCateIncome:[Category] = []
    var listCateExpense:[Category] = []
    
    var ref = Database.database().reference()
    
    var type = ""
    
    var name = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentIndex == 0{
            return listCateIncome.count
        }
        else{
            return listCateExpense.count
        }
            
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCategory.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        if segmentIndex == 0 {
            var imgName = listCateIncome[indexPath.row].iconImage
            var categoryName = listCateIncome[indexPath.row].name
            cell.loadContent(imgName: imgName!, categoryName: categoryName!)
        }
        
        else{
            var imgName = listCateExpense[indexPath.row].iconImage
            var categoryName = listCateExpense[indexPath.row].name
            cell.loadContent(imgName: imgName!, categoryName: categoryName!)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func getDataCateExpense() {
        listCateExpense.removeAll()
        
        ref.child("Category").child("expense").observeSingleEvent(of: .value) { (data) in
            for case let child as DataSnapshot in data.children{
                guard let dict = child.value as? [String:Any] else{
                    print("Error")
                    return
                }
                let imgName = dict["iconImage"] as! String
                let nameCate = dict["name"] as! String
                
                var cate = Category(name: nameCate, transactionType: "Expense", iconImage: imgName)
                self.listCateExpense.append(cate)
            }
            self.tblCategory.reloadData()
        }
    }
    
    
    func getDataCateIncome() {
        listCateExpense.removeAll()
        
        ref.child("Category").child("income").observeSingleEvent(of: .value) { (data) in
            for case let child as DataSnapshot in data.children{
                guard let dict = child.value as? [String:Any] else{
                    print("Error")
                    return
                }
                let imgName = dict["iconImage"] as! String
                let nameCate = dict["name"] as! String
                
                var cate = Category(name: nameCate, transactionType: "Income" ,iconImage: imgName)
                self.listCateIncome.append(cate)
            }
            self.tblCategory.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var categoryName = ""
        var categoryImage = ""
        var transactionType = ""
        if segmentIndex == 0{
            categoryName = listCateIncome[indexPath.row].name!
            categoryImage = listCateIncome[indexPath.row].iconImage!
            transactionType = listCateIncome[indexPath.row].transactionType!
        }
        else{
            categoryName = listCateExpense[indexPath.row].name!
            categoryImage = listCateExpense[indexPath.row].iconImage!
            transactionType = listCateExpense[indexPath.row].transactionType!
        }
        
        budgetObject.categoryName = categoryName
        budgetObject.categoryImage = categoryImage
        budgetObject.transactionType = transactionType
        
//        if type == "Add budget"{
////            let vc = UIStoryboard.init(name: "Lam", bundle: nil).instantiateViewController(withIdentifier: "BudgetViewController") as! BudgetViewController
//
//            let vc = UIStoryboard.init(name: "Lam", bundle: nil).instantiateViewController(withIdentifier: "TestController") as! TestController
//
//            vc.budgetObject = budgetObject
//            navigationController?.pushViewController(vc, animated: true)
//        }
//
//        else if type == "Edit budget"{
//            print(budgetObject)
//            let vc = UIStoryboard.init(name: "Lam", bundle: nil).instantiateViewController(withIdentifier: "BudgetEditViewController") as! BudgetEditViewController
//
//            vc.budgetObject = budgetObject
//
//            navigationController?.pushViewController(vc, animated: true)
//
//        }
        
        let vc = UIStoryboard.init(name: "Lam", bundle: nil).instantiateViewController(withIdentifier: "TestController") as! BudgetController
        
        vc.budgetObject = budgetObject
        vc.type = type
        
        navigationController?.pushViewController(vc, animated: true)
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.getDataCateExpense()
            self.getDataCateIncome()
        }
        
        tblCategory.dataSource = self
        tblCategory.delegate = self
        
        let nibName = UINib(nibName: "CategoryCell", bundle: nil)
        tblCategory.register(nibName, forCellReuseIdentifier: "CategoryCell")
        
        tblCategory.reloadData()
        
        tblCategory.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tblCategory.frame.width, height: 0))
        
    }
    
    @IBAction func segmentCate(_ uiSegmentedControl: UISegmentedControl) {
        segmentIndex = uiSegmentedControl.selectedSegmentIndex
        tblCategory.reloadData()
    }
    
}

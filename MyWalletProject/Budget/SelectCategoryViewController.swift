//
//  SelectCategoryViewController.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 9/30/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Firebase

protocol SelectCategoryViewControllerDelegate {
    func fetchDataCategory(budget:Budget,type:String)
}

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
    
    var delegateCategory:SelectCategoryViewControllerDelegate?
    
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
            let imgName = listCateIncome[indexPath.row].iconImage
            let categoryName = listCateIncome[indexPath.row].name
            cell.loadContent(imgName: imgName!, categoryName: categoryName!)
        }
        
        else{
            let imgName = listCateExpense[indexPath.row].iconImage
            let categoryName = listCateExpense[indexPath.row].name
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
                
                let cate = Category(name: nameCate, transactionType: "Expense", iconImage: imgName)
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
                
                let cate = Category(name: nameCate, transactionType: "Income" ,iconImage: imgName)
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
        
        delegateCategory?.fetchDataCategory(budget: budgetObject, type: type)
        self.navigationController?.popViewController(animated: true)
        
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

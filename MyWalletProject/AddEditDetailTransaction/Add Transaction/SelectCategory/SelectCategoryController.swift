//
//  SelectCategoryController.swift
//  MyWallet
//
//  Created by BAC Vuong Toan (VTI.Intern) on 9/23/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseAnalytics

protocol SelectCategory {
    func setCategory(nameCategory: String, iconCategory: String, type: String, id: String)
}

class SelectCategoryController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var categories = [Category]()
    var cellId = "SelectCategoryCell"
    var delegate: SelectCategory?
    
    var language = ChangeLanguage.vietnam.rawValue

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        GetListCategoryExpense()
        setLanguage()
    }
    
    func setLanguage(){
        segmentedControl.setTitle(SelectCategoryDataString.expense.rawValue.addLocalizableString(str: language), forSegmentAt: 0)
        segmentedControl.setTitle(SelectCategoryDataString.income.rawValue.addLocalizableString(str: language), forSegmentAt: 1)
        navigationItem.title = DetailTransactionDataString.detailTransaction.rawValue.addLocalizableString(str: language)

        


    }
    
    @IBAction func btnSelectCategory(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            GetListCategoryExpense()
        }else{
            GetListCategoryIncome()
        }
    }

    
    func GetListCategoryExpense(){
        categories.removeAll()
        Defined.ref.child("Category/expense").observe(DataEventType.value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    let id = snap.key
                    if let value = snap.value as? [String: Any]{
                        let id = snap.key
                        let name = value["name"] as! String
                        let iconImage = value["iconImage"] as! String
                        let type = "expense"
                        let category = Category(id: id, name: name, transactionType: type, iconImage: iconImage)
                        self.categories.append(category)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func GetListCategoryIncome(){
        categories.removeAll()
        Defined.ref.child("Category/income").observe(DataEventType.value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    let id = snap.key
                    if let value = snap.value as? [String: Any]{
                        let id = snap.key
                        let name = value["name"] as! String
                        let iconImage = value["iconImage"] as! String
                        let type = "income"
                        let category = Category(id: id, name: name, transactionType: type, iconImage: iconImage)
                        self.categories.append(category)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
}
extension SelectCategoryController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SelectCategoryCell
        cell.setUp(data: categories[indexPath.row])
        return cell 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RouterType.add.getVc() as! AddTransactionViewController
        let ex = categories[indexPath.row]
        vc.nameCategory = ex.name ?? ""
        vc.iconImages = ex.iconImage ?? ""
        delegate?.setCategory(nameCategory: ex.name ?? "", iconCategory: ex.iconImage ?? "", type: ex.transactionType ?? "", id: ex.id ?? "")
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

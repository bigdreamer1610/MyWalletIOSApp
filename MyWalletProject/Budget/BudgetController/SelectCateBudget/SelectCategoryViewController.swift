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

class SelectCategoryViewController: UIViewController {
    @IBOutlet weak var tblCategory: UITableView!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    
    var presenter: SelectCategoryBudgetPresenter?
    var refreshControl = UIRefreshControl()
    var budgetObject:Budget = Budget()
    var listCateExpense:[Category] = []
    var ref = Database.database().reference()
    var type = ""
    var name = ""
    var delegateCategory:SelectCategoryViewControllerDelegate?
    
    var language = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = SelectCategoryDataString.selectCategory.rawValue.addLocalizableString(str: language)
        btnBack.title = SelectCategoryDataString.back.rawValue.addLocalizableString(str: language)
        presenter?.getCateDB()
        // table category
        tblCategory.dataSource = self
        tblCategory.delegate = self
        let nibName = UINib(nibName: "CategoryCell", bundle: nil)
        tblCategory.register(nibName, forCellReuseIdentifier: "CategoryCell")
        refreshControl.attributedTitle = NSAttributedString(string: SelectCategoryDataString.refresh.rawValue.addLocalizableString(str: language))
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblCategory.addSubview(refreshControl)
        tblCategory.reloadData()
        tblCategory.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tblCategory.frame.width, height: 0))
    }
    
    @objc func refresh(_ sender: AnyObject){
        presenter?.getCateDB()
        tblCategory.reloadData()
        refreshControl.endRefreshing()
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func setUp(presenter: SelectCategoryBudgetPresenter) {
        self.presenter = presenter
    }
    
}

//MARK: - table datasource , delegate
extension SelectCategoryViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCateExpense.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCategory.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        let imgName = listCateExpense[indexPath.row].iconImage
        let categoryName = listCateExpense[indexPath.row].name
        cell.loadContent(imgName: imgName!, categoryName: categoryName!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        budgetObject.categoryId = listCateExpense[indexPath.row].id ?? ""
        budgetObject.categoryName = listCateExpense[indexPath.row].name ?? ""
        budgetObject.categoryImage = listCateExpense[indexPath.row].iconImage ?? ""
        budgetObject.transactionType = listCateExpense[indexPath.row].transactionType ?? ""
        
        delegateCategory?.fetchDataCategory(budget: budgetObject, type: type)
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - get and reload data table into SelectCategoryBudgetPresenterDelegate
extension SelectCategoryViewController : SelectCategoryBudgetPresenterDelegate {
    func getDataCate(listCateExpense: [Category], listCateIncome: [Category]) {
        self.listCateExpense = listCateExpense
        tblCategory.reloadData()
    }
    
}

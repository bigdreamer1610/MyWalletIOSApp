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
    @IBOutlet weak var headerSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tblCategory: UITableView!
    
    var presenter: SelectCategoryBudgetPresenter?
    var refreshControl = UIRefreshControl()
    var segmentIndex = 0
    var budgetObject:Budget = Budget()
    var listCateIncome:[Category] = []
    var listCateExpense:[Category] = []
    var ref = Database.database().reference()
    var type = ""
    var name = ""
    var delegateCategory:SelectCategoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.getCateDB()
        // table category
        tblCategory.dataSource = self
        tblCategory.delegate = self
        let nibName = UINib(nibName: "CategoryCell", bundle: nil)
        tblCategory.register(nibName, forCellReuseIdentifier: "CategoryCell")
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
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
    
    func setUp(presenter: SelectCategoryBudgetPresenter) {
        self.presenter = presenter
    }
    
    @IBAction func segmentCate(_ uiSegmentedControl: UISegmentedControl) {
        segmentIndex = uiSegmentedControl.selectedSegmentIndex
        tblCategory.reloadData()
    }
}

//MARK: - table datasource , delegate
extension SelectCategoryViewController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentIndex == 1 {
            return listCateIncome.count
        } else {
            return listCateExpense.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCategory.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        if segmentIndex == 1 {
            let imgName = listCateIncome[indexPath.row].iconImage
            let categoryName = listCateIncome[indexPath.row].name
            cell.loadContent(imgName: imgName!, categoryName: categoryName!)
        } else {
            let imgName = listCateExpense[indexPath.row].iconImage
            let categoryName = listCateExpense[indexPath.row].name
            cell.loadContent(imgName: imgName!, categoryName: categoryName!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentIndex == 1{
            budgetObject.categoryId = listCateIncome[indexPath.row].id ?? ""
            budgetObject.categoryName = listCateIncome[indexPath.row].name ?? ""
            budgetObject.categoryImage = listCateIncome[indexPath.row].iconImage ?? ""
            budgetObject.transactionType = listCateIncome[indexPath.row].transactionType ?? ""
        } else {
            budgetObject.categoryId = listCateExpense[indexPath.row].id ?? ""
            budgetObject.categoryName = listCateExpense[indexPath.row].name ?? ""
            budgetObject.categoryImage = listCateExpense[indexPath.row].iconImage ?? ""
            budgetObject.transactionType = listCateExpense[indexPath.row].transactionType ?? ""
        }
        delegateCategory?.fetchDataCategory(budget: budgetObject, type: type)
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - SelectCategoryBudgetPresenterDelegate
extension SelectCategoryViewController : SelectCategoryBudgetPresenterDelegate {
    func getDataCate(listCateExpense: [Category], listCateIncome: [Category]) {
        self.listCateExpense = listCateExpense
        self.listCateIncome = listCateIncome
        tblCategory.reloadData()
    }
    
}

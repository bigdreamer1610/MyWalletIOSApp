//
//  DetailPieChartVC.swift
//  MyWalletProject
//
//  Created by Nguyen Thi Huong on 9/28/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class DetailPieChartVC: UIViewController {
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var btnSearch: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var sum = 0
    var state: State?
    var segmentIndex = 0
    var sumByCategory = [SumByCate]()
    var categoriesIncome = [Category]()
    var categoriesExpense = [Category]()
    var categories = [Category]()
    var transations = [Transaction]()
    var nameIconCategory = ""
    var searchBar = UISearchBar()
    var filterdata = [SumByCate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        DetailPCCell.registerCellByNib(tableView)
        DetailPieTableViewCell.registerCellByNib(tableView)
        NameTableViewCell.registerCellByNib(tableView)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        self.navigationItem.rightBarButtonItem = nil
        searchBar.placeholder = "Search Category"
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }
    
    func getData(info: SumArr) {
        sum = info.sum
        sumByCategory = info.sumByCategory
        transations = info.transations
    }
    
    @IBAction func popToView(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmentInAndDe(_ uiSegmentedControl: UISegmentedControl) {
        segmentIndex = uiSegmentedControl.selectedSegmentIndex
        switch segmentIndex {
        case 0:
            sumByCategory.sort(by: { $0.amount > $1.amount })
        default:
            sumByCategory.sort(by: { $0.amount < $1.amount })
        }
        tableView.reloadData()
    }
    
    @IBAction func searchCategory(_ sender: Any) {
        setupSearchBar()
    }
}

extension DetailPieChartVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return sumByCategory.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = NameTableViewCell.loadCell(tableView)  as! NameTableViewCell
            cell.selectionStyle = .none
            if state == .income {
                cell.setupData(Constants.income, .blue, sum)
            } else {
                cell.setupData(Constants.expense, .red, sum)
            }
            return cell
        case 1:
            let cell = DetailPieTableViewCell.loadCell(tableView) as! DetailPieTableViewCell
            cell.selectionStyle = .none
            cell.setChart(sumByCategory)
            return cell
        default:
            let cell = DetailPCCell.loadCell(tableView) as! DetailPCCell
            cell.selectionStyle = .none
            if state == .income {
                cell.setupLabel(.blue)
            } else {
                cell.setupLabel(.red)
            }
            let category = sumByCategory[indexPath.row].category
            let money = sumByCategory[indexPath.row].amount
            let filtered = categories.filter { category in
                return category.id! == sumByCategory[indexPath.row].category
            }
            let imageName = filtered[0].iconImage ?? "bill"
            
            cell.setupView(imageName: imageName, category: category, money: money)
            return cell
        }
    }
}

extension DetailPieChartVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        //        searchBar.text = ""
        navigationItem.titleView = segment
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}

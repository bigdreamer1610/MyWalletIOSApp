//
//  DetailPieChartVC.swift
//  MyWalletProject
//
//  Created by Nguyen Thi Huong on 9/28/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class DetailPieChartVC: UIViewController{
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var btnSearch: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    fileprivate let searchBar = UISearchBar()
    var sum = 0
    var state: State?
    var segmentIndex = 0
    var sumByCategory = [SumByCate]()
    var categoriesIncome = [Category]()
    var categoriesExpense = [Category]()
    var categories = [Category]()
    var transactions = [Transaction]()
    var trans = [Transaction]()
    var imageName = ""
    var date = ""
    var convertedArray: [Date] = []
    var filterData = [SumByCate]()
    
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
    
    func setupData(info: SumArr) {
        sum = info.sum
        sumByCategory = info.sumByCategory
        transactions = info.transations
        date = info.date
        tableView?.reloadData()
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
            if sum == 0 {
                cell.imageNoData.isHidden = false
            } else {
                cell.imageNoData.isHidden = true
                cell.setChart(sumByCategory)
            }
            
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
            imageName = filtered[0].iconImage ?? "bill"
            cell.setupView(info: DetailDayPC(imageName: imageName, category: category, money: money, date: date))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            self.trans.removeAll()
            let vc = RouterType.detailPC.getVc() as! DayDetailPC
            let cate = sumByCategory[indexPath.row].category
            let sum = sumByCategory[indexPath.row].amount
            
            // set icon fo DayDetailPC
            let filtered = categories.filter { category in
                return category.id! == sumByCategory[indexPath.row].category
            }
            imageName = filtered[0].iconImage ?? "bill"
            
            // check category
            for index in 0 ..< transactions.count {
                if cate == transactions[index].categoryid {
                    trans.append(transactions[index])
                }
            }
            
            // setup data for DayDetailPC
            vc.setupData(info: DetailPC(state: state, transactions: trans, categoryImage: imageName, sumByCategory: sum, category: cate, date: date))
            self.navigationController?.pushViewController(vc, animated: true)
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
        if searchText.isEmpty {
            filterData = sumByCategory
            self.tableView.reloadData()
        } else {
            filterTableView(text: searchText)
            self.tableView.reloadData()
        }
    }
    
    func filterTableView(text:String) {
        filterData = sumByCategory.filter({ (category) -> Bool in
            return category.category.lowercased().contains(text.lowercased())
        })
    }
}

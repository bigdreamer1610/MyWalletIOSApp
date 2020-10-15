//
//  ReportViewController.swift
//  MyWallet
//
//  Created by Nguyen Thi Huong on 9/21/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import Charts
import UIKit
import MonthYearPicker
import Firebase

class ReportViewController: UIViewController {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var txtDatePicker: UITextField!
    var months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    var currentMonth = 0
    var currentYear = 0
    var open = 0
    var end = 0
    var date = ""
    var expenseArray: [Transaction] = []
    var incomeArray: [Transaction] = []
    var sumIncome = 0
    var sumExpense = 0
    var categories: [Category] = []
    var sumByCategoryIncome = [SumByCate]()
    var sumByCategoryExpense = [SumByCate]()
    
    var presenter: ReportPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTxtDate()
        showDatePicker()
        createDatePicker()
        
        self.presenter?.requestIncome(dateInput: self.date)
        self.presenter?.requestExpense(dateInput: self.date)
        self.presenter?.requestCategories(nameNode: "income")
        self.presenter?.requestCategories(nameNode: "expense")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func setupDelegate(presenter: ReportPresenter) {
        self.presenter = presenter
    }
    //MARK: - Setup Date
    func setupTxtDate() {
        txtDatePicker.tintColor = .clear
        currentYear = Defined.calendar.component(.year, from: Date())
        currentMonth = Defined.calendar.component(.month, from: Date())
        Defined.dateFormatter.locale = Locale(identifier: "vi_VN")
        Defined.dateFormatter.dateFormat = "dd/MM/yyyy"
        lblDate.text = "\(months[currentMonth - 1]) \(currentYear)"
        if currentMonth < 10 {
            txtDatePicker.text = "0\(currentMonth)/\(currentYear)"
            self.date = txtDatePicker.text ?? "Error"
        } else {
            txtDatePicker.text = "\(currentMonth)/\(currentYear)"
            self.date = txtDatePicker.text ?? "Error"
        }
        txtDatePicker.setRightImage(imageName: "down")
    }
    
    func showDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: Constants.done, style: .plain, target: self, action: #selector(doneDatePicker))
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        txtDatePicker.inputAccessoryView = toolbar
    }
    
    @objc func doneDatePicker(){
        self.presenter?.handleDataForPieChart(dataArray: self.incomeArray, state: .income)
        self.presenter?.handleDataForPieChart(dataArray: self.expenseArray, state: .expense)
        self.tableView.reloadData()
        self.view.endEditing(true)
    }
    
    func createDatePicker(){
        let picker = MonthYearPickerView(frame: CGRect(origin: CGPoint(x: 0, y: (view.bounds.height - 216) / 2), size: CGSize(width: view.bounds.width, height: 216)))
        picker.minimumDate = Calendar.current.date(byAdding: .year, value: -2, to: Date())
        picker.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        txtDatePicker.inputView = picker
    }
    
    @objc func dateChanged(_ picker: MonthYearPickerView) {
        let components = Defined.calendar.dateComponents([.month, .year], from: picker.date)
        lblDate.text = "\(months[components.month! - 1]) \(components.year!)"
        if components.month! < 10 {
            txtDatePicker.text = "0\(components.month!)/\(components.year!)"
            self.date = txtDatePicker.text ?? "\(currentMonth)/\(currentYear)"
        } else {
            txtDatePicker.text = "\(components.month!)/\(components.year!)"
            self.date = txtDatePicker.text ?? "\(currentMonth)/\(currentYear)"
        }
        self.presenter?.requestIncome(dateInput: self.date)
        self.presenter?.requestExpense(dateInput: self.date)
        self.tableView.reloadData()
    }
    
    //MARK: - Setup TableView
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        MoneyTableViewCell.registerCellByNib(tableView)
        StackedBarChartTableViewCell.registerCellByNib(tableView)
        PieChartTableViewCell.registerCellByNib(tableView)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
}

extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = MoneyTableViewCell.loadCell(tableView) as! MoneyTableViewCell
            cell.setupData(opening: open, sumIncome: sumIncome, sumExpense: sumExpense)
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = StackedBarChartTableViewCell.loadCell(tableView) as! StackedBarChartTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.setChartData(sumIncome, sumExpense, sumIncome - sumExpense)
            return cell
        default:
            let cell = PieChartTableViewCell.loadCell(tableView) as! PieChartTableViewCell
            cell.delegate = self
            cell.setupDataTB(info: SumForPieChart(sumIncome: sumIncome, sumExpense: sumExpense, sumByCateIncome: sumByCategoryIncome, sumByCateExpense: sumByCategoryExpense))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = UIStoryboard.init(name: "Report", bundle: Bundle.main).instantiateViewController(identifier: "detailSBC") as! DetailStackedBarChartVC
            vc.setupData(info: SumInfo(sumIncome: sumIncome, sumExpense: sumExpense, netIncome: sumIncome - sumExpense, date: lblDate.text!, incomeArray: incomeArray, expenseArray: expenseArray, categories: categories))
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - Go to DetailPieChartVC
extension ReportViewController: CustomCollectionCellDelegate {
    func collectionView(collectioncell: PieChartCollectionViewCell?, didTappedInTableview TableCell: PieChartTableViewCell, indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Report", bundle: Bundle.main).instantiateViewController(identifier: "detailPC") as! DetailPieChartVC
        if indexPath.row == 0 {
            vc.state = .income
            vc.setupData(info: SumArr(sum: sumIncome, sumByCategory: sumByCategoryIncome, transations: incomeArray, date: lblDate.text!))
            print(incomeArray)
        } else {
            vc.state = .expense
            vc.setupData(info: SumArr(sum: sumExpense, sumByCategory: sumByCategoryExpense, transations: expenseArray, date: lblDate.text!))
            print(expenseArray)
        }
        vc.categories = categories
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ReportViewController: ReportPresenterDelegate {
    func returnCategories(categories: [Category]) {
        self.categories = categories
        self.tableView.reloadData()
    }
    
    func returnIncomeDataForPieChart(sum: [SumByCate]) {
        self.sumByCategoryIncome = sum
        self.tableView.reloadData()
    }
    
    func returnExpenseDataForPieChart(sum: [SumByCate]) {
        self.sumByCategoryExpense = sum
        self.tableView.reloadData()
    }
    
    func returnIncomeDataForView(incomeArray: [Transaction], sumIncome: Int) {
        self.incomeArray = incomeArray
        self.presenter?.handleDataForPieChart(dataArray: self.incomeArray, state: .income)
        self.sumIncome = sumIncome
        self.tableView.reloadData()
    }
    
    func returnExpenseDataForView(expenseArray: [Transaction], sumExpense: Int) {
        self.expenseArray = expenseArray
        self.presenter?.handleDataForPieChart(dataArray: self.expenseArray, state: .expense)
        self.sumExpense = sumExpense
        self.tableView.reloadData()
    }
}

//
//  ReportViewController.swift
//  MyWallet
//
//  Created by Nguyen Thi Huong on 9/21/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import Charts
import UIKit
import FirebaseDatabase
import MonthYearPicker

protocol ReceiveData: class {
    func receiveData(income: Int, expense: Int)
}

class ReportViewController: UIViewController {
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var txtDatePicker: UITextField!
    var ref: DatabaseReference!
    
    private var dateFormatter = DateFormatter()
    var today = Date()
    var months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    let calendar = Calendar.current
    var currentMonth = 9
    var currentYear = 2020
    var income = 0
    var expense = 0
    var state = 0
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ReportViewController.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = .lightGray
        refreshControl.attributedTitle = NSAttributedString(string: "loading")
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        setupTableView()
        setupTxtDate()
        showDatePicker()
        createDatePicker()
        self.tableView.addSubview(self.refreshControl)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        tableView.reloadData()
        refreshControl.endRefreshing()
        print("scroll to top")
    }
    
    func setupTxtDate() {
        txtDatePicker.tintColor = .clear
        currentYear = calendar.component(.year, from: today)
        currentMonth = calendar.component(.month, from: today)
        dateFormatter.locale = Locale(identifier: "vi_VN")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        lblDate.text = "\(months[currentMonth - 1]) \(currentYear)"
        if currentMonth < 10 {
            txtDatePicker.text = "0\(currentMonth)/\(currentYear)"
        } else {
            txtDatePicker.text = "\(currentMonth)/\(currentYear)"
        }
        txtDatePicker.setRightImage(imageName: "down")
    }
    
    func showDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        txtDatePicker.inputAccessoryView = toolbar
    }
    
    @objc func doneDatePicker(){
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
        let components = calendar.dateComponents([.day, .month, .year, .weekday], from: picker.date)
        lblDate.text = "\(months[components.month! - 1]) \(components.year!)"
        if components.month! < 10 {
            txtDatePicker.text = "0\(components.month!)/\(components.year!)"
        } else {
            txtDatePicker.text = "\(components.month!)/\(components.year!)"
        }
        tableView.reloadData()
    }
    
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
        if indexPath.section == 0 {
            let cell = MoneyTableViewCell.loadCell(tableView)  as! MoneyTableViewCell
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 1  {
            let cell = StackedBarChartTableViewCell.loadCell(tableView)  as! StackedBarChartTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.date = txtDatePicker.text ?? "Error"
            cell.reportView = self
            return cell
        } else {
            let cell = PieChartTableViewCell.loadCell(tableView)  as! PieChartTableViewCell
            cell.delegate = self
            cell.date = txtDatePicker.text ?? "Error"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = UIStoryboard.init(name: "Report", bundle: Bundle.main).instantiateViewController(identifier: "detailSBC") as! DetailStackedBarChartVC
            vc.expense = self.expense
            vc.income = self.income
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension ReportViewController: CustomCollectionCellDelegate {
    func collectionView(collectioncell: PieChartCollectionViewCell?, didTappedInTableview TableCell: PieChartTableViewCell) {
        let vc = UIStoryboard.init(name: "Report", bundle: Bundle.main).instantiateViewController(identifier: "detailPC") as! DetailPieChartVC
        vc.sumIncome = self.income
        vc.sumExpense = self.expense
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ReportViewController: ReceiveData {
    func receiveData(income: Int, expense: Int) {
        self.income = income
        self.expense = expense
    }
}


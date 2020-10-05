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
    //    var months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    var months = ["Tháng 1","Tháng 2","Tháng 3","Tháng 4","Tháng 5","Tháng 6","Tháng 7","Tháng 8","Tháng 9","Tháng 10","Tháng 11","Tháng 12"]
    let calendar = Calendar.current
    var currentMonth = 9
    var currentYear = 2020
    var sumIncome = 0
    var sumExpense = 0
    var state = 0
    var date = "" 
    var category = ""
    var expenseArray: [Transaction] = []
    var incomeArray: [Transaction] = []
    var timer = Timer()
    var sumByCategory = [(category: String, amount: Int)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        setupTableView()
        setupTxtDate()
        showDatePicker()
        createDatePicker()
        DispatchQueue.main.async {
            self.getIncome()
            self.getExpense()
        }
        checkWhenDataIsReady()
        tableView.reloadData()
    }
    
    //MARK: - Check data is ready
    func checkWhenDataIsReady() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ReportViewController.finishLoading)), userInfo: nil, repeats: true)
    }
    
    @objc func finishLoading() {
        if expenseArray.count != 0 && incomeArray.count != 0 {
            tableView.reloadData()
            timer.invalidate()
        }
    }
    
    //MARK: - Get all transaction
    func getExpense()  {
        expenseArray.removeAll()
        sumExpense = 0
        
        // tạo luồng load cùng 1 nhóm
        let dispatchGroup = DispatchGroup()
        
        // load api Transaction
        dispatchGroup.enter()
        self.ref.child("Account").child("userid1").child("transaction").child("expense").observeSingleEvent(of: .value) {
            snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    return
                }
                let amount = dict["amount"] as! Int
                let date = dict["date"] as! String
                let categoryid = dict["categoryid"] as! String
                let tempDate = date.split(separator: "/")
                let checkDate = tempDate[1] + "/" + tempDate[2]
                
                if self.date == checkDate {
                    let ex = Transaction(amount: amount, categoryid: categoryid, date: date)
                    self.sumExpense += amount
                    self.category = categoryid
                    self.expenseArray.append(ex)
                }
            }
        }
        dispatchGroup.leave()
    }
    
    func getIncome() {
        incomeArray.removeAll()
        sumIncome = 0
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        self.ref.child("Account").child("userid1").child("transaction").child("income").observeSingleEvent(of: .value) {
            snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    return
                }
                let amount = dict["amount"] as! Int
                let date = dict["date"] as! String
                let categoryid = dict["categoryid"] as! String
                
                let tempDate = date.split(separator: "/")
                let checkDate = tempDate[1] + "/" + tempDate[2]
                
                if self.date == checkDate {
                    let ex = Transaction(amount: amount, categoryid: categoryid, date: date)
                    self.sumIncome += amount
                    self.category = categoryid
                    self.incomeArray.append(ex)
                }
            }
        }
        dispatchGroup.leave()
    }
    
    // Sum by Category
    func dataForPieChart(dataArray: [Transaction]) {
        sumByCategory.removeAll()
        for index in 0 ..< dataArray.count {
            let sumIndex = checkExist(category: dataArray[index].categoryid!)
            if sumIndex != -1 {
                sumByCategory[sumIndex].amount += dataArray[index].amount!
            } else {
                sumByCategory.append((category: dataArray[index].categoryid!, amount: dataArray[index].amount!))
            }
        }
    }
    
    // Check if a Category exists
    func checkExist(category: String) -> Int {
        for index in 0 ..< sumByCategory.count {
            if category == sumByCategory[index].category {
                return index
            }
        }
        return -1
    }
    
    //MARK: - Setup Date
    func setupTxtDate() {
        txtDatePicker.tintColor = .clear
        currentYear = calendar.component(.year, from: Date())
        currentMonth = calendar.component(.month, from: Date())
        dateFormatter.locale = Locale(identifier: "vi_VN")
        dateFormatter.dateFormat = "dd/MM/yyyy"
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
        let components = calendar.dateComponents([.month, .year], from: picker.date)
        lblDate.text = "\(months[components.month! - 1]) \(components.year!)"
        if components.month! < 10 {
            txtDatePicker.text = "0\(components.month!)/\(components.year!)"
            self.date = txtDatePicker.text ?? "\(currentMonth)/\(currentYear)"
        } else {
            txtDatePicker.text = "\(components.month!)/\(components.year!)"
            self.date = txtDatePicker.text ?? "\(currentMonth)/\(currentYear)"
        }
        tableView.reloadData()
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
            let cell = MoneyTableViewCell.loadCell(tableView)  as! MoneyTableViewCell
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = StackedBarChartTableViewCell.loadCell(tableView) as! StackedBarChartTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.setupData(sumIncome: sumIncome, sumExpense: sumExpense)
            cell.reportView = self
            return cell
        default:
            let cell = PieChartTableViewCell.loadCell(tableView)  as! PieChartTableViewCell
            cell.delegate = self
//            cell.setupDataTB(sumIncome: sumIncome, sumExpense: sumExpense)
            cell.date = txtDatePicker.text ?? "Error"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = UIStoryboard.init(name: "Report", bundle: Bundle.main).instantiateViewController(identifier: "detailSBC") as! DetailStackedBarChartVC
            vc.sumExpense = self.sumExpense
            vc.sumIncome = self.sumIncome
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


//MARK: - Go to DetailPieChartVC
extension ReportViewController: CustomCollectionCellDelegate {
    func collectionView(collectioncell: PieChartCollectionViewCell?, didTappedInTableview TableCell: PieChartTableViewCell) {
        let vc = UIStoryboard.init(name: "Report", bundle: Bundle.main).instantiateViewController(identifier: "detailPC") as! DetailPieChartVC
        vc.sumIncome = self.sumIncome
        vc.sumExpense = self.sumExpense
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ReportViewController: ReceiveData {
    func receiveData(income: Int, expense: Int) {
        self.sumIncome = income
        self.sumExpense = expense
    }
}


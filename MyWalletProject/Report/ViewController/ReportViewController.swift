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

class ReportViewController: UIViewController {
    
    @IBOutlet weak var btnCalendar: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var lblPreviousMonth: UILabel!
    @IBOutlet weak var lblCurrentMonth: UILabel!
    @IBOutlet weak var lblFuture: UILabel!
    
    let dateCollectionID = "DateCollectionViewCell"
    let moneyID = "MoneyTableViewCell"
    let stackedBarChartID = "StackedBarChartTableViewCell"
    let pieChartID = "PieChartTableViewCell"
    var currentMonth = ""
    var calendar = ""
    var month = ""
    var previousMonth = ""
    var ref: DatabaseReference!
    
    var timeForView: [String] = [] {
        didSet {
            
        }
    }
    
    var timeForData: [String] = [] {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        ref = Database.database().reference()
        setupTableView()
        
        self.currentMonth = setDate()
        
        initTime()
        initTimeLabel()
        
        setupLabel()
    }
    
    func initTimeLabel() {
        lblCurrentMonth.textColor = .black
        btnCalendar.setTitle(currentMonth, for: .normal)
    }
    
    func setupLabel() {
        lblPreviousMonth.text = "Tháng trước"
        let previousGesture = UITapGestureRecognizer(target: self, action:  #selector(previousClicked))
        lblPreviousMonth.isUserInteractionEnabled = true
        lblPreviousMonth.addGestureRecognizer(previousGesture)
        
        lblCurrentMonth.text = "Tháng này"
        let currentGesture = UITapGestureRecognizer(target: self, action:  #selector(currentClicked))
        lblCurrentMonth.isUserInteractionEnabled = true
        lblCurrentMonth.addGestureRecognizer(currentGesture)
        
        lblFuture.text = "Tương lai"
        let futureGesture = UITapGestureRecognizer(target: self, action:  #selector(futureClicked))
        lblFuture.isUserInteractionEnabled = true
        lblFuture.addGestureRecognizer(futureGesture)
    }
    
    @objc func previousClicked(sender : UITapGestureRecognizer) {
        btnCalendar.setTitle(timeForData[0], for: .normal)
        lblPreviousMonth.textColor = .black
        lblCurrentMonth.textColor = UIColor.gray.withAlphaComponent(0.6)
        lblFuture.textColor = UIColor.gray.withAlphaComponent(0.6)
        tableView.reloadData()
    }
    @objc func currentClicked(sender : UITapGestureRecognizer) {
        btnCalendar.setTitle(timeForData[1], for: .normal)
        lblCurrentMonth.textColor = .black
        lblPreviousMonth.textColor = UIColor.gray.withAlphaComponent(0.6)
        lblFuture.textColor = UIColor.gray.withAlphaComponent(0.6)
        tableView.reloadData()
    }
    
    @objc func futureClicked(sender : UITapGestureRecognizer) {
        btnCalendar.setTitle(timeForData[2], for: .normal)
        lblFuture.textColor = .black
        lblCurrentMonth.textColor = UIColor.gray.withAlphaComponent(0.6)
        lblPreviousMonth.textColor = UIColor.gray.withAlphaComponent(0.6)
        tableView.reloadData()
    }
    
    func initTime() {
        currentMonth = setDate()
        timeForData.append(splitData(currentMonth, "next"))
        timeForData.append(currentMonth)
        timeForData.append(splitData(currentMonth, "previous"))
        timeForData.reverse()
    }
    
    func splitData(_ monthYear: String, _ state: String) ->  String {
        let dateData : [String] = monthYear.components(separatedBy: "/")
        var tempMonth = Int(dateData[0]) ?? 0
        var tempYear = Int(dateData[1]) ?? 0
        
        var result = ""
        
        if state == "next" {
            if tempMonth == 12 {
                tempYear += 1
                tempMonth = 1
            } else {
                tempMonth += 1
            }
            
            if tempMonth < 10 {
                result = "0\(tempMonth)/\(tempYear)"
            } else {
                result = "\(tempMonth)/\(tempYear)"
            }
        } else {
            if tempMonth == 1 {
                tempYear -= 1
                tempMonth = 12
            } else {
                tempMonth -= 1
            }
            
            if tempMonth < 10 {
                result = "0\(tempMonth)/\(tempYear)"
            } else {
                result = "\(tempMonth)/\(tempYear)"
            }
        }
        
        return result
    }
    
    func setDate() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MM/yyyy"
        let formatDate = format.string(from: date)
        return formatDate
    }
    
    @IBAction func calendar(_ sender: Any) {
        let calendar = UIStoryboard.init(name: "AddEvent", bundle: nil).instantiateViewController(identifier: "calendarView") as! CalendarController
        
        lblFuture.textColor = UIColor.gray.withAlphaComponent(0.6)
        lblCurrentMonth.textColor = UIColor.gray.withAlphaComponent(0.6)
        lblPreviousMonth.textColor = UIColor.gray.withAlphaComponent(0.6)
        calendar.completionHandler = {
            self.btnCalendar.setTitle($0, for: .normal)
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(calendar, animated: true)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false
        
        tableView.register(UINib(nibName: "MoneyTableViewCell", bundle: nil), forCellReuseIdentifier: moneyID)
        tableView.register(UINib(nibName: "StackedBarChartTableViewCell", bundle: nil), forCellReuseIdentifier: stackedBarChartID)
        tableView.register(UINib(nibName: "PieChartTableViewCell", bundle: nil), forCellReuseIdentifier: pieChartID)
        
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
            let cell = tableView.dequeueReusableCell(withIdentifier: moneyID, for: indexPath) as! MoneyTableViewCell
            return cell
        } else if indexPath.section == 1  {
            let cell = tableView.dequeueReusableCell(withIdentifier: stackedBarChartID, for: indexPath) as! StackedBarChartTableViewCell
            cell.date = btnCalendar.titleLabel!.text ?? "error"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: pieChartID, for: indexPath) as! PieChartTableViewCell
            
            return cell
        }
    }
    
    
}



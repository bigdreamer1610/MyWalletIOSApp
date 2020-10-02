//
//  StackedBarChartTableViewCell.swift
//  MyWallet
//
//  Created by Nguyen Thi Huong on 9/23/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Charts
import FirebaseDatabase

protocol setUpData {
    func pushData(income: Int, expen:Int)
}

class StackedBarChartTableViewCell: BaseTBCell, ChartViewDelegate {
    @IBOutlet weak var lblNetIncome: UILabel!
    @IBOutlet weak var containerView: UIView!
    var chartView = BarChartView()
    let days = [""]
    var ref: DatabaseReference!
    var sumExpense = 0
    var sumIncome = 0
    var netIncome = 0
    private var formatter = NumberFormatter()
    var delegate:setUpData?
    
    var reportView: ReceiveData?
    
    var date = "" {
        didSet {
            getIncome()
            getExpense()
            setChartData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ref = Database.database().reference()
        
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        
        buildChart()
    }
    
    var expenseArray: [Transaction] = [] {
        didSet {
            setChartData()
        }
    }
    
    var incomeArray: [Transaction] = [] {
        didSet {
            setChartData()
        }
    }
    
    func buildChart() {
        chartView.delegate = self
        chartView.dragEnabled = false
        chartView.noDataText = "Data will be loaded soon."
        chartView.dragEnabled = false
        
        chartView.chartDescription?.enabled = false
        
        chartView.maxVisibleCount = 40
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.highlightFullBarEnabled = false
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelPosition = .outsideChart
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        leftAxis.axisMinimum = 0
        leftAxis.labelFont = .systemFont(ofSize: 13)
        leftAxis.labelTextColor = UIColor.gray
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = false
        xAxis.labelCount = 6
        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularity = 8
        xAxis.valueFormatter = self
        
        chartView.rightAxis.enabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func getExpense()  {
        expenseArray.removeAll()
        
        sumExpense = 0
        
        self.ref.child("Account").child("userid1").child("transaction").child("expense").observeSingleEvent(of: .value) {
            snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    return
                }
                let amount = dict["amount"] as! Int
                let date = dict["date"] as! String
                let tempDate = date.split(separator: "/")
                let checkDate = tempDate[1] + "/" + tempDate[2]
                
                if self.date == checkDate {
                    let ex = Transaction(amount: amount, date: date)
                    self.sumExpense += amount
                    self.expenseArray.append(ex)
                }
            }
        }
    }
    
    func getIncome() {
        incomeArray.removeAll()
        sumIncome = 0
        self.ref.child("Account").child("userid1").child("transaction").child("income").observeSingleEvent(of: .value) {
            snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    return
                }
                let amount = dict["amount"] as! Int
                let date = dict["date"] as! String
                let tempDate = date.split(separator: "/")
                let checkDate = tempDate[1] + "/" + tempDate[2]
                
                if self.date == checkDate {
                    let ex = Transaction(amount: amount, date: date)
                    self.sumIncome += amount
                    self.incomeArray.append(ex)
                }
            }
        }
    }
    
    func setChartData( ){
        chartView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: containerView.frame.size.width,
                                 height: containerView.frame.size.height)
        containerView.addSubview(chartView)
        
        netIncome = sumIncome - sumExpense
        reportView?.receiveData(income: sumIncome, expense: sumExpense)
        
        lblNetIncome.text = "\(formatter.string(from: NSNumber(value: netIncome))!)"
        
        var yVals =  [BarChartDataEntry]()
        let val1 = Double(sumIncome)
        let val2 = Double(sumExpense)
        
        yVals.append(BarChartDataEntry(x: 1.0, yValues: [val1, val2]))
        
        let set = BarChartDataSet(entries: yVals, label: "")
        set.colors = [#colorLiteral(red: 0, green: 0.3944762324, blue: 0.9803921569, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)]
        set.stackLabels = ["Khoản thu", " Khoản chi"]
        
        let data = BarChartData(dataSet: set)
        set.drawValuesEnabled = false
        data.barWidth = 0.1
        data.highlightEnabled = false
        chartView.data = data
    }
}

extension StackedBarChartTableViewCell: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return days[min(max(Int(value), 0), days.count - 1)]
    }
}



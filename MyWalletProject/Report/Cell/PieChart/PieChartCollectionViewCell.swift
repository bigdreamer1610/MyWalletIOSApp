//
//  PieChartCollectionViewCell.swift
//  MyWallet
//
//  Created by Nguyen Thi Huong on 9/23/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Charts
import FirebaseDatabase

class PieChartCollectionViewCell: UICollectionViewCell, ChartViewDelegate {
    
    @IBOutlet weak var lblTypeOfMoney: UILabel!
    @IBOutlet weak var lblMoney: UILabel!
    @IBOutlet weak var containerView: UIView!
    var chartView = PieChartView()
    var ref: DatabaseReference!
    var sumExpense = 0
    var sumIncome = 0
    var state = 0
    var entries = [ChartDataEntry]()
    var sumByCategory = [(category: String, amount: Int)]()
    
    var date = "09/2020" {
        didSet {
            getData()
            setChart()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chartView.delegate = self
        ref = Database.database().reference()
        
        chartView.legend.enabled = false
        chartView.setExtraOffsets(left: -20, top: 10, right: -20, bottom: -30)
        
        setChart()
        getData()
    }
    var incomeArray: [Transaction] = [] {
        didSet {
            
            setChart()
        }
    }
    var expenseArray: [Transaction] = [] {
        didSet {
            
            setChart()
        }
    }
    
    func getData()  {
        expenseArray.removeAll()
        incomeArray.removeAll()
        sumIncome = 0
        sumExpense = 0
        self.ref.child("Account").child("userid1").child("transaction").child("expense").observeSingleEvent(of: .value) {
            snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    return
                }
                let amount = dict["amount"] as! Int
                let date = dict["date"] as! String
                let categoryid = dict["categoryid"] as! String
                
                let ex = Transaction(amount: amount, categoryid: categoryid, date: date)
                self.sumExpense += amount

                self.expenseArray.append(ex)
            }
        }
        
        self.ref.child("Account").child("userid1").child("transaction").child("income").observeSingleEvent(of: .value) {
            snapshot in
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    return
                }
                let amount = dict["amount"] as! Int
                let date = dict["date"] as! String
                let categoryid = dict["categoryid"] as! String
                
                let ex = Transaction(amount: amount, categoryid: categoryid, date: date)
                self.sumIncome += amount

                self.incomeArray.append(ex)
            }
        }
        
    }
    
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
    
    func checkExist(category: String) -> Int {
        for index in 0 ..< sumByCategory.count {
            if category == sumByCategory[index].category {
                return index
            }
        }
        return -1
    }
    
    func setChart(){
        entries.removeAll()
        chartView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: self.containerView.frame.size.width,
                                 height: self.containerView.frame.size.height)
        
        containerView.addSubview(chartView)
        
        if state == 1 {
            dataForPieChart(dataArray: incomeArray)
            lblMoney.text = "\(sumIncome)"
            for index in 0 ..< sumByCategory.count {
                entries.append(PieChartDataEntry(value: Double(sumByCategory[index].amount), label: sumByCategory[index].category))
            }
        }
            
        else {
            dataForPieChart(dataArray: expenseArray)
            lblMoney.text = "\(sumExpense)"
            for index in 0 ..< sumByCategory.count {
                entries.append(PieChartDataEntry(value: Double(sumByCategory[index].amount), label: sumByCategory[index].category))
            }
        }
        
        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 1
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        set.valueLinePart1OffsetPercentage = 0.8
        set.valueLinePart1Length = 0.2
        set.valueLinePart2Length = 0.4
        set.yValuePosition = .outsideSlice
        
        let data = PieChartData(dataSet: set)
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.white)
        set.drawValuesEnabled = false
        chartView.data = data
        chartView.highlightValues(nil)
    }
}

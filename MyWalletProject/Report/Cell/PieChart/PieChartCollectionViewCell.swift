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

class PieChartCollectionViewCell: BaseCLCell, ChartViewDelegate {
    
    @IBOutlet weak var lblTypeOfMoney: UILabel!
    @IBOutlet weak var lblMoney: UILabel!
    @IBOutlet weak var containerView: UIView!
    var chartView = PieChartView()
    var ref: DatabaseReference!
    var sumExpense = 0
    var sumIncome = 0
    var state: String = ""
    var entries = [ChartDataEntry]()
    var sumByCategoryIncome = [(category: String, amount: Int)]()
    var sumByCategoryExpense = [(category: String, amount: Int)]()
    private var formatter = NumberFormatter()
    
    var reportView2: ReceiveData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ref = Database.database().reference()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        buildChart()
        setChart()
    }
    
    func setupDataCL(sumIncome: Int, sumExpense: Int, sumByCategoryIncome: [(category: String, amount: Int)], sumByCategoryExpense: [(category: String, amount: Int)]) {
        self.sumIncome = sumIncome
        self.sumExpense = sumExpense
        self.sumByCategoryIncome = sumByCategoryIncome
        self.sumByCategoryExpense = sumByCategoryExpense
        setChart()
    }
    
    func buildChart() {
        chartView.delegate = self
        chartView.rotationEnabled = false
        chartView.transparentCircleRadiusPercent = 0
        chartView.drawEntryLabelsEnabled = false
        
        // set label entry
        let l = chartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .vertical
        l.formToTextSpace = 4
        l.xEntrySpace = 6
        l.xOffset = 15
    }
    
    // Set data chart
    func setChart(){
        entries.removeAll()
        chartView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: self.containerView.frame.size.width,
                                 height: self.containerView.frame.size.height)
        containerView.addSubview(chartView)
        
        if state == "income" {
            lblMoney.text = "\(formatter.string(from: NSNumber(value: sumIncome))!)"
            for index in 0 ..< sumByCategoryIncome.count {
                entries.append(PieChartDataEntry(value: Double(sumByCategoryIncome[index].amount), label: sumByCategoryIncome[index].category))
            }
        } else {
            lblMoney.text = "\(formatter.string(from: NSNumber(value: sumExpense))!)"
            for index in 0 ..< sumByCategoryExpense.count {
                entries.append(PieChartDataEntry(value: Double(sumByCategoryExpense[index].amount), label: sumByCategoryExpense[index].category))
            }
        }
        
        reportView2?.receiveData(income: sumIncome, expense: sumExpense)
        
        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 1
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 22/255, alpha: 1)]
        
        set.valueLinePart1OffsetPercentage = 0.8
        set.valueLinePart1Length = 0.2
        set.valueLinePart2Length = 0.4
        set.xValuePosition = .insideSlice
        
        let data = PieChartData(dataSet: set)
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        set.drawValuesEnabled = false
        data.highlightEnabled = false
        
        chartView.data = data
        chartView.highlightValues(nil)
    }
}

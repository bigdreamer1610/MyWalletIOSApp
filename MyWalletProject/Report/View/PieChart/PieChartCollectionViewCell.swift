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
    var sum = 0
    var sumCate = 0
    var state: State?
    var entries = [ChartDataEntry]()
    var sumByCate = [SumByCate]()
    private var formatter = NumberFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        buildChart()
    }
    
    func setupDataCL(info: SumForPieChart) {
        if state == .income {
            self.sum = info.sumIncome
            self.sumByCate = info.sumByCateIncome
        } else {
            self.sum = info.sumExpense
            self.sumByCate = info.sumByCateExpense
        }
        setChart(sumByCate, sum)
    }
    
    func setupLabel(_ text: String, _ color: UIColor) {
        lblTypeOfMoney.text = text
        lblMoney.textColor = color
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
    func setChart(_ sumBycate: [SumByCate], _ sum: Int) {
        entries.removeAll()
        chartView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: self.containerView.frame.size.width,
                                 height: self.containerView.frame.size.height)
        containerView.addSubview(chartView)
        
        lblMoney.text = "\(formatter.string(from: NSNumber(value: sum))!)"
        
        // set label entry
        if sumBycate.count > 4 {
            for index in 0 ..< 4 {
                entries.append(PieChartDataEntry(value: Double(sumBycate[index].amount), label: sumBycate[index].category))
            }
            for index in 4 ..< sumBycate.count {
                self.sumCate += sumBycate[index].amount
            }
            entries.append(PieChartDataEntry(value: Double(sumCate), label: Constants.other))
        } else {
            for index in 0 ..< sumBycate.count {
                entries.append(PieChartDataEntry(value: Double(sumBycate[index].amount), label: sumBycate[index].category))
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

//
//  DetailPieTableViewCell.swift
//  MyWalletProject
//
//  Created by Nguyen Thi Huong on 9/28/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Charts

class DetailPieTableViewCell: BaseTBCell, ChartViewDelegate {
    
    @IBOutlet weak var containerView: UIView!
    var chartView = PieChartView()
    var entries = [ChartDataEntry]()
    var sumCate = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chartView.delegate = self
        buildChart()
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
    func setChart(_ sumByCategory: [SumByCate]) {
        entries.removeAll()
        chartView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: self.containerView.frame.size.width,
                                 height: self.containerView.frame.size.height)
        containerView.addSubview(chartView)
        
        if sumByCategory.count > 10 {
            for index in 0 ..< 10 {
                entries.append(PieChartDataEntry(value: Double(sumByCategory[index].amount), label: sumByCategory[index].category))
            }
            for index in 10 ..< sumByCategory.count {
                self.sumCate += sumByCategory[index].amount
            }
            entries.append(PieChartDataEntry(value: Double(sumCate), label: Constants.other))
        } else {
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

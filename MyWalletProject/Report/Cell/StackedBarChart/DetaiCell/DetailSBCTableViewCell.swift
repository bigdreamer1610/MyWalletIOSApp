//
//  DetailSBCTableViewCell.swift
//  MyWalletProject
//
//  Created by Nguyen Thi Huong on 9/28/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Charts

//protocol GetDataFromVC {
//    func getData(income: Int, expense: Int)
//}

class DetailSBCTableViewCell: BaseTBCell, ChartViewDelegate {
    
    @IBOutlet weak var containerView: UIView!
    var chartView = BarChartView()
    private var formatter = NumberFormatter()
    let days = [""]
    var sumExpense = 0 {
        didSet {
            setChartData()
        }
    }
    var sumIncome = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        buildChart()
        setChartData()
      
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
    }
    
    //MARK: - Build Chart
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
    
    //MARK: - Setup data for Chart
    func setChartData( ){
        chartView.frame = CGRect(x: -5,
                                 y: 0,
                                 width: containerView.frame.size.width - 30,
                                 height: containerView.frame.size.height)
        containerView.addSubview(chartView)
        
        print("\(sumIncome) heloeojciodi286268 \(sumExpense)")
        
        let val1 = Double(sumIncome)
        let val2 = Double(sumExpense)
        var yVals =  [BarChartDataEntry]()
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
extension DetailSBCTableViewCell: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return days[min(max(Int(value), 0), days.count - 1)]
    }
}


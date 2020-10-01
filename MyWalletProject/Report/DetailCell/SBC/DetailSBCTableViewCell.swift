//
//  DetailSBCTableViewCell.swift
//  MyWalletProject
//
//  Created by Nguyen Thi Huong on 9/28/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit
import Charts
protocol GetDataFromVC {
    func getData(income: Int, expense: Int)
}

class DetailSBCTableViewCell: BaseTBCell, ChartViewDelegate {
   
    @IBOutlet weak var containerView: UIView!
    var chartView = BarChartView()
    
    var income = 0
    var expense = 0
        
    override func awakeFromNib() {
        super.awakeFromNib()
        chartView.delegate = self
        chartView.dragEnabled = false
        setChart()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
    }
    
    func setChart(){
        
        chartView.frame = CGRect(x: 0,
                                 y: 00,
                                 width: self.containerView.frame.size.width - 20,
                                 height: 200)

        containerView.addSubview(chartView)

        var enchies = [BarChartDataEntry]()
        for x in 1..<6 {
            enchies.append(BarChartDataEntry(x: Double(x), y: Double(x)))
        }

        let set = BarChartDataSet(enchies)
        set.colors = ChartColorTemplates.joyful()
        let data = BarChartData(dataSet: set)
        chartView.data = data
    }
    
}

extension DetailSBCTableViewCell: GetDataFromVC{
    func getData(income: Int, expense: Int) {
        self.income = income
        self.expense = expense
    }


}




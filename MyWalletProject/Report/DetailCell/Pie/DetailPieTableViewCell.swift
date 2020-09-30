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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chartView.delegate = self
        
        
        setChart()
    }
    
    func setChart(){
        chartView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: self.containerView.frame.size.width,
                                 height: self.containerView.frame.size.height)
        
        
        containerView.addSubview(chartView)
        
        var cacKhoi = [ChartDataEntry]()
        for i in 1..<6 {
            cacKhoi.append(ChartDataEntry(x: Double(i), y: Double(i), icon: nil))
        }
        let set = PieChartDataSet(cacKhoi)
        set.colors = ChartColorTemplates.joyful()
        let data = PieChartData(dataSet: set)
        chartView.data = data
        
        
    }
    
    
}

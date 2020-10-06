//
//  MonthCell.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 9/28/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class MonthCell: BaseCLCell {
    
    
    @IBOutlet var lbMonth: UILabel!
    var date = Date()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lbMonth.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        // Initialization code
    }
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                self.contentView.backgroundColor = UIColor.red
                self.lbMonth.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.lbMonth.alpha = 1
            }
            else
            {
                self.contentView.backgroundColor = UIColor.gray
                self.lbMonth.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                self.lbMonth.alpha = 0.5
            }
        }
    }
    
    func configure(data: Date){
        var text = ""
        if data.dateComponents.month! == date.dateComponents.month! && data.dateComponents.year! == date.dateComponents.year! {
            text = "THIS MONTH"
        } else if data.dateComponents.month! + 1 == date.dateComponents.month! && date.dateComponents.year! == data.dateComponents.year! {
            text = "LAST MONTH"
        } else {
            text = "\(data.dateComponents.month!)/\(data.dateComponents.year!)"
        }
        lbMonth.text = text
        
    }
    
}

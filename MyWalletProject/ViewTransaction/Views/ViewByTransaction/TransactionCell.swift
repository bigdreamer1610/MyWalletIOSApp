//
//  TransactionCell.swift
//  SecondApp
//
//  Created by THUY Nguyen Duong Thu on 9/18/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class TransactionCell: BaseTBCell {
    
    @IBOutlet var lbAmount: UILabel!
    @IBOutlet var lbNote: UILabel!
    @IBOutlet var lbCategory: UILabel!
    @IBOutlet var iconView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        Defined.formatter.groupingSeparator = "."
        Defined.formatter.numberStyle = .decimal
        // Initialization code
    }
    
    func setUpData(data: TransactionItem){
        lbAmount.text = "\(Defined.formatter.string(from: NSNumber(value: data.amount))!)"
        lbNote.text = data.note
        lbCategory.text = data.categoryName
        iconView.image = UIImage(named: data.iconImage)
        if data.type == TransactionType.expense.getValue(){
            lbAmount.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        } else {
            lbAmount.textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        }
    }
    
    func setupData(data: DetailSBCByDate, state: String){
        lbAmount.text = String((Defined.formatter.string(from: NSNumber(value: data.amount))!))
        lbNote.text = data.note
        lbCategory.text = data.category
        iconView.image = UIImage(named: data.imageName)
        if state == TransactionType.income.getValue() {
            lbAmount.textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        } else {
            lbAmount.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

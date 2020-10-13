//
//  BudgetCell.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 9/30/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class BudgetCell: UITableViewCell {

    @IBOutlet weak var imgCate: UIImageView!
    @IBOutlet weak var lblCate: UILabel!
    @IBOutlet weak var lblSpent: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var prgFormCate: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setLayout(budget:Budget, spend:Int , language:String) {
        imgCate.image = UIImage.init(named: budget.categoryImage ?? "")
        lblCate.text = budget.categoryName?.addLocalizableString(str: language) ?? ""
        lblSpent.text = "\(budget.amount ?? 0)"
        lblStartDate.text = "\(BudgetListDataString.start.rawValue.addLocalizableString(str: language)): \(budget.startDate ?? "")"
        lblEndDate.text = "\(BudgetListDataString.end.rawValue.addLocalizableString(str: language)): \(budget.endDate ?? "")"
        prgFormCate.setProgress((Float(spend))/Float(budget.amount ?? 1), animated: true)
        if(Float((Float(spend))/Float(budget.amount ?? 1)) > 1.0){
            prgFormCate.progressTintColor = UIColor.red
        }
        else{
            prgFormCate.progressTintColor = UIColor(displayP3Red: 0.0/255.0, green: 127.0/255.0, blue: 84.0/255.0, alpha: 1)
        }
    }
    
}

//
//  DetailBudgetCell.swift
//  MyWalletProject
//
//  Created by Hoang Lam on 10/1/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class DetailBudgetCell: UITableViewCell {

    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblSpend: UILabel!
    @IBOutlet weak var lblRest: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var prgSpend: UIProgressView!
    @IBOutlet weak var lblCalendar: UILabel!
    @IBOutlet weak var btnTransaction: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblSpendTitle: UILabel!
    @IBOutlet weak var lblRestTitle: UILabel!
    @IBOutlet weak var lblAmountTitle: UILabel!
    @IBOutlet weak var viewWarningGreen: UIView!
    @IBOutlet weak var viewWarningRed: UIView!
    @IBOutlet weak var lblWarningGreen: UILabel!
    @IBOutlet weak var lblWarningRed: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setDataBackground(cateImage:String , cateName:String , amount:Int , startdate:String , endDate:String , spend: Int , language:String) {
        
        lblSpendTitle.text = BudgetDetailDataString.spend.rawValue.addLocalizableString(str: language)
        lblRestTitle.text = BudgetDetailDataString.left.rawValue.addLocalizableString(str: language)
        lblAmountTitle.text = BudgetDetailDataString.amount.rawValue.addLocalizableString(str: language)
        btnTransaction.setTitle(BudgetDetailDataString.listTransactions.rawValue.addLocalizableString(str: language), for: .normal)
        btnDelete.setTitle(BudgetDetailDataString.delete.rawValue.addLocalizableString(str: language), for: .normal)
        
        imgCategory.image = UIImage(named: cateImage)
        lblCategory.text = cateName.addLocalizableString(str: language)
        lblAmount.text = "\(amount)"
        lblSpend.text = "\(spend)"
        lblRest.text = "\(amount - spend)"
        lblTotalAmount.text = "\(amount)"
        lblCalendar.text = "\(startdate) - \(endDate)"
        
        prgSpend.setProgress((Float(spend))/Float(amount), animated: true)
        
        if(Float((Float(spend))/Float(amount)) > 1.0){
            prgSpend.progressTintColor = UIColor.red
        }
        else{
            prgSpend.progressTintColor = UIColor(displayP3Red: 0.0/255.0, green: 127.0/255.0, blue: 84.0/255.0, alpha: 1)
        }
        
        viewWarningGreen.backgroundColor = UIColor(displayP3Red: 0.0/255.0, green: 127.0/255.0, blue: 84.0/255.0, alpha: 1)
        viewWarningGreen.layer.cornerRadius = viewWarningRed.frame.height / 2
        viewWarningGreen.layer.masksToBounds = true
        viewWarningRed.backgroundColor = UIColor.red
        viewWarningRed.layer.cornerRadius = viewWarningRed.frame.height / 2
        viewWarningRed.layer.masksToBounds = true
        
        lblWarningGreen.text = "Smaller than the spending limit".addLocalizableString(str: language)
        lblWarningGreen.textColor = UIColor(displayP3Red: 0.0/255.0, green: 127.0/255.0, blue: 84.0/255.0, alpha: 1)
        lblWarningRed.text = "Higher than the spending limit".addLocalizableString(str: language)
        lblWarningRed.textColor = UIColor.red
    }
    
}

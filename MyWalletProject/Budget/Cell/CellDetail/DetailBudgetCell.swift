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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setDataBackground(cateImage:String , cateName:String , amount:Int , startdate:String , endDate:String , spend: Int) {
        
        imgCategory.image = UIImage(named: cateImage)
        lblCategory.text = cateName
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
    }
    
}

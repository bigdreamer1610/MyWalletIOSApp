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
    
    func setLayout(categoryImage:String , categoryName:String , amount:Int ,  startDate:String , endDate:String , spent:Int) {
        
        imgCate.image = UIImage.init(named: categoryImage)
        lblCate.text = categoryName
        lblSpent.text = "\(amount)"
        lblStartDate.text = "Start: \(startDate)"
        lblEndDate.text = "End: \(endDate)"
        
        prgFormCate.setProgress((Float(spent))/Float(amount), animated: true)
        
        if(Float((Float(spent))/Float(amount)) > 1.0){
            prgFormCate.progressTintColor = UIColor.red
        }
        else{
            prgFormCate.progressTintColor = UIColor(displayP3Red: 0.0/255.0, green: 127.0/255.0, blue: 84.0/255.0, alpha: 1)
        }
    }
    
}

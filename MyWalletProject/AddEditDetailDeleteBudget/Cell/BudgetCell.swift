//
//  BudgetCell.swift
//  MyWallet
//
//  Created by Hoang Lam on 9/22/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
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
    
//    var id: Int? = nil
//    var categoryName: String? = nil
//    var categoryImage: String? = nil
//    var transactionType: String? = nil
//    var amount: Int? = nil
//    var startDate: String? = nil
//    var endDate: String? = nil
//    var startDateSecondWith1970:Double? = nil
//    var endDateSecondWith1970:Double? = nil

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
            prgFormCate.progressTintColor = UIColor.green
        }
    }
    
}

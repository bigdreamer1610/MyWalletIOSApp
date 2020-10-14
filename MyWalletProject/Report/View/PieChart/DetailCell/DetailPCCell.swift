//
//  IncomDetailTableViewCell.swift
//  MyWalletProject
//
//  Created by Nguyen Thi Huong on 9/28/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class DetailPCCell: BaseTBCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblMoney: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupLabel(_ color: UIColor) {
        lblMoney.textColor = color
    }
    
    func setupView(info: DetailDayPC) {
        lblMoney.text = String((Defined.formatter.string(from: NSNumber(value: info.money))!))
        lblCategory.text = info.category
        categoryImage.image = UIImage(named: info.imageName)
    }
    
}

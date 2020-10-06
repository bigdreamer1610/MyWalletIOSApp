//
//  BottomMenuCell.swift
//  MyWallet
//
//  Created by THUY Nguyen Duong Thu on 9/21/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

protocol BottomMenuCellDelegate: AnyObject {
    func chooseOption(with index: Int)
}
class BottomMenuCell: BaseTBCell {

    static let identifier = "BottomMenuCell"
    
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var iconView: UIImageView!
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpBottomMenu(with data: BottomMenu){
        iconView.image = UIImage(named: data.icon)
        lbTitle.text = data.title
    }
    
}

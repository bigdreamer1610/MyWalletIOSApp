//
//  EventIconCell.swift
//  MyWalletProject
//
//  Created by Van Thanh on 10/8/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class EventIconCell: UICollectionViewCell {

    @IBOutlet weak var IconEvent: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUp(data:String){
        IconEvent.image = UIImage(named: data)
    }
}

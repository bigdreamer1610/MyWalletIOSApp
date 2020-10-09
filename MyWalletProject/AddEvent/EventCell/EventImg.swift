//
//  EventImg.swift
//  MyWalletProject
//
//  Created by Van Thanh on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class EventImg: UICollectionViewCell {

    @IBOutlet weak var lblEvent: UILabel!
    @IBOutlet weak var imgEvent: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    public func load(img: String)  {
    imgEvent.image = UIImage(named: img)
    }
    
}

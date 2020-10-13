//
//  FormatNumber.swift
//  MyWalletProject
//
//  Created by Van Thanh on 10/2/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class FormatNumber: NSObject {
    public func formatInt(so: Int)  -> String{
           
           let numberFormatter = NumberFormatter()
           numberFormatter.numberStyle = .decimal
           numberFormatter.maximumFractionDigits = 3
           var format = numberFormatter.string(from: so as! NSNumber)!
           return format + " VND"
       }


}

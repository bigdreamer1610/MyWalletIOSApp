//
//  Extensions.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/13/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

extension UITextField {
    func setRightImage(imageName: String) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleToFill
        self.rightView = imageView
        imageView.setImageColor(color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        self.rightViewMode = .always
    }
    
    func setRightImage2(imageName: String) {
        let cRightImageView = UIImageView()
        cRightImageView.image = UIImage(named: imageName)
        cRightImageView.setImageColor(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        cRightImageView.contentMode = .scaleToFill
        let cRightView = UIView()
        cRightView.addSubview(cRightImageView)
        rightView?.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        cRightImageView.frame = CGRect(x: -25, y: -7.5, width: 15, height: 15)
        rightView = cRightView
        rightViewMode = .always
    }
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}


extension UIColor {
    public class func colorFromHexString(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


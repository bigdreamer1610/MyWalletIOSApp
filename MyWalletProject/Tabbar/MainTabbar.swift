//
//  MainTabbar.swift
//  IVM
//
//  Created by an.trantuan on 7/2/20.
//  Copyright © 2020 an.trantuan. All rights reserved.
//

import UIKit

let tabbarRadius: CGFloat = 37.0 // bán kính tabbar
let tabbarStartAngle : CGFloat = 210 // góc bắt đầu của thanh tab
let tabbarEndAngle : CGFloat = -30 // góc kết thúc của thanh tab
let middleButtonHeight : CGFloat = (UIScreen.main.bounds.width - 20)/5 // Chiều cao nút giữa
let middleButtonRadius : CGFloat = middleButtonHeight/2 // Bán kính nút giữa

class MainTabbar: UITabBar {
    private var shapeLayer: CALayer? // lớp hình dạng
    var lastArcAngle = -CGFloat.pi // Góc vòng cung cuối cùng

    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPathCircle()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 0.5
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        
        self.shapeLayer = shapeLayer
    }
    
    override func draw(_ rect: CGRect) {
        self.addShape()
    }
    
    func createPath() -> CGPath {
        
        let height: CGFloat = 30.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        
        path.move(to: CGPoint(x: 0, y: 0)) // start top left
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0)) // the beginning of the trough
        // first curve up
        path.addCurve(to: CGPoint(x: centerWidth, y: -height),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 30, y: -height))
        // second curve down
        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 30, y: -height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
        
        // complete the rect
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        
        return path.cgPath
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if point.x >= self.center.x - middleButtonRadius && point.x <= self.center.x + middleButtonRadius {
            return abs(self.center.x - point.x) < middleButtonRadius && abs(point.y) < middleButtonRadius
        } else {
            if point.y < 0 {
                return false
            }
            return true
        }
    }
    
    func createPathCircle() -> CGPath {
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - tabbarRadius), y: 0))
        path.addArc(withCenter: CGPoint(x: centerWidth, y: tabbarRadius/2), radius: tabbarRadius, startAngle: tabbarStartAngle.degreesToRadians, endAngle: tabbarEndAngle.degreesToRadians, clockwise: true)
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path.cgPath
    }
    
}

extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}

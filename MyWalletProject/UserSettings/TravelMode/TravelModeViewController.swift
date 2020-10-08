//
//  TravelModeViewController.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 10/1/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class TravelModeViewController: UIViewController {

    @IBOutlet weak var switchView: UIView!
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var labelEventView: UIView!
    
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    
    @IBOutlet weak var `switch`: UISwitch!
    
    @IBOutlet weak var lblSelectEvent: UILabel!
    @IBOutlet weak var imgEvent: UIImageView!
    
    var switchState = false
    var travelModeState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Travel Mode"
        
        addBorder([switchView, eventView])
        setupGestureForView([eventView])
        
        labelEventView.alpha = 0
        eventView.alpha = 0
    }
    
    // MARK: - Add bottom and top border for views
    func addBorder(_ views: [UIView]) {
        views.forEach { (view) in
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: 0.0, y: view.frame.size.height-1, width: view.frame.width, height: 1.0)
            bottomBorder.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            view.layer.addSublayer(bottomBorder)
            
            let topBorder = CALayer()
            topBorder.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 1.0)
            topBorder.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            view.layer.addSublayer(topBorder)
        }
    }
    
    // MARK: - Setup gesture on view
    func setupGestureForView(_ views: [UIView]) {
        views.forEach { (view) in
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            view.addGestureRecognizer(tap)
            view.isUserInteractionEnabled = true
        }
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
    }
    
    // MARK: - Hide tab bar
    override var hidesBottomBarWhenPushed: Bool {
        get {
            return true
        }
        set {
            super.hidesBottomBarWhenPushed = newValue
        }
    }
    
    func performAnimation(duration: Double, value: CGFloat) {
        UIView.animate(withDuration: duration, animations: {
            self.labelEventView.alpha = value
            self.eventView.alpha = value
        })
    }
    
    @IBAction func switchOn(_ sender: Any) {
        if !switchState {
            performAnimation(duration: 0.5, value: 1)
            switchState = true
        } else {
            performAnimation(duration: 0.5, value: 0)
            switchState = false
        }
    }
    
    @IBAction func btnCancelClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDoneClick(_ sender: Any) {
        if lblSelectEvent.text != "Select Event" {
            print("Passed")
        }
    }
}

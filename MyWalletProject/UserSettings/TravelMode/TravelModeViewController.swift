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
    
    var switchState = false
    var travelModeState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Travel Mode"
        
        addTopBorder(view: switchView)
        addBottomBorder(view: switchView)
        addTopBorder(view: eventView)
        addBottomBorder(view: eventView)
        
        labelEventView.alpha = 0
        eventView.alpha = 0
    }
    
    func addBottomBorder(view: UIView) {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: view.frame.size.height-1, width: view.frame.width, height: 1.0)
        bottomBorder.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.layer.addSublayer(bottomBorder)
    }
    
    func addTopBorder(view: UIView) {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 1.0)
        bottomBorder.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.layer.addSublayer(bottomBorder)
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
    
    @IBAction func switchOn(_ sender: Any) {
        if !switchState {
            UIView.animate(withDuration: 0.5, animations: {
                self.labelEventView.alpha = 1
                self.eventView.alpha = 1
            })
            switchState = true
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.labelEventView.alpha = 0
                self.eventView.alpha = 0
            })
            switchState = false
        }
    }
    
    @IBAction func btnCancelClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

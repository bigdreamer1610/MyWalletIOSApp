//
//  AddEditCategoryViewController.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class AddEditCategoryViewController: UIViewController {

    @IBOutlet weak var selectCategoryView: UIView!
    @IBOutlet weak var categoryTypeView: UIView!
    @IBOutlet weak var selectImageView: UIView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTopBorder([selectCategoryView])
        addBottomBorder([selectCategoryView, categoryTypeView])
        setupGestureForView([selectImageView])
        
        self.title = "Add category"
    }
    
    // MARK: - Add bottom and top border for views
    func addBottomBorder(_ views: [UIView]) {
        views.forEach { (view) in
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: 0.0, y: view.frame.size.height-1, width: view.frame.width, height: 1.0)
            bottomBorder.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            view.layer.addSublayer(bottomBorder)
        }
    }
    func addTopBorder(_ views: [UIView]) {
        views.forEach { (view) in
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
            self.view.addSubview(view)
        }
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
    }
    
    @IBAction func btnCancelClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmentClick(_ sender: Any) {
        
    }
}

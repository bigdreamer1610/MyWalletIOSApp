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
        addRightBorder([selectImageView])
        
        self.title = "Add category"
    }
    
    // MARK: - Add borders for views
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
    func addRightBorder(_ views: [UIView]) {
        views.forEach { (view) in
            let rightBorder = CALayer()
            rightBorder.frame = CGRect(x: view.frame.width - 1.0, y: 0.0, width: 1.0, height: view.frame.height)
            rightBorder.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            view.layer.addSublayer(rightBorder)
        }
    }
    
    // MARK: - Set text for back button
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        backItem.tintColor = UIColor.init(displayP3Red: 52, green: 199, blue: 90, alpha: 1.0)
        navigationItem.backBarButtonItem = backItem
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
        AppRouter.routerTo(from: self, router: .selectIcon, options: .push)
    }
    
    @IBAction func btnCancelClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveClick(_ sender: Any) {
    }
    
    @IBAction func segmentClick(_ sender: Any) {
        
    }
}

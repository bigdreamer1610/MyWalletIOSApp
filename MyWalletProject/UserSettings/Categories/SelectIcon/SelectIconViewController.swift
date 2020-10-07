//
//  SelectIconViewController.swift
//  MyWalletProject
//
//  Created by Vuong Vu Bac Son on 10/7/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

protocol SelectIconViewControllerDelegate {
    func setupForAddCategory(_ index: Int, _ listImageName: [String])
}

class SelectIconViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: SelectIconViewControllerDelegate?
    var listImageName: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    
    // MARK: - Setup for table view
    func setupCollectionView() {
        ImageCollectionViewCell.registerCellByNib(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func segmentControlClick(_ sender: Any) {
        if segmentControl.selectedSegmentIndex != 0 {
            collectionView.isHidden = true
        } else {
            collectionView.isHidden = false
        }
    }
}

extension SelectIconViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImageName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ImageCollectionViewCell.loadCell(collectionView, path: indexPath) as! ImageCollectionViewCell
        cell.setupImage(listImageName[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.setupForAddCategory(indexPath.row, self.listImageName)
        self.navigationController?.popViewController(animated: true)
    }
}

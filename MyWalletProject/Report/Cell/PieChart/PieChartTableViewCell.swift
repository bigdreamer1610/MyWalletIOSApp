//
//  PieChartTableViewCell.swift
//  MyWallet
//
//  Created by Nguyen Thi Huong on 9/23/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

protocol CustomCollectionCellDelegate:class {
    func collectionView(collectioncell:PieChartCollectionViewCell?, didTappedInTableview TableCell:PieChartTableViewCell)
    
}

class PieChartTableViewCell: BaseTBCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
       var date = "" {
        didSet {
            collectionView.reloadData()
        }
    }
    weak var delegate: CustomCollectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }
    
    func setupCollection() {
        PieChartCollectionViewCell.registerCellByNib(collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension PieChartTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PieChartCollectionViewCell.loadCell(collectionView, path: indexPath) as! PieChartCollectionViewCell
        cell.date = date
       
        if indexPath.row == 0 {
            cell.state = 1
            cell.lblTypeOfMoney.text = "Khoản thu"
            cell.lblMoney.textColor = #colorLiteral(red: 0, green: 0.3944762324, blue: 0.9803921569, alpha: 1)
        } else {
            cell.lblTypeOfMoney.text = "Khoản chi"
            cell.lblMoney.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("This is pie chart")
        let cell = PieChartCollectionViewCell.loadCell(collectionView, path: indexPath) as! PieChartCollectionViewCell
        self.delegate?.collectionView(collectioncell: cell, didTappedInTableview: self)
    }
}


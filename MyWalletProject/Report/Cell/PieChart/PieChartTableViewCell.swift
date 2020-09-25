//
//  PieChartTableViewCell.swift
//  MyWallet
//
//  Created by Nguyen Thi Huong on 9/23/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit


class PieChartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellID = "PieChartCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }
    
    func setupCollection() {
        collectionView.register(UINib(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PieChartCollectionViewCell
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
}


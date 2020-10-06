//
//  BaseCLCell.swift
//  fulfii
//
//  Created by an.trantuan on 4/8/19.
//  Copyright © 2019 株式会社Ｇ－Ｐｌａｃｅ. All rights reserved.
//

import UIKit

class BaseCLCell: UICollectionViewCell {
    
    // MARK: define for cell
    static func identifier() -> String {
        return String(describing: self.self)
    }
    
    static func size() -> CGSize {
        return CGSize.zero
    }
    
    static func registerCellByClass(_ collectionView: UICollectionView) {
        collectionView.register(self.self, forCellWithReuseIdentifier: self.identifier())
    }
    
    static func registerCellByNib(_ collectionView: UICollectionView) {
        let nib = UINib(nibName: self.identifier(), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: self.identifier())
    }
    
    static func loadCell(_ collectionView: UICollectionView, path: IndexPath) -> BaseCLCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier(), for: path) as! BaseCLCell
    }
    
}

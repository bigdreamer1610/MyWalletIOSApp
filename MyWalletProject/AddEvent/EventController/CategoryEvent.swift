//
//  CategoryEvent.swift
//  MyWallet
//
//  Created by Van Thanh on 9/23/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CategoryEvent: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
     var completionHandler: ((String) -> Void)?
    var ref: DatabaseReference!
    @IBOutlet weak var clCategoryEvent: UICollectionView!
    
    
    var arrImg:[String] = []{
        didSet {
            print(arrImg)
            clCategoryEvent.reloadData()
        }
    }
    var categoryIcon : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
         getData()
        clCategoryEvent.register(UINib(nibName: "CategoryEventCell", bundle: nil), forCellWithReuseIdentifier: "CategoryEventCell")
        clCategoryEvent.delegate = self
        clCategoryEvent.dataSource = self
       
       
    }
    

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: 50, height: 50)
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: 50, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return arrImg.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryEventCell", for: indexPath) as! CategoryEventCell
        let img = arrImg[indexPath.row].lowercased()
        
        cell.load(iconImg: img)
        
        return cell
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryEventCell
      //  cell.navigationController?.popViewController(animated: true)
        
        completionHandler?(arrImg[indexPath.row].lowercased())
        self.popView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEvent" {
            let cate12 = segue.description as! AddEventController
            
        }
    }
    
    func popView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getData()  {
        
        self.ref.child("Category").child("expense").observeSingleEvent(of: .value, with: {
            snapshot in
            for category in snapshot.children{
                self.arrImg.append((category as AnyObject).key)
                print(self.arrImg.count)
                
            }
            
        })
        
        
    }
        
    
       

}

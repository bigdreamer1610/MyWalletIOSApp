//
//  EventImgViewController.swift
//  MyWalletProject
//
//  Created by Van Thanh on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class EventImgViewController: UIViewController {
    var completionHandler: ((String) -> Void)?
    var number = 0
    @IBOutlet weak var collectionImgView: UICollectionView!
    var presenter: EventImgPresenter?
    var imgs = [String](){
        didSet {
            collectionImgView.reloadData()
        }
    }
    // Load view
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.fetchData1()
        let nib = UINib(nibName: "EventIconCell", bundle: nil)
        collectionImgView.register(nib, forCellWithReuseIdentifier: "EventIconCell")
        collectionImgView.delegate = self
        collectionImgView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    func setUp(presenter: EventImgPresenter) {
        self.presenter = presenter
    }
    
}
extension EventImgViewController: EventImgPresenterDelegate{
    func getNumberOfEventImg(imgs : [String]) {
        self.imgs = imgs
        
    }
     
}
extension EventImgViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imgEvent = collectionView.dequeueReusableCell(withReuseIdentifier: "EventIconCell", for: indexPath) as! EventIconCell
        imgEvent.setUp(data: imgs[indexPath.row])
        return imgEvent
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         completionHandler?(imgs[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
}

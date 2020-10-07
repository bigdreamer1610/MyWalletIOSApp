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
    var presenter: EventImgPresenter?
    var imgs = [String](){
        didSet {
            tableImgView.reloadData()
        }
    }
    @IBOutlet weak var tableImgView: UITableView!
    // Load view
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.fetchData1()
        let nib = UINib(nibName: "EventImg", bundle: nil)
        tableImgView.register(nib, forCellReuseIdentifier: "EventImg")
        tableImgView.delegate = self
        tableImgView.dataSource = self
        
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
extension EventImgViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let imgEvent = tableView.dequeueReusableCell(withIdentifier: "EventImg", for: indexPath) as! EventImg
        imgEvent.load(img: imgs[indexPath.row])
        return imgEvent
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        completionHandler?(imgs[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

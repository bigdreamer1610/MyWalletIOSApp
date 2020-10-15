//
//  EventControllerView.swift
//  MyWalletProject
//
//  Created by Van Thanh on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class EventControllerView: UIViewController {
    
    @IBOutlet weak var eventTable: UITableView!
    @IBOutlet weak var sgm: UISegmentedControl!
    @IBOutlet weak var imgNoEvent: UIImageView!
    @IBOutlet weak var loadViewIndicator: UIActivityIndicatorView!
    
    var presenter: EventPresenter?
    var arrNameEvent = [String]()
    var currenScore: Int!
    var currenKey: String!
   // let navication = UINavigationController()
    var arrEvent: [Event] = []{
        didSet{
            loadViewIndicator.stopAnimating()
            loadViewIndicator.alpha = 0
            eventTable.reloadData()
        }
    }
    
    //load view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        let nib = UINib(nibName: "EventCell", bundle: nil)
        eventTable.register(nib, forCellReuseIdentifier: "EventCell")
        setupSegmentTextColor()
        eventTable.delegate = self
        eventTable.dataSource = self
    }
    deinit {
        print("vanthanhEventmain")
    }
    
    func setupSegmentTextColor() {
        sgm.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.colorFromHexString(hex: "646BDE")], for: UIControl.State.selected)
        sgm.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
    }
    
    func setUp(presenter: EventPresenter)  {
        self.presenter = presenter
    }
    
    @IBAction func sgmMode(_ sender: Any) {
        switch sgm.selectedSegmentIndex {
        case 0:
            arrEvent.removeAll()
            arrNameEvent.removeAll()
            acctivityIndicator()
            presenter?.fetchDataApplying()
        default:
            arrNameEvent.removeAll()
            arrEvent.removeAll()
            acctivityIndicator()
            presenter?.fetchDataFinished()
        }
    }
    
    // back
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // butt add Event
    @IBAction func addEvent(_ sender: Any) {
        let add = UIStoryboard.init(name: "AddEvent", bundle: nil).instantiateViewController(identifier: "AddEventTableController") as! AddEventTableController
        let presenter = AddEventPresenter(delegate: add , userCase: AddEventTableUseCase())
        add.setUp(presenter: presenter)
        add.nameEvents = arrNameEvent
        self.navigationController?.pushViewController(add, animated: true)
    }
}
extension EventControllerView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrEvent.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        cell.load(event: arrEvent[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = UIStoryboard.init(name: "AddEvent", bundle: nil).instantiateViewController(identifier: "DetailEvent")
            as! DetailEventController
        let presenter = DetailPresenter(delegate: detail, useCase: DetailEventUseCase())
        detail.setUp(presenter: presenter)
        detail.event = arrEvent[indexPath.row]
        self.navigationController?.pushViewController(detail, animated: true)
    }
}

extension EventControllerView: EventPresenterDelegate{
    func getDataEvent(arrEvent: [Event], arrNameEvent: [String]) {
        self.arrEvent = arrEvent
        self.arrNameEvent = arrNameEvent
        if arrEvent.count == 0 {
            self.imgNoEvent.alpha = 1
            loadViewIndicator.alpha = 0	
        }
    }
}
extension EventControllerView {
    override func viewWillAppear(_ animated: Bool) {
        sgm.selectedSegmentIndex = 0
        acctivityIndicator()
        loadViewIndicator.startAnimating()
        presenter?.fetchDataApplying()
    }
}

extension EventControllerView{
    func acctivityIndicator()  {
        loadViewIndicator.startAnimating()
        loadViewIndicator.alpha = 1
        imgNoEvent.alpha = 0
    }
}

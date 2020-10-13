//
//  DetailTransactionViewController.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/6/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class DetailTransactionViewController: UIViewController {

    @IBOutlet var imageEvent: UIImageView!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblEvent: UILabel!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var lbNote: UILabel!
    @IBOutlet var eventView: UIView!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    
    var presenter: DetailTransactionPresenter?
    var transactions = [Transaction]()
    var transactionid: String = ""
    var categoryName:String = ""
    var categoryNote: String = ""
    var categoryDate:String = ""
    var eventName: String = ""
    var type: String = ""
    var amount: Int = 0
    var icon: String = ""
    var dateModel: DateModel!
    
    var event: Event?
    var transaction: Transaction!
    var eventid: String? = nil
    
    var language = ChangeLanguage.english.rawValue

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        customizeLayout()
        setLanguage()
        Defined.formatter.groupingSeparator = "."
        Defined.formatter.numberStyle = .decimal
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        indicator.startAnimating()
        if transactionid != "" {
            fetchTransaction(id: transactionid)
        }
    }

    func setLanguage(){
        btnDelete.setTitle(DetailTransactionDataString.delete.rawValue.addLocalizableString(str: language), for: .normal)
        btnBack.title = DetailTransactionDataString.back.rawValue.addLocalizableString(str: language)
        navigationItem.title = DetailTransactionDataString.detailTransaction.rawValue.addLocalizableString(str: language)
        lbTitle.text = DetailTransactionDataString.event.rawValue.addLocalizableString(str: language)

    }
    
    func setUp(presenter: DetailTransactionPresenter){
        self.presenter = presenter
    }
    
    func customizeLayout(){
        btnDelete.layer.cornerRadius = 6
        lbTitle.isHidden = true
        eventView.isHidden = true
    }
    
    func initData(){
        iconImage.image = UIImage(named: icon)
        lblDate.text = categoryDate
        lbNote.text = categoryNote
        lblCategory.text = categoryName
        lblEvent.text = eventName
        lblAmount.text = Defined.formatter.string(from: NSNumber(value: amount))!
        
    }

    func fetchTransaction(id: String){
        presenter?.fetchTransaction(id: id)
    }
    
    func setUpDataTransactionView(item: TransactionItem, header: TransactionHeader){
        self.transactionid = item.id
        
    }
    
    func setUpDataCategoryView(item: CategoryItem, header: CategoryHeader){
        self.transactionid = item.id
        
    }
    // mark: - event nil
    @IBAction func btnEditTransaction(_ sender: Any) {
        AppRouter.routerTo(from: self, router: .edit(trans: self.transaction, event: self.event ?? Event(), cateName: self.categoryName, cateImage: self.icon), options: .push)
    }
    
    
    @IBAction func clickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDelateTransaction(_ sender: Any) {
        let alert = UIAlertController(title: DetailTransactionDataString.delete.rawValue.addLocalizableString(str: language), message:DetailTransactionDataString.alertTitle.rawValue.addLocalizableString(str: language) , preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: DetailTransactionDataString.cancel.rawValue.addLocalizableString(str: language),
                                      style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: DetailTransactionDataString.yes.rawValue.addLocalizableString(str: language),
                                      style: .default, handler: { action in
            self.presenter?.deleteTransaction(t: self.transaction)
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
        
    }
    

}

extension DetailTransactionViewController : DetailTransactionPresenterDelegate {
    func getEvent(event: Event) {
        self.event = event
        if self.event != nil {
            lbTitle.isHidden = false
            eventView.isHidden = false
            eventName = event.name!
            lblEvent.text = event.name!
            imageEvent.image = UIImage(named: event.eventImage!)
        }
        
    }
    
    func getTransaction(transaction: Transaction) {
        self.transaction = transaction
    }
    
    func getCategory(cate: Category) {
        type = transaction.transactionType!
        categoryName = cate.name!
        categoryNote = transaction.note!
        amount = transaction.amount!
        icon = cate.iconImage!
        var date = Defined.convertStringToDate(str: transaction.date!)
        date = Defined.calendar.date(byAdding: .day, value: 1, to: date)!
        dateModel = Defined.getDateModel(components: date.dateComponents)
        categoryDate = "\(dateModel.weekDay), \(dateModel.date) \(dateModel.month) \(dateModel.year)"
        indicator.stopAnimating()
        indicator.isHidden = true
        //init data
        initData()
        
    }
    
    func noEvent() {
        lbTitle.isHidden = true
        eventView.isHidden = true
    }
    
}

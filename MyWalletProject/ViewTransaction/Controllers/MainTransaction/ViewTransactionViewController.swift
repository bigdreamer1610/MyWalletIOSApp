//
//  ViewTransactionViewController.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/2/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class ViewTransactionViewController: UIViewController {
    
    var presenter: ViewTransactionPresenter?
    var bottomMenuView = UIView()
    var tableView = UITableView()
    var height: CGFloat = 190
    var transactionBotMenu = [
        BottomMenu(icon: "adjustbalance", title: "Adjust balance"),
        BottomMenu(icon: "viewbytransaction", title: "View by transaction"),
        BottomMenu(icon: "today", title: "Jump to today")
    ]
    var categoryBotMenu = [
        BottomMenu(icon: "adjustbalance", title: "Adjust balance"),
        BottomMenu(icon: "viewbycategory", title: "View by category"),
        BottomMenu(icon: "today", title: "Jump to today")
    ]
    
    var monthTitles = [Date]()
    var transactionSections = [TransactionSection]()
    var categorySections = [CategorySection]()
    
    var balance = 0
    var opening = 0
    var ending = 0
    var total = 0
    var current = Date()
    var today = Date()
    var todayMonth = 9
    var todayYear = 2020
    var currentMonth = 9
    var currentYear = 2020
    var mode = UserDefaults.standard.string(forKey: "viewmode")
    
    @IBOutlet var monthCollectionView: UICollectionView!
    @IBOutlet var btnShowMore: UIButton!
    @IBOutlet var transactionTableView: UITableView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var centerIndicator: UIActivityIndicatorView!
    var refreshControl = UIRefreshControl()
    @IBOutlet var centerLabel: UILabel!
    @IBOutlet var centerIcon: UIImageView!
    @IBOutlet var noTransaction: UIStackView!
    @IBOutlet var lbBalance: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        self.tabBarController?.tabBar.tintColor = UIColor.colorFromHexString(hex: "564f64")
        //set up date
        todayYear = Defined.calendar.component(.year, from: today)
        todayMonth = Defined.calendar.component(.month, from: today)
        currentMonth = todayMonth
        currentYear = todayYear
        current = today
        Defined.defaults.set(current, forKey: Constants.currentDate)
        setUpCurrentDate(month: currentMonth, year: currentYear)
        //init data
        initData(month: Defined.defaults.integer(forKey: Constants.currentMonth), year: Defined.defaults.integer(forKey: Constants.currentYear))
        
        setUpNoTransaction(status: true)
        Defined.dateFormatter.locale = Locale(identifier: "vi_VN")
        Defined.dateFormatter.dateFormat = "dd/MM/yyyy"

        if mode == nil {
            UserDefaults.standard.set(Mode.transaction.getValue(), forKey: Constants.mode)
            mode = Mode.transaction.getValue()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        DispatchQueue.main.async {
            self.current = Defined.dateFormatter.date(from: "02/\(Defined.defaults.integer(forKey: Constants.currentMonth))/\(Defined.defaults.integer(forKey: Constants.currentYear))")!
            self.startLoading()
            self.initData(month: Defined.defaults.integer(forKey: Constants.currentMonth), year: Defined.defaults.integer(forKey: Constants.currentYear))
            self.jumpToDate(from: self.current)
        }
    }
    
    func setUp(presenter: ViewTransactionPresenter){
        self.presenter = presenter
    }
    
    func setUpCurrentDate(month: Int, year: Int){
        Defined.defaults.set(month, forKey: Constants.currentMonth)
        Defined.defaults.set(year, forKey: Constants.currentYear)
    }
    
    fileprivate func initData(month: Int, year: Int){
        transactionTableView.isHidden  = true
        presenter?.setUpMonthYear(month: month, year: year)
        presenter?.fetchData()
    }
    
    fileprivate func initComponents(){
        DetailCell.registerCellByNib(transactionTableView)
        HeaderTransactionCell.registerCellByNib(transactionTableView)
        TransactionCell.registerCellByNib(transactionTableView)
        HeaderCategoryCell.registerCellByNib(transactionTableView)
        TransactionDayCell.registerCellByNib(transactionTableView)
        
        BottomMenuCell.registerCellByNib(tableView)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled  = false
        
        MonthCell.registerCellByNib(monthCollectionView)
        
        transactionTableView.dataSource = self
        transactionTableView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        monthCollectionView.dataSource = self
        monthCollectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        monthCollectionView.collectionViewLayout = layout
        monthCollectionView.isScrollEnabled = false
        
        //setup button show more
        btnShowMore.tintColor = UIColor.colorFromHexString(hex: "776d8a")
        let image = UIImage(named: "iconmore")?.withRenderingMode(.alwaysTemplate)
        btnShowMore.setImage(image, for: .normal)
        btnShowMore.tintColor = UIColor.colorFromHexString(hex: "776d8a")
        
        centerIcon.setImageColor(color: UIColor.colorFromHexString(hex: "776d8a"))
        
    }
    
    
    @IBAction func clickMore(_ sender: Any) {
        let window = UIApplication.shared.keyWindow
        bottomMenuView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        bottomMenuView.frame = self.view.frame
        window?.addSubview(bottomMenuView)
        let screenSize = UIScreen.main.bounds.size
        tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: Constants.menuCell * CGFloat(transactionBotMenu.count))
        window?.addSubview(tableView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        bottomMenuView.addGestureRecognizer(tapGesture)
        bottomMenuView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.bottomMenuView.alpha = 0.5
            self.tableView.frame = CGRect(x: 0, y: screenSize.height - self.height, width: screenSize.width, height: self.height)
        }, completion: nil)
    }
    
    func animateOutScreen(){
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.bottomMenuView.alpha = 0
            self.tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
        }, completion: nil)
    }
    
    @objc func onClickTransparentView() {
        animateOutScreen()
    }
    
    
    //MARK: - Get indexpath of the month in collectionview menu
    func getIndexPathOfThisMonthCell(from date: Date) -> Int{
        for i in 0..<monthTitles.count {
            if monthTitles[i].dateComponents.month == date.dateComponents.month && monthTitles[i].dateComponents.year == date.dateComponents.year {
                return i
            }
        }
        return -1
    }
    
}

extension ViewTransactionViewController {
    fileprivate func jumpToDate(from date: Date){
        let firstIndexPath = IndexPath(item: getIndexPathOfThisMonthCell(from: date), section: 0)
        monthCollectionView.selectItem(at: firstIndexPath, animated: true, scrollPosition: .centeredHorizontally)
        setUpCurrentDate(month: date.dateComponents.month!, year: date.dateComponents.year!)
    }
}


extension ViewTransactionViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number = 0
        switch tableView {
        case transactionTableView:
            if section == 0 {
                number = 1
            } else {
                switch mode {
                case Mode.transaction.getValue():
                    number = transactionSections[section-1].items.count
                default:
                    number = categorySections[section-1].items.count
                }
            }
        default:
            number = transactionBotMenu.count
        }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var myCell = UITableViewCell()
        switch tableView {
        case transactionTableView:
            if indexPath.section == 0 {
                let cell = DetailCell.loadCell(tableView) as! DetailCell
                cell.selectionStyle = .none
                cell.setUpData(opening: opening, ending: ending)
                myCell = cell
            } else {
                switch mode {
                case Mode.transaction.getValue():
                    let cell = TransactionCell.loadCell(tableView) as! TransactionCell
                    cell.setUpData(data: transactionSections[indexPath.section-1].items[indexPath.row])
                    myCell = cell
                default:
                    let cell = TransactionDayCell.loadCell(tableView) as! TransactionDayCell
                    cell.setUpData(with: categorySections[indexPath.section-1].items[indexPath.row])
                    myCell = cell
                }
                
            }
        default:
            let cell = BottomMenuCell.loadCell(tableView) as! BottomMenuCell
            if mode == Mode.transaction.getValue(){
                cell.setUpBottomMenu(with: categoryBotMenu[indexPath.row])
            } else {
                cell.setUpBottomMenu(with: transactionBotMenu[indexPath.row])
            }
            myCell = cell
        }
        return myCell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var number = 1
        switch tableView {
        case transactionTableView:
            switch mode {
            case Mode.transaction.getValue():
                number = transactionSections.count + 1
            default:
                number = categorySections.count + 1
            }
        default:
            number = 1
        }
        return number
    }
    
    //check selection at bottom menu
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case self.tableView:
            if indexPath.row == 0 {
                AppRouter.routerTo(from: self, router: .balance, options: .present)
            } else if indexPath.row == 1 {
                if mode == Mode.transaction.getValue() {
                    mode = Mode.category.getValue()
                    Defined.defaults.set(mode, forKey: Constants.mode)
                } else {
                    self.tableView.reloadData()
                    mode = Mode.transaction.getValue()
                    Defined.defaults.set(mode, forKey: Constants.mode)
                }
                self.transactionTableView.reloadData()
                self.tableView.reloadData()
            } else if indexPath.row == 2 {
                presenter?.getDataTransaction(month: todayMonth, year: todayYear)
                jumpToDate(from: today)
            }
            animateOutScreen()
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            if indexPath.section != 0 {
                switch mode {
                case Mode.transaction.getValue():
                    AppRouter.routerTo(from: self, router: .transactionDetail(item: transactionSections[indexPath.section - 1].items[indexPath.row], header: transactionSections[indexPath.section - 1].header), options: .push)
                    
                default:
                    AppRouter.routerTo(from: self, router: .categoryDetail(item: categorySections[indexPath.section-1].items[indexPath.row], header: categorySections[indexPath.section-1].header), options: .push)
                }
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
}

extension ViewTransactionViewController : UITableViewDelegate {
    //MARK: - Header View for section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var myView = UIView()
        switch tableView {
        case transactionTableView:
            if section != 0 {
                if mode == Mode.transaction.getValue(){
                    let cell = HeaderTransactionCell.loadCell(tableView) as! HeaderTransactionCell
                    cell.setUpData(data: transactionSections[section-1].header)
                    myView = cell
                } else {
                    let cell = HeaderCategoryCell.loadCell(tableView) as! HeaderCategoryCell
                    cell.setUpData(with: categorySections[section-1].header)
                    myView = cell
                }
            }
        default:
            myView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        }
        return myView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
        myView.backgroundColor = UIColor.groupTableViewBackground
        return myView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var myHeight: CGFloat = 0
        if section != 0 {
            if mode == Mode.transaction.getValue(){
                myHeight = Constants.transactionHeader
            } else {
                myHeight = Constants.categoryHeader
            }
        } else {
            myHeight = 0
        }
        return myHeight
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var myHeight: CGFloat = 0
        switch tableView {
        case transactionTableView:
            if mode == Mode.transaction.getValue(){
                if indexPath.section == 0 {
                    myHeight = Constants.detailCell
                } else {
                    myHeight = Constants.transactionRow
                }
            } else {
                if indexPath.section == 0 {
                    myHeight = Constants.detailCell
                } else {
                    myHeight = Constants.categoryRow
                }
            }
        default:
            myHeight = Constants.menuCell
        }
        return myHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == transactionTableView {
            return 30
        }
        return 0
    }
    
    
}

//MARK: MENU CELL
extension ViewTransactionViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = MonthCell.loadCell(collectionView, path: indexPath) as! MonthCell
        cell.configure(data: monthTitles[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let month = monthTitles[indexPath.row].dateComponents.month,
                let year = monthTitles[indexPath.row].dateComponents.year{
                //reset default current month, year
                setUpCurrentDate(month: month, year: year)
                // reset current date
                current = Defined.dateFormatter.date(from: "02/\(month)/\(year)")!
                // reload data transaction
                presenter?.getDataTransaction(month: Defined.defaults.integer(forKey: Constants.currentMonth), year: Defined.defaults.integer(forKey: Constants.currentYear))
                //mark selected cell
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
                //scroll tableview to top
                scrollToTop()
            }
    }

    
    
}

extension ViewTransactionViewController : ViewTransactionPresenterDelegate {
    
    func getBalance(balance: Int) {
        self.balance = balance
        let test = Defined.formatter.string(from: NSNumber(value: balance))!
        self.lbBalance.text = "\(test) đ"
        Defined.defaults.set(balance, forKey: Constants.balance)
        reloadTableView()
    }
    
    func startLoading() {
        centerIndicator.startAnimating()
        transactionTableView.isHidden = true
        loadingView.isHidden = false
        centerIndicator.isHidden = false
        setUpNoTransaction(status: true)
    }
    
    func endLoading() {
        loadingView.isHidden = true
        centerIndicator.isHidden = true
        centerIndicator.stopAnimating()
    }
    
    func getDetailCellInfo(info: DetailInfo) {
        opening = info.opening
        ending = info.ending
        reloadTableView()
        
    }
    
    func noFinalTransactions() {
        setUpNoTransaction(status: false)
    }
    
    func setUpNoTransaction(status: Bool){
        self.centerIcon.isHidden = status
        self.centerLabel.isHidden = status
        self.transactionTableView.isHidden = !status
    }
    
    func yesFinalTransactions() {
        setUpNoTransaction(status: true)
    }
    
    func getTransactionSections(section: [TransactionSection]) {
        self.transactionSections = section
        reloadTableView()
    }
    
    func getCategorySections(section: [CategorySection]) {
        self.categorySections  = section
        reloadTableView()
    }
    
    func reloadTableView() {
        self.transactionTableView.reloadData()
    }
    
    func getMonthYearMenu(dates: [Date]) {
        self.monthTitles = dates
    }
    func scrollToTop() {
        if categorySections.count != 0 || transactionSections.count != 0 {
            transactionTableView.scrollToRow(at:IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
}

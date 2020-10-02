//
//  ViewTransactionController.swift
//  SecondApp
//
//  Created by THUY Nguyen Duong Thu on 9/18/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MonthYearPicker

enum TransactionType: String {
    case expense = "expense"
    case income = "income"

    func getValue() -> String {
        return self.rawValue
    }
}


class ViewTransactionController: UIViewController {
    var window: UIWindow?
    var bottomMenuView = UIView()
    var tableView = UITableView()
    var height: CGFloat = 190
    var categories = [Category]()
    var balance = Defined.defaults.integer(forKey: Constants.balance)
    //var balance = Defined.defaults.integer(forKey: Constants.balance)
    var dates = [TransactionDate]()
    //var months = ["01","02","03","04","05","06","07","08","09","10","11","12"]
    var months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    var weekdays = ["Sunday","Monday","Tuesday","Wednesday","Thurday","Friday","Saturday"]

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
    //main class
    var transactionHeaders = [TransactionHeader]()
    var transactionSections = [TransactionSection]()
    var categorySections = [CategorySection]()

    var opening = 0
    var ending = 0
    var total = 0
    var currentMonth = 8
    var currentYear = 2020
    var current = Date()
    var today = Date()
    var minDate: Date!
    var maxDate: Date!
    var todayMonth = 9
    var todayYear = 2020
    var mode = UserDefaults.standard.string(forKey: "viewmode")
    var userid = Defined.defaults.string(forKey: Constants.userid)
    var allTransactions = [Transaction]()
    var finalTransactions = [Transaction]()


    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var monthCollectionView: UICollectionView!
    @IBOutlet var btnShowMore: UIButton!
    @IBOutlet var transactionTableView: UITableView!
    @IBOutlet var viewByCategoryTableView: UITableView!
    
    @IBOutlet var loadingView: UIView!
    @IBOutlet var centerIndicator: UIActivityIndicatorView!
    var refreshControl = UIRefreshControl()
    @IBOutlet var centerLabel: UILabel!
    @IBOutlet var centerIcon: UIImageView!
    @IBOutlet var noTransaction: UIStackView!
    
    @IBOutlet var lbBalance: UILabel!

    override func viewDidLoad() {

        super.viewDidLoad()
        todayYear = Defined.calendar.component(.year, from: today)
        todayMonth = Defined.calendar.component(.month, from: today)
        currentMonth = todayMonth
        currentYear = todayYear
        current = today
        centerIcon.isHidden = true
        centerLabel.isHidden = true
        
        Defined.dateFormatter.locale = Locale(identifier: "vi_VN")
        Defined.dateFormatter.dateFormat = "dd/MM/yyyy"
        //mode
        setUpMode(transaction: false, category: true)
        if userid == nil {
            userid = "userid1"
            Defined.defaults.set(userid, forKey: Constants.userid)
        }
        initTableViews()
        fetchData()
        //check mode
        if mode == nil {
            UserDefaults.standard.set("transaction", forKey: "viewmode")
            mode = "transaction"
        }
        minDate = Defined.calendar.date(byAdding: .year, value: -2, to: today)
        maxDate = Defined.calendar.date(byAdding: .month, value: 1, to: today)
        monthTitles = getMonthYearInRange(from: minDate, to: maxDate)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.getDataTransactions(month: self.currentMonth, year: self.currentYear)
            self.jumpToDate(from: self.current)
            print("current: \(self.current)")
        }
    }
    func jumpToDate(from date: Date){
        let firstIndexPath = IndexPath(item: getIndexPathOfThisMonthCell(from: date), section: 0)
        print("this date: \(date)")
        monthCollectionView.selectItem(at: firstIndexPath, animated: true, scrollPosition: .centeredHorizontally)
    }

    //MARK: - Set up view mode
    func setUpMode(transaction: Bool, category: Bool){
        transactionTableView.isHidden = transaction
        viewByCategoryTableView.isHidden = category
    }

    func initTableViews(){
        DetailCell.registerCellByNib(transactionTableView)
        HeaderTransactionCell.registerCellByNib(transactionTableView)
        TransactionCell.registerCellByNib(transactionTableView)

        DetailCell.registerCellByNib(viewByCategoryTableView)
        HeaderCategoryCell.registerCellByNib(viewByCategoryTableView)
        TransactionDayCell.registerCellByNib(viewByCategoryTableView)

        BottomMenuCell.registerCellByNib(tableView)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled  = false

        MonthCell.registerCellByNib(monthCollectionView)

        transactionTableView.dataSource = self
        transactionTableView.delegate = self
        viewByCategoryTableView.dataSource = self
        viewByCategoryTableView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        monthCollectionView.dataSource = self
        monthCollectionView.delegate = self

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        monthCollectionView.collectionViewLayout = layout
        monthCollectionView.isScrollEnabled = false
    }

    //MARK: - Get all month year in range min-max to set collectionview menu
    func getMonthYearInRange(from startDate: Date, to endDate: Date) -> [Date] {
        let components = Defined.calendar.dateComponents(Set([.month]), from: startDate, to: endDate)
        //var allDates: [String] = []
        var allDates: [Date] = []
        let dateRangeFormatter = DateFormatter()
        dateRangeFormatter.dateFormat = "MM yyyy"

        for i in 1...components.month! {
            guard let date = Defined.calendar.date(byAdding: .month, value: i, to: startDate) else {
                        continue
                        }
            allDates.append(date)
        }
        return allDates
    }

    //MARK: - Get indexpath of the month in collectionview menu
    func getIndexPathOfThisMonthCell(from date: Date) -> Int{
        for i in 0..<monthTitles.count {
            if monthTitles[i].dateComponents.month == today.dateComponents.month && monthTitles[i].dateComponents.year == today.dateComponents.year {
                return i
            }
        }
        return 0
    }
    //MARK: - Get All Transaction at month/year
    func getDataTransactions(month: Int, year: Int){
        allTransactions.removeAll()
        finalTransactions.removeAll()
        transactionSections.removeAll()
        categorySections.removeAll()
        if finalTransactions.count == 0 {
            centerIndicator.startAnimating()
            transactionTableView.isHidden = true
            viewByCategoryTableView.isHidden = true
            loadingView.isHidden = false
            centerIcon.isHidden = true
            centerLabel.isHidden = true
        }
        //MARK: - Get All Transactions
        Defined.ref.child("Account/userid1/transaction").observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let `self` = self else {
                return
            }
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for mySnap in snapshots {
                    let transactionType = (mySnap as AnyObject).key as String
                    if let snaps = mySnap.children.allObjects as? [DataSnapshot]{
                        for snap in snaps {
                            let id = snap.key
                            if let value = snap.value as? [String: Any]{
                                let amount = value["amount"] as! Int
                                let categoryid = value["categoryid"] as! String
                                let date = value["date"] as! String
                                var transaction = Transaction(id: id, transactionType: transactionType, amount: amount, categoryid: categoryid, date: date)
                                if let note = value["note"] as? String {
                                    transaction.note = note
                                }
                                if let eventid = value["eventid"] as? String {
                                    transaction.eventid = eventid
                                }
                                self.allTransactions.append(transaction)
                            }
                        }
                    }
                }
                
                self.getTransactionbyMonth(month: month, year: year)
                self.loadingView.isHidden = true
                self.loadDetailCell(month: month, year: year)
                self.centerIndicator.isHidden = true
                if self.finalTransactions.count == 0 {
                    self.noTransaction.isHidden = false
                    self.centerIcon.isHidden = false
                    self.centerLabel.isHidden = false
                    self.setUpMode(transaction: true, category: true)
                } else {

                    self.getTransactionSections(list: self.finalTransactions)
                    //view by category
                    self.getCategorySections(list: self.finalTransactions)
                    if self.mode == "transaction" {
                        self.setUpMode(transaction: false, category: true)
                    } else {
                        self.setUpMode(transaction: true, category: false)
                    }
                    self.transactionTableView.reloadData()
                    self.viewByCategoryTableView.reloadData()
                    self.centerIndicator.stopAnimating()
            }
        }
        }
        

    }
    //MARK: - Get Transactions by month
    func getTransactionbyMonth(month: Int, year: Int){
        //date model of given month year
        dates = getDateArray(arr: getAllDayArray(), month: month, year: year)
        //get transaction by month
        finalTransactions = getTransactionbyDate(dateArr: dates)
    }
    //MARK: - Data in the detail cell including: Opening & Ending Balance
    func loadDetailCell(month: Int, year: Int){
        var open = 0
        var end = 0
        let previousMonth = (month == 1) ? 12 : (month - 1)
        let previousYear = (month == 1) ? (year - 1) : year
        let previousDates = getDateArray(arr: getAllDayArray(), month: previousMonth, year: previousYear)
        let currentDates = getDateArray(arr: getAllDayArray(), month: month, year: year)

        if previousDates.count == 0 {
            open = 0
        } else {
            for t in getTransactionbyDate(dateArr: previousDates){
                if t.transactionType == TransactionType.expense.getValue() {
                    open -= t.amount!
                } else {
                    open += t.amount!
                }
            }
        }

        if currentDates.count == 0 {
            end = 0
        } else {
            for t in getTransactionbyDate(dateArr: currentDates){
                if t.transactionType == TransactionType.expense.getValue() {
                    end -= t.amount!
                } else {
                    end += t.amount!
                }
            }
        }
        opening = open
        ending = end
    }

    func getDateModel(components: DateComponents) -> DateModel{
        let weekDay = components.weekday!
        let month = components.month!
        let date = components.day!
        let year = components.year!
        let model = DateModel(date: date, month: months[month-1], year: year, weekDay: weekdays[weekDay-1])
        return model
    }
    //MARK: - Get all sections in transaction view mode
    func getTransactionSections(list: [Transaction]){
        var sections = [TransactionSection]()
        for a in dates {
            var items = [TransactionItem]()
            var amount = 0
            //header
            for b in list {
                if a.dateString == b.date {
                    //MARK: - Get count for each header amount
                    if b.transactionType == TransactionType.expense.getValue(){
                        amount -= b.amount!
                    } else {
                        amount += b.amount!
                    }
                    //let note = b.note ?? ""
                    //MARK: - Get Item for each section of header
                    var categoryName = ""
                    var icon = ""
                    var type = ""
                    for c in categories {
                        if b.categoryid == c.id {
                            categoryName = c.name!
                            icon = c.iconImage!
                            type = c.transactionType!
                            break
                        }
                    }
                    var item = TransactionItem(id: "\(b.id!)", categoryName: categoryName,amount: b.amount!, iconImage: icon, type: type)
                    if let note = b.note {
                        item.note = note
                    }
                    items.append(item)
                }
            }
            let components = Defined.convertToDate(resultDate: a.dateString)
            let dateModel = getDateModel(components: components)
            let th = TransactionHeader(dateModel: dateModel, amount: amount)
            sections.append(TransactionSection(header: th, items: items))

        }
        transactionSections = sections
        //return sections
    }
    //MARK: - Get All transaction from the given month/year
    func getTransactionbyDate(dateArr: [TransactionDate]) -> [Transaction]{
        var list = [Transaction]()
        for day in dateArr {
            for tran in allTransactions {
                if tran.date == day.dateString {
                    list.append(tran)
                }
            }
        }
        return list
    }
    //MARK: - Get all sections in category view mode
    func getCategorySections(list: [Transaction]){
        var sections = [CategorySection]()
        let categoryArray = getAllCategoryArray()
        for c in categoryArray {
            var items = [CategoryItem]()
            var categoryName = ""
            var iconImage = ""
            var amount = 0
            for b in finalTransactions {

                if b.categoryid == c {
                    let amount2 = b.amount!
                    let type = b.transactionType!
                    let note = b.note ?? ""
                    //MARK: - Get total amount for header
                    if b.transactionType == TransactionType.expense.getValue(){
                        amount -= b.amount!
                    } else {
                        amount += b.amount!
                    }
                    //MARK: - Get item for each section
                    let components = Defined.convertToDate(resultDate: b.date!)
                    let dateModel = getDateModel(components: components)
                    items.append(CategoryItem(id: b.id!,dateModel: dateModel, amount: amount2,type: type, note: note))
                }
            }
            for a in categories {
                if c == a.id {
                    categoryName = a.name!
                    iconImage = a.iconImage!
                    break
                }
            }
            let ch = CategoryHeader(categoryName: categoryName, noOfTransactions: items.count, amount: amount, icon: iconImage)
            sections.append(CategorySection(header: ch, items: items))
        }
        categorySections = sections
    }

    //MARK: - Get all day string array sorted descending
    func getAllDayArray() -> [String]{
        let myArray = allTransactions
        var checkArray = [String]()
        //MARK: - Get all distinct date string
        for a in myArray {
            var check = false
            for b in checkArray {
                if a.date == b {
                    check = true
                }
            }
            if !check {
                checkArray.append(a.date!)
            }
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "vi_VN")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        //MARK: - Sort date string
        let sortedArray = checkArray.sorted { (first, second) -> Bool in
            dateFormatter.date(from: first)?.compare(dateFormatter.date(from: second)!) == ComparisonResult.orderedDescending
        }
        return sortedArray
    }
    //MARK: - Get all categories from transaction list
    func getAllCategoryArray() -> [String]{
        var checkArray = [String]()
        for a in finalTransactions {
            var check = false
            for b in checkArray {
                if a.categoryid == b {
                    check = true
                }
            }
            if !check {
                checkArray.append(a.categoryid!)
            }
        }
        return checkArray
    }
    
    func fetchData(){
        let dispatchGroup = DispatchGroup()
        
        //MARK: - Get Balance
        dispatchGroup.enter()
        Defined.ref.child("Account/userid1/information/balance").observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? Int {
                self.balance = value
            }
        }
        dispatchGroup.leave()
        
        //MARK: - Get Category
        dispatchGroup.enter()
        Defined.ref.child("Category").observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let `self` = self else {return}
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                //expense/income
                for mySnap in snapshots {
                    let myKey = (mySnap as AnyObject).key as String
                    //key inside expense/income
                    if let mySnap = mySnap.children.allObjects as? [DataSnapshot]{
                        for snap in mySnap {
                            let id = snap.key
                            if let value = snap.value as? [String: Any]{
                                let name = value["name"] as? String
                                let iconImage = value["iconImage"] as? String
                                let transactionType =  myKey
                                let category = Category(id: id, name: name, transactionType: transactionType, iconImage: iconImage)
                                self.categories.append(category)
                            }
                        }
                    }
                }
            }
        }
        dispatchGroup.leave()
        
        dispatchGroup.notify(queue: .main) {
            Defined.defaults.setValue(self.balance, forKey: Constants.balance)
            self.lbBalance.text = "\(Defined.formatter.string(from: NSNumber(value: self.balance))!) đ"
            
            self.transactionTableView.reloadData()
            self.viewByCategoryTableView.reloadData()
        }
    }

    //MARK: - GET Transaction date in descending order from date string array
    func getDateArray(arr: [String], month: Int, year: Int) -> [TransactionDate]{
        var list = [TransactionDate]()
        var mDates = [Date]()
        for a in arr {
            let myDate = a
            let date = Defined.dateFormatter.date(from: myDate)
            let components = Defined.calendar.dateComponents([.day, .month, .year, .weekday], from: date!)
            //if year & month = given
            if components.month == month && components.year == year {
                mDates.append(date!)
            }
        }
        //sort descending
        mDates = mDates.sorted { (first, second) -> Bool in
            first.compare(second) == ComparisonResult.orderedDescending        }
        //Date style: 18/09/2020
        Defined.dateFormatter.dateStyle = .short
        for d in mDates {
            let t = TransactionDate(dateString: Defined.dateFormatter.string(from: d), date: d)
            list.append(t)
        }
        return list
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
    
    @IBAction func clickAddTransaction(_ sender: Any) {
        let vc = RouterType.test.getVc()
        AppRouter.routerTo(from: vc, options: .transitionCrossDissolve, duration: 0.2, isNaviHidden: false)
    }
    
}

extension ViewTransactionController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number = 0
        switch tableView {
        case transactionTableView:
            if section == 0 {
                number = 1
            } else {
                number = transactionSections[section-1].items.count
            }
        case viewByCategoryTableView:
            if section == 0 {
                number = 1
            } else {
                number = categorySections[section-1].items.count
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
                let cell = TransactionCell.loadCell(tableView) as! TransactionCell
                cell.setUpData(data: transactionSections[indexPath.section-1].items[indexPath.row])
                myCell = cell
            }

        case viewByCategoryTableView:
            if indexPath.section == 0 {
                let cell = DetailCell.loadCell(tableView) as! DetailCell
                cell.selectionStyle = .none
                cell.setUpData(opening: opening, ending: ending)
                myCell = cell
            } else {
                let cell = TransactionDayCell.loadCell(tableView) as! TransactionDayCell
                cell.setUpData(with: categorySections[indexPath.section-1].items[indexPath.row])
                myCell = cell
            }
        default:
            let cell = BottomMenuCell.loadCell(tableView) as! BottomMenuCell
            if mode == "transaction"{
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
            number = transactionSections.count + 1
        case viewByCategoryTableView:
            number = categorySections.count + 1
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
                let vc = RouterType.balance.getVc()
                AppRouter.routerTo(from: vc, options: .transitionCrossDissolve, duration: 0.3, isNaviHidden: false)
            } else if indexPath.row == 1 {
                if mode == "transaction" {
                    mode = "category"
                    viewByCategoryTableView.reloadData()
                    Defined.defaults.set(mode, forKey: Constants.mode)
                    setUpMode(transaction: true, category: false)
                } else {
                    transactionTableView.reloadData()
                    mode = "transaction"
                    Defined.defaults.set(mode, forKey: Constants.mode)
                    setUpMode(transaction: false, category: true)
                }
                self.tableView.reloadData()

            } else if indexPath.row == 2 {
                getDataTransactions(month: todayMonth, year: todayYear)
                jumpToDate(from: today)
            }
            animateOutScreen()
            tableView.deselectRow(at: indexPath, animated: true)
        case transactionTableView:
            if indexPath.section != 0 {
                let vc = RouterType.transactionDetail(item: transactionSections[indexPath.section - 1].items[indexPath.row], header: transactionSections[indexPath.section - 1].header).getVc()
                self.navigationController?.pushViewController(vc, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        default:
            if indexPath.section != 0 {
                let vc = RouterType.categoryDetail(item: categorySections[indexPath.section-1].items[indexPath.row], header: categorySections[indexPath.section-1].header).getVc()
                self.navigationController?.pushViewController(vc, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }

}

extension ViewTransactionController : UITableViewDelegate {
    //MARK: - Header View for section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var myView = UIView()
        switch tableView {
        case transactionTableView:
            if section != 0 {
                let cell = HeaderTransactionCell.loadCell(tableView) as! HeaderTransactionCell
                cell.setUpData(data: transactionSections[section-1].header)
                myView = cell
            }
        case viewByCategoryTableView:
            if section != 0 {
                let cell = HeaderCategoryCell.loadCell(tableView) as! HeaderCategoryCell
                cell.setUpData(with: categorySections[section-1].header)
                myView = cell
            }
        default:
            myView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        }
        return myView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var myHeight: CGFloat = 0
        switch tableView {
        case transactionTableView:
            //if not the first detail view
            if section != 0 {
                myHeight = Constants.transactionHeader
            } else {
                myHeight = 0
            }
        case viewByCategoryTableView:
            if section != 0 {
                myHeight = Constants.categoryHeader
            } else {
                myHeight = 0
            }
        default:
            myHeight = 0
        }
        return myHeight

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var myHeight: CGFloat = 0
        switch tableView {
        case transactionTableView:
            if indexPath.section == 0 {
                myHeight = Constants.detailCell
            } else {
                myHeight = Constants.transactionRow
            }
        case viewByCategoryTableView:
            if indexPath.section == 0 {
                myHeight = Constants.detailCell
            } else {
                myHeight = Constants.categoryRow
            }
        default:
            myHeight = Constants.menuCell
        }
        return myHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == transactionTableView || tableView == viewByCategoryTableView {
            return 30
        }
        return 0
    }


}
extension UITextField {
    func setRightImage(imageName: String) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                imageView.image = UIImage(named: imageName)
                imageView.contentMode = .scaleToFill
                self.rightView = imageView;
                self.rightViewMode = .always
    }
}
//MARK: MENU CELL
extension ViewTransactionController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
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
            currentMonth = month
            currentYear = year
            current = Defined.dateFormatter.date(from: "02/\(month)/\(year)")!
            getDataTransactions(month: currentMonth, year: currentYear)
            //current = dateFormatter.date(from: "02/\(currentMonth)/\(currentYear)")!
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        }

    }


}


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



class ViewTransactionController: UIViewController {
    var window: UIWindow?
    var bottomMenuView = UIView()
    var tableView = UITableView()
    var height: CGFloat = 250
    private var dateFormatter = DateFormatter()
    
    //MARK: HEIGHT FOR CELL & HEADER
    let transactionHeader: CGFloat = 60
    let categoryHeader: CGFloat = 65
    let categoryRow: CGFloat = 70
    let transactionRow: CGFloat = 65
    let detailCell: CGFloat = 135
    let menuCell: CGFloat = 60
    
    var categories = [Category]()
    var balance = MyDatabase.defaults.integer(forKey: Key.balance)
    var dates = [TransactionDate]()
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
    
    var testDateModels = [
        Date("01/01/2020", format: "dd/MM/yyyy", region: .current),
        Date("01/02/2020", format: "dd/MM/yyyy", region: .current),
        Date("01/03/2020", format: "dd/MM/yyyy", region: .current),
        Date("01/04/2020", format: "dd/MM/yyyy", region: .current),
        Date("01/05/2020", format: "dd/MM/yyyy", region: .current),
        Date("01/06/2020", format: "dd/MM/yyyy", region: .current),
        Date("01/07/2020", format: "dd/MM/yyyy", region: .current),
        Date("01/08/2020", format: "dd/MM/yyyy", region: .current),
        Date("01/09/2020", format: "dd/MM/yyyy", region: .current),
        Date("01/10/2020", format: "dd/MM/yyyy", region: .current)
    ]
    
    //main class
    var transactionHeaders = [TransactionHeader]()
    var transactionSections = [TransactionSection]()
    var categorySections = [CategorySection]()
    
    var opening = 0
    var ending = 0
    var total = 0
    
    var currentMonth = 8
    var currentYear = 2020
    
    var today = Date()
    let calendar = Calendar.current
    var todayMonth = 9
    var todayYear = 2020
    var mode = UserDefaults.standard.string(forKey: "viewmode")
    var userid = MyDatabase.defaults.string(forKey: Key.userid)
    var allTransactions = [Transaction]()
    var finalTransactions = [Transaction]()
    var previousTransactions = [Transaction]()
    
    
    @IBOutlet var monthCollectionView: UICollectionView!
    @IBOutlet var btnShowMore: UIButton!
    @IBOutlet var btnMore: UIBarButtonItem!
    @IBOutlet var transactionTableView: UITableView!
    @IBOutlet var viewByCategoryTableView: UITableView!
    
    @IBOutlet var loadingView: UIView!
    @IBOutlet var centerIndicator: UIActivityIndicatorView!
    var refreshControl = UIRefreshControl()
    
    @IBOutlet var centerLabel: UILabel!
    @IBOutlet var centerIcon: UIImageView!
    @IBOutlet var noTransaction: UIStackView!
    
    @IBOutlet var txtDatePicker: UITextField!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        txtDatePicker.tintColor = .clear
        createDatePicker()
        createToolBar()
        todayYear = calendar.component(.year, from: today)
        todayMonth = calendar.component(.month, from: today)
        currentMonth = todayMonth
        currentYear = todayYear
        print("today month: \(todayMonth)")
        centerIcon.isHidden = true
        centerLabel.isHidden = true
        dateFormatter.locale = Locale(identifier: "vi_VN")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        //mode
        setUpMode(transaction: false, category: true)
        if balance == 0 {
            MyDatabase.defaults.set(100, forKey: Key.balance)
        }
        if userid == nil {
            userid = "userid1"
            MyDatabase.defaults.set(userid, forKey: Key.userid)
        }
        initTableViews()
        getDataCategory()
        txtDatePicker.text = "\(months[todayMonth - 1]) \(todayYear)"
        txtDatePicker.setLeftImage(imageName: "dropdownicon")
        //check mode
        if mode == nil {
            UserDefaults.standard.set("transaction", forKey: "viewmode")
            mode = "transaction"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        DispatchQueue.main.async {
            self.getDataTransactions(month: self.currentMonth, year: self.currentYear)
        }
        let firstIndexPath = IndexPath(item: 8, section: 0)
        monthCollectionView.selectItem(at: firstIndexPath, animated: true, scrollPosition: .centeredHorizontally)
        /*
         getDataTransactions(month: todayMonth, year: todayYear)
         txtDatePicker.text = "\(months[todayMonth - 1]) \(todayYear)"
         */
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    
    //    func getTimeRange(){
    //        let dateString = "12/02/2020"
    //        let date0 = dateFormatter.date(from: dateString)
    //        let date = Date()
    //        let month = calendar.component(.month, from: date)
    //        let range = calendar.range(of: .day, in: .month, for: date0!)
    //        print("Number of day in \(month): \(range?.count)")
    //    }
    
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
        
        
        
        
    }
    
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
        //get transaction expense
        MyDatabase.ref.child("Account/userid1/transaction/expense").observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let `self` = self else {
                return
            }
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    let id = snap.key
                    if let value = snap.value as? [String: Any]{
                        let transactionType = "expense"
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
                        if let budgetid = value["budgetid"] as? String {
                            transaction.budgetid = budgetid
                        }
                        self.allTransactions.append(transaction)
                        
                    }
                }
                self.transactionTableView.reloadData()
                self.viewByCategoryTableView.reloadData()
            }
        }
        MyDatabase.ref.child("Account/userid1/transaction/income").observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let `self` = self else {
                return
            }
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    let id = snap.key
                    if let value = snap.value as? [String: Any]{
                        let transactionType = "income"
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
                        if let budgetid = value["budgetid"] as? String {
                            transaction.budgetid = budgetid
                        }
                        self.allTransactions.append(transaction)
                    }
                }
                
                self.getTransactionbyMonth(month: month, year: year)
                self.transactionTableView.isHidden = false
                self.loadingView.isHidden = true
                self.loadDetailCell(month: month, year: year)
                self.centerIndicator.isHidden = true
                if self.finalTransactions.count == 0 {
                    self.noTransaction.isHidden = false
                    self.centerIcon.isHidden = false
                    self.centerLabel.isHidden = false
                    self.setUpMode(transaction: false, category: false)
                } else {
                    self.getTransactionSections(list: self.finalTransactions)
                    //view by category
                    self.getCategorySections(list: self.finalTransactions)
                    self.transactionTableView.reloadData()
                    if self.mode == "transaction" {
                        self.setUpMode(transaction: false, category: true)
                    } else {
                        self.setUpMode(transaction: true, category: false)
                    }
                    self.viewByCategoryTableView.reloadData()
                    self.centerIndicator.stopAnimating()
                }
                
            }
        }
        
    }
    //MARK: - Get Transaction by month
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
                if t.transactionType == "expense" {
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
                if t.transactionType == "expense" {
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
                    if b.transactionType == "expense"{
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
            let components = convertToDate(resultDate: a.dateString)
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
                    if b.transactionType == "expense"{
                        amount -= b.amount!
                    } else {
                        amount += b.amount!
                    }
                    //MARK: - Get item for each section
                    let components = convertToDate(resultDate: b.date!)
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
    
    func getBalance() -> Int{
        var a:Int = 0
        MyDatabase.ref.child("Account/userid2/information/balance").observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? Int {
                self.balance = value
                a = value
                self.transactionTableView.reloadData()
                self.viewByCategoryTableView.reloadData()
                //return value
            }
        }
        return a
    }
    
    //MARK: - Convert String to DateComponents
    func convertToDate(resultDate: String) -> DateComponents {
        let myDate = resultDate
        let date = dateFormatter.date(from: myDate)
        let components = calendar.dateComponents([.day, .month, .year, .weekday], from: date!)
        return components
    }
    //MARK: - GET Transaction date in descending order from date string array
    func getDateArray(arr: [String], month: Int, year: Int) -> [TransactionDate]{
        var list = [TransactionDate]()
        var mDates = [Date]()
        for a in arr {
            let myDate = a
            let date = dateFormatter.date(from: myDate)
            let components = calendar.dateComponents([.day, .month, .year, .weekday], from: date!)
            //if year & month = given
            if components.month == month && components.year == year {
                mDates.append(date!)
            }
        }
        //sort descending
        mDates = mDates.sorted { (first, second) -> Bool in
            first.compare(second) == ComparisonResult.orderedDescending        }
        //Date style: 18/09/2020
        dateFormatter.dateStyle = .short
        for d in mDates {
            let t = TransactionDate(dateString: dateFormatter.string(from: d), date: d)
            list.append(t)
        }
        return list
    }
    //MARK: - Get Category array
    func getDataCategory(){
        var myList = [Category]()
        MyDatabase.ref.child("Category").child("expense").observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let `self` = self else {
                return
            }
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    let id = snap.key
                    if let value = snap.value as? [String: Any]{
                        let name = value["name"] as? String
                        let iconImage = value["iconImage"] as? String
                        let transactionType = "expense"
                        let category = Category(id: id, name: name, transactionType: transactionType, iconImage: iconImage)
                        myList.append(category)
                    }
                }
            }
        }
        MyDatabase.ref.child("Category").child("income").observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let `self` = self else {
                return
            }
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    let id = snap.key
                    if let value = snap.value as? [String: Any]{
                        let name = value["name"] as? String
                        let iconImage = value["iconImage"] as? String
                        let transactionType = "income"
                        let category = Category(id: id, name: name, transactionType: transactionType, iconImage: iconImage)
                        myList.append(category)
                    }
                }
                self.categories.append(contentsOf: myList)
                
            }
        }
    }
    
    
    @IBAction func clickMore(_ sender: Any) {
        let window = UIApplication.shared.keyWindow
        bottomMenuView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        bottomMenuView.frame = self.view.frame
        window?.addSubview(bottomMenuView)
        
        let screenSize = UIScreen.main.bounds.size
        tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: height)
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
    
    func createDatePicker(){
        let picker = MonthYearPickerView(frame: CGRect(origin: CGPoint(x: 0, y: (view.bounds.height - 216) / 2), size: CGSize(width: view.bounds.width, height: 216)))
        picker.minimumDate = Calendar.current.date(byAdding: .year, value: -2, to: Date())
        picker.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        txtDatePicker.inputView = picker
    }
    
    @objc func dateChanged(_ picker: MonthYearPickerView) {
        let components = calendar.dateComponents([.day, .month, .year, .weekday], from: picker.date)
        txtDatePicker.text = "\(months[components.month! - 1]) \(components.year!)"
        currentMonth = components.month!
        currentYear = components.year!
        getDataTransactions(month: currentMonth, year: currentYear)
        transactionTableView.reloadData()
        viewByCategoryTableView.reloadData()
    }
    
    func createToolBar(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        txtDatePicker.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard(_ picker: MonthYearPickerView){
        view.endEditing(true)
    }
}

//
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
                let vc = UIStoryboard.init(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "navi_first") as? FirstNavigationController
                vc?.modalPresentationStyle = .fullScreen
                self.present(vc!, animated: true, completion: nil)
            } else if indexPath.row == 1 {
                if mode == "transaction" {
                    mode = "category"
                    viewByCategoryTableView.reloadData()
                    MyDatabase.defaults.set(mode, forKey: Key.mode)
                    setUpMode(transaction: true, category: false)
                } else {
                    transactionTableView.reloadData()
                    mode = "transaction"
                    MyDatabase.defaults.set(mode, forKey: Key.mode)
                    setUpMode(transaction: false, category: true)
                }
                self.tableView.reloadData()
                
            } else if indexPath.row == 2 {
                getDataTransactions(month: todayMonth, year: todayYear)
                txtDatePicker.text = "\(months[todayMonth - 1]) \(todayYear)"
            }
            animateOutScreen()
            tableView.deselectRow(at: indexPath, animated: true)
        case transactionTableView:
            if indexPath.section != 0 {
                print("Section: \(indexPath.section), row: \(indexPath.row)")
                let vc = UIStoryboard.init(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "detail") as? DetailTransactionController
                vc?.setUpDataTransactionView(item: transactionSections[indexPath.section - 1].items[indexPath.row], header: transactionSections[indexPath.section - 1].header)
                self.navigationController?.pushViewController(vc!, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        default:
            if indexPath.section != 0 {
                print("Section: \(indexPath.section), row: \(indexPath.row)")
                let vc = UIStoryboard.init(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "detail") as? DetailTransactionController
                vc?.setUpDataCategoryView(item: categorySections[indexPath.section-1].items[indexPath.row], header: categorySections[indexPath.section-1].header)
                self.navigationController?.pushViewController(vc!, animated: true)
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
                myHeight = transactionHeader
            } else {
                myHeight = 0
            }
        case viewByCategoryTableView:
            if section != 0 {
                myHeight = categoryHeader
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
                myHeight = detailCell
            } else {
                myHeight = transactionRow
            }
        case viewByCategoryTableView:
            if indexPath.section == 0 {
                myHeight = detailCell
            } else {
                myHeight = categoryRow
            }
        default:
            myHeight = menuCell
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

extension UITextField{
    
    func setLeftImage(imageName:String) {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = UIImage(named: imageName)
        self.leftView = imageView;
        self.leftViewMode = .always
    }
}

extension ViewTransactionController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testDateModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = MonthCell.loadCell(collectionView, path: indexPath) as! MonthCell
        cell.configure(data: testDateModels[indexPath.row]!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let month = testDateModels[indexPath.row]?.dateComponents.month,
            let year = testDateModels[indexPath.row]?.dateComponents.year{
            currentMonth = month
            currentYear = year
            getDataTransactions(month: currentMonth, year: currentYear)
            txtDatePicker.text = "\(months[currentMonth - 1]) \(currentYear)"
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
        
    }
    
    
}

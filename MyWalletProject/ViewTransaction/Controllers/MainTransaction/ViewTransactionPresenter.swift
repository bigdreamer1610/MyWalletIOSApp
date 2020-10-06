//
//  ViewTransactionPresenter.swift
//  MyWalletProject
//
//  Created by THUY Nguyen Duong Thu on 10/2/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

protocol ViewTransactionPresenterDelegate: class {
    func getBalance(balance: Int)
    func startLoading()
    func endLoading()
    func getDetailCellInfo(info: DetailInfo)
    func loadingViewHidden()
    func loadingViewShow()
    func centerIndicatorHidden()
    func noFinalTransactions()
    func yesFinalTransactions()
    func getTransactionSections(section: [TransactionSection])
    func getCategorySections(section: [CategorySection])
    func reloadTableView()
    func getMonthYearMenu(dates: [Date])
}

class ViewTransactionPresenter {
    weak var delegate: ViewTransactionPresenterDelegate?
    fileprivate var viewTransUseCase: ViewTransactionUseCase?
    var categories: [Category]?
    var finalTransactions = [Transaction]()
    var allTransactions = [Transaction]()
    var dates = [TransactionDate]()
    var minDate = Date()
    var maxDate = Date()
    var currentMonth = 8
    var currentYear = 2020
    var today = Date()
    var transactionSections = [TransactionSection]()
    var categorySections = [CategorySection]()
    
    var weekdays = ["Sunday","Monday","Tuesday","Wednesday","Thurday","Friday","Saturday"]
    var months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    
    init(delegate: ViewTransactionPresenterDelegate, usecase: ViewTransactionUseCase) {
        self.delegate = delegate
        self.viewTransUseCase = usecase
        self.viewTransUseCase?.delegate = self
    }
    
    //Get data balance and category
    func fetchData(){
        minDate = Defined.calendar.date(byAdding: .year, value: -2, to: today)!
        maxDate = Defined.calendar.date(byAdding: .month, value: 1, to: today)!
        //monthTitles = getMonthYearInRange(from: minDate, to: maxDate)
        viewTransUseCase?.getBalance()
        viewTransUseCase?.getListCategories()
        getMonthYearInRange(from: minDate, to: maxDate)
    }
    
    // Get data transaction by month
    func getDataTransaction(month: Int, year: Int){
        delegate?.startLoading()
        viewTransUseCase?.getAllTransactions()
        getTransactionbyMonth(month: month, year: year)
        loadDetailCell(month: month, year: year)
        delegate?.endLoading()
        delegate?.loadingViewHidden()
        delegate?.centerIndicatorHidden()
        delegate?.reloadTableView()
        if finalTransactions.count == 0 {
            delegate?.noFinalTransactions()
        } else {
            getTransactionSections(list: self.finalTransactions)
            getCategorySections(list: self.finalTransactions)
            delegate?.yesFinalTransactions()
        }
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
                    for c in categories! {
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
                    if let eventid = b.eventid {
                        item.eventid = eventid
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
        delegate?.getTransactionSections(section: sections)
    }
    
    //MARK: - Get all sections in category view mode
    func getCategorySections(list: [Transaction]){
        var sections = [CategorySection]()
        let categoryArray = getAllCategoryArray()
        categoryArray.forEach { (c) in
            var items = [CategoryItem]()
            var categoryName = ""
            var iconImage = ""
            var amount = 0
            finalTransactions.forEach { (b) in
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
                    var item = CategoryItem(id: b.id!,dateModel: dateModel, amount: amount2,type: type, note: note)
                    if let eventid = b.eventid {
                        item.eventid = eventid
                    }
                    items.append(item)
                }
            }
            for a in categories! {
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
        delegate?.getCategorySections(section: sections)
    }
}

extension ViewTransactionPresenter : ViewTransactionUseCaseDelegate {
    func responseAllTransactions(trans: [Transaction]) {
        self.allTransactions = trans
        getTransactionbyMonth(month: currentMonth, year: currentYear)
    }
    
    func responseCategories(cate: [Category]) {
        self.categories = cate
    }
    
    func responseBalance(balance: Int) {
        delegate?.getBalance(balance: balance)
    }
    
}

extension ViewTransactionPresenter {
    //MARK: - Get all categories from transaction list
    func getAllCategoryArray() -> [String]{
        var checkArray = [String]()
        finalTransactions.forEach { (a) in
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
    func getDateModel(components: DateComponents) -> DateModel{
        let weekDay = components.weekday!
        let month = components.month!
        let date = components.day!
        let year = components.year!
        let model = DateModel(date: date, month: months[month-1], year: year, weekDay: weekdays[weekDay-1])
        return model
    }
    //MARK: - Get all day string array sorted descending
    func getAllDayArray() -> [String]{
        var checkArray = [String]()
        //MARK: - Get all distinct date string
        allTransactions.forEach { (a) in
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
    
    //MARK: - GET Transaction date in descending order from date string array
    func getDateArray(arr: [String], month: Int, year: Int) -> [TransactionDate]{
        var list = [TransactionDate]()
        var mDates = [Date]()
        arr.forEach { (a) in
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
        mDates.forEach { (d) in
            let t = TransactionDate(dateString: Defined.dateFormatter.string(from: d), date: d)
            list.append(t)
        }
        return list
    }
    //MARK: - Get Transactions by month
    func getTransactionbyMonth(month: Int, year: Int){
        //date model of given month year
        dates = getDateArray(arr: getAllDayArray(), month: month, year: year)
        //get transaction by month
        finalTransactions = getTransactionbyDate(dateArr: dates)
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
    
    func loadDetailCell(month: Int, year: Int){
        let previousMonth = (month == 1) ? 12 : (month - 1)
        let previousYear = (month == 1) ? (year - 1) : year
        let previousDates = getDateArray(arr: getAllDayArray(), month: previousMonth, year: previousYear)
        let currentDates = getDateArray(arr: getAllDayArray(), month: month, year: year)
        let open = calculateDetail(list: getTransactionbyDate(dateArr: previousDates))
        let end = calculateDetail(list: getTransactionbyDate(dateArr: currentDates))
        delegate?.getDetailCellInfo(info: DetailInfo(opening: open, ending: end))
    }
    
    // calculate sum amount of given list in a months
    func calculateDetail(list: [Transaction]) -> Int {
        var number = 0
        list.forEach { (a) in
            if a.transactionType == TransactionType.expense.getValue(){
                number -= a.amount!
            } else {
                number -= a.amount!
            }
        }
        return number
    }
    
    
    
    //MARK: - Get all month year in range min-max to set collectionview menu
    func getMonthYearInRange(from startDate: Date, to endDate: Date){
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
        delegate?.getMonthYearMenu(dates: allDates)
    }
}

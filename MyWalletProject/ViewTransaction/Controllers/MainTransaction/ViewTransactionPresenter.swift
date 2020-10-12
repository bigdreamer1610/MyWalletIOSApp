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
    func noFinalTransactions()
    func yesFinalTransactions()
    func getTransactionSections(section: [TransactionSection])
    func getCategorySections(section: [CategorySection])
    func reloadTableView()
    func getMonthYearMenu(dates: [Date])
    func scrollToTop()
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
    var month: Int = 0
    var year: Int = 0
//
//    var weekdays = ["Sunday","Monday","Tuesday","Wednesday","Thurday","Friday","Saturday"]
//    var months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
//
//
    init(delegate: ViewTransactionPresenterDelegate, usecase: ViewTransactionUseCase) {
        self.delegate = delegate
        self.viewTransUseCase = usecase
        self.viewTransUseCase?.delegate = self
    }
    //Get data balance and category
    func fetchData(){
        minDate = Defined.calendar.date(byAdding: .year, value: -2, to: today)!
        maxDate = Defined.calendar.date(byAdding: .month, value: 1, to: today)!
        viewTransUseCase?.getBalance()
        viewTransUseCase?.getListCategories()
        getMonthYearInRange(from: minDate, to: maxDate)
    }
    // set up month year when change time
    func setUpMonthYear(month: Int, year: Int){
        self.month = month
        self.year = year
    }
    
    // load transaction to set up sections
    func getFirstTransaction(){
        //delegate?.startLoading()
        viewTransUseCase?.getAllTransactions()
    }
    
    // Get data transaction by month
    func getDataTransaction(month: Int, year: Int){
        getTransactionbyMonth(month: month, year: year)
        loadDetailCell(month: month, year: year)
        
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
            let dateModel = Defined.getDateModel(components: components)
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
                    let dateModel = Defined.getDateModel(components: components)
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
    
    //MARK: - GET Transaction date in descending order from date string array
    func getDateArray(arr: [String], month: Int, year: Int) -> [TransactionDate]{
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
        return Defined.getTransactionDates(dates: mDates)
    }
    //MARK: - Get Transactions by month
    func getTransactionbyMonth(month: Int, year: Int){
        //date model of given month year
        dates = getDateArray(arr: Defined.getAllDayArray(allTransactions: allTransactions), month: month, year: year)
        //get transaction by month
        finalTransactions = getTransactionbyDate(dateArr: dates)
        // check
        // no transaction final
        if finalTransactions.count == 0{
            delegate?.noFinalTransactions()
            // there is transaction
        } else {
            getTransactionSections(list: finalTransactions)
            getCategorySections(list: finalTransactions)
            delegate?.yesFinalTransactions()
        }
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
        let previousDates = getDateArray(arr: Defined.getAllDayArray(allTransactions: allTransactions), month: previousMonth, year: previousYear)
        let currentDates = getDateArray(arr: Defined.getAllDayArray(allTransactions: allTransactions), month: month, year: year)
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

extension ViewTransactionPresenter : ViewTransactionUseCaseDelegate {
    func responseAllTransactions(trans: [Transaction]) {
        DispatchQueue.main.async {
            self.delegate?.endLoading()
            self.allTransactions = trans
            self.getDataTransaction(month: self.month, year: self.year)
        }
    }
    
    func responseCategories(cate: [Category]) {
        DispatchQueue.main.async {
            self.categories = cate
            self.getFirstTransaction()
            
        }
    }
    
    func responseBalance(balance: Int) {
        DispatchQueue.main.async {
            self.delegate?.getBalance(balance: balance)
        }
        
    }
    
}

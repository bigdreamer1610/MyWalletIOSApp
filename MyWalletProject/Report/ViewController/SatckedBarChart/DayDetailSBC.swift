//
//  DayDetailSBC.swift
//  MyWalletProject
//
//  Created by Nguyen Thi Huong on 9/29/20.
//  Copyright © 2020 Vuong Vu Bac Son. All rights reserved.
//

import UIKit

class DayDetailSBC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let transactionHeader: CGFloat = 60
    let transactionRow: CGFloat = 65
    let detailCell: CGFloat = 135
    var transactionSections = [TransactionSection]()
    var date = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableViews()
        self.title = "14/09/2020 - 20/09/2020"
    }
    
    @IBAction func popToView(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func initTableViews(){
        tableView.delegate = self
        tableView.dataSource = self
        DayDetail.registerCellByNib(tableView)
        HeaderTransactionCell.registerCellByNib(tableView)
        TransactionCell.registerCellByNib(tableView)
    }
}

extension DayDetailSBC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = DayDetail.loadCell(tableView) as! DayDetail
            cell.selectionStyle = .none
            return cell
            
        } else {
            let cell = TransactionCell.loadCell(tableView) as! TransactionCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            print("Hello My friend")
            let vc = UIStoryboard.init(name: "ViewTransaction", bundle: nil).instantiateViewController(withIdentifier: "detail") as! DetailTransactionController
            //            vc.setUpDataTransactionView(item: transactionSections[indexPath.section - 1].items[indexPath.row], header: transactionSections[indexPath.section - 1].header)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension DayDetailSBC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = HeaderTransactionCell.loadCell(tableView) as! HeaderTransactionCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var myHeight: CGFloat = 0
        if section != 0 {
            myHeight = transactionHeader
        } else {
            myHeight = 0
        }
        return myHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var myHeight: CGFloat = 0
        
        if indexPath.section == 0 {
            myHeight = detailCell
        } else {
            myHeight = transactionRow
        }
        return myHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == tableView  {
            return 30
        }
        return 0
    }
}

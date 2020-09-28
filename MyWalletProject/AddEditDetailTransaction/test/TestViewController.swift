//
//  TestViewController.swift
//  MyWallet
//
//  Created by BAC Vuong Toan (VTI.Intern) on 9/24/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Firebase

class TestViewController: UIViewController {
    
    var cellId = "TestViewCell"
    var transaction = [Transaction]()
    
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName:cellId , bundle: nil), forCellReuseIdentifier: cellId)
        GetListTransaction()
    }
    
    func GetListTransaction(){
        //MyDatabase.ref = Database.database().reference().child("Account").child("userid1").child("transaction").child("expense")
        MyDatabase.ref.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.transaction.removeAll()
                for artist in snapshot.children.allObjects as! [DataSnapshot] {
                    let art = artist.value as? [String:AnyObject]
                    let artAmount = art?["amount"]
                    let artCategoryid = art?["categoryid"]
                    let artDate = art?["date"]
                    let artNote = art?["note"]
                    print(artNote)
                    let arts = Transaction( amount: artAmount as? Int, categoryid: artCategoryid as? String, date: artDate as? String, note: artNote as? String)
                    //let arts = Expense(name: artName as? String, iconImage: artImage as? String)
                    self.transaction.append(arts)
                }
                self.tableview.reloadData()
            }
        }
    }
}
extension TestViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TestViewCell
        cell.setUp(data: transaction[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Bac", bundle: nil).instantiateViewController(withIdentifier: "detail") as? DetailTransactionController
        let ex = transaction[indexPath.row]
        vc?.categoryNote = ex.note ?? ""
        vc?.categoryDate = ex.date ?? ""
        vc?.categoryName = ex.categoryid ?? ""
        vc?.amount = ex.amount ?? 1
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
}

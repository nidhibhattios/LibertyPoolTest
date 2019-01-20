//
//  MyTransactionDataSource.swift
//  LibertyPoolTest
//
//  Created by Nidhi  on 18/01/19.
//  Copyright © 2019 LibertyPool. All rights reserved.
//

import Foundation
import UIKit

class MyTransactionDataSource: GenericDataSource<Transactions>, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value[section].sortedTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction = data.value[indexPath.section].sortedTransactions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell") as! TransactionTableViewCell
        cell.configureTransactionCell(transaction: transaction)
        return cell
    }
}

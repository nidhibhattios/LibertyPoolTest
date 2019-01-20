//
//  TransactionTableViewCell.swift
//  LibertyPoolTest
//
//  Created by Nidhi  on 18/01/19.
//  Copyright © 2019 LibertyPool. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet var mainContainView: ShadowView!
   
    @IBOutlet var transactionTypeIndicatorView: UIView!
    
    @IBOutlet var currencyTypeImageView: UIImageView!
    
    @IBOutlet var transactionTypeLabel: UILabel!
    
    @IBOutlet var currencyLabel: UILabel!
    
    @IBOutlet var walletNameLabel: UILabel!
    
    @IBOutlet var transactionDateLabel: UILabel!
    
    let dateFormatter = DateFormatter()

    override func awakeFromNib() {
        super.awakeFromNib()
        if let transactionTypeView = transactionTypeIndicatorView {
            transactionTypeView.setLeftSideCornerRadius(cornerRadius: 7.0)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureTransactionCell(transaction: Transaction) {
        var incomingTransaction = false
        
        if let address = UserDefaults.standard.value(forKey: UserDefaultConstants.transactionAddress) as? String {
            if transaction.to.lowercased() == address.lowercased() {
                transactionTypeLabel.text = "Received"
                transactionTypeIndicatorView.backgroundColor = UIColor(red: 43.0/255.0, green: 206.0/255.0, blue: 167.0/255.0, alpha: 1.0)
                incomingTransaction = true
            }
            else if transaction.from.lowercased() == address.lowercased() {
                transactionTypeLabel.text = "Sent"
                transactionTypeIndicatorView.backgroundColor = UIColor(red: 244.0/255.0, green: 33.0/255.0, blue: 85.0/255.0, alpha: 1.0)
                incomingTransaction = false
            }
        }
        
        if let transaction = Double(transaction.value) {
            let transactionValue = transaction / 10E+17
            let symbol = incomingTransaction ? "+" : "-"
            currencyLabel.text = "\(symbol)\(String(format: "%.2f", transactionValue)) ETH"
        }
        
        if let name = UserDefaults.standard.value(forKey: UserDefaultConstants.transactionWalletName) as? String {
            walletNameLabel.text = "on \(name)"
        }
        
        guard let date = transaction.date else { return }
        dateFormatter.dateFormat = "MMM d"
        let stringDate = dateFormatter.string(from: date)
        transactionDateLabel.text = "on \(stringDate)"
    }
}

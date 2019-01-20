//
//  Transaction.swift
//  LibertyPoolTest
//
//  Created by Nidhi  on 18/01/19.
//  Copyright © 2019 LibertyPool. All rights reserved.
//

import Foundation

struct TransactionResult: Codable {
    let status: String
    let message: String
    let result: [Transaction]
}

struct Transaction: Codable {
    let timeStamp: String
    var date: Date? {
        guard let epoch = Double(timeStamp) else { return nil }
        return Date(timeIntervalSince1970: epoch)
    }
    let from: String
    let to: String
    let value: String
}

struct Transactions {
    let sortedTransactions: [Transaction]
}

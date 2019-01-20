//
//  MyTransactionViewModel.swift
//  LibertyPoolTest
//
//  Created by Nidhi  on 18/01/19.
//  Copyright © 2019 LibertyPool. All rights reserved.
//

import Foundation

class MyTransactionViewModel {
    
    weak var transactionDataSource: GenericDataSource<Transactions>?
    
    init(dataSource: GenericDataSource<Transactions>) {
        transactionDataSource = dataSource
    }
    
    //MARK: - Fetch
    func fetch() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        
        let address = UserDefaults.standard.value(forKey: UserDefaultConstants.transactionAddress) as? String ?? ""
        
        let etherscanRouter = LibertyHttpRouter<TransactionResult>()
        var param = [String : Any]()
        param["module"] = "account"
        param["action"] = "txlist"
        param["address"] = address
        param["startblock"] = "0"
        param["endblock"] = "99999999"
        param["sort"] = "asc"
        param["page"] = "1"
        param["offset"] = "30"
        param["apikey"] = APIConstant.apiKey
        
        let etherscanAPI = LibertyAPlManager.getTransactionList(data: param)
        etherscanRouter.requestData(router: etherscanAPI) { [weak self] (output, error) in
            
            guard error == nil else {
                self?.transactionDataSource?.data.value = [Transactions]()
                self?.transactionDataSource?.data.error = error?.localizedDescription ?? "Something went wrong. Please try again later."
                return
            }
            guard let apiResult = output, apiResult.result.count > 0 else {
                self?.transactionDataSource?.data.value = [Transactions]()
                self?.transactionDataSource?.data.error = output?.message
                return
            }
            
            // Sort the transactions by date
            let mainAPIResult = apiResult.result.sorted {
                guard let date1 = $0.date else { return false }
                guard let date2 = $1.date else { return false }
                return date1 > date2
            }
            
            var monthAndYears: [String] = []
            for transaction in mainAPIResult {
                guard let date = transaction.date else { return }
                let stringDate = dateFormatter.string(from: date)
                
                if !monthAndYears.contains(stringDate) {
                    monthAndYears.append(stringDate)
                }
            }
            
            // Group the transactions by month
            var sorted: [Transactions] = []
            for monthAndYear in monthAndYears  {
                let transactions = mainAPIResult.filter {
                    guard let date = $0.date else { return false }
                    let stringDate = dateFormatter.string(from: date)
                    return monthAndYear == stringDate
                }
                
                let sortedTransaction = Transactions(sortedTransactions: transactions)
                sorted.append(sortedTransaction)
            }
            
            self?.transactionDataSource?.data.value = sorted
        }
    }
}

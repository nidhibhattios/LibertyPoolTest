//
//  MyTransactionViewController.swift
//  LibertyPoolTest
//
//  Created by Nidhi  on 18/01/19.
//  Copyright © 2019 LibertyPool. All rights reserved.
//

import UIKit
import Charts
import RappleProgressHUD

class MyTransactionViewController: UIViewController {

    @IBOutlet weak var transactionChartView: LineChartView!
    
    @IBOutlet weak var transactionsTableView: UITableView!
    
    @IBOutlet weak var noTransactionLabel: UILabel!
    
    var tableHeaderHeight: CGFloat = 40
    let dataSource = MyTransactionDataSource()
    private lazy var viewModel: MyTransactionViewModel = {
        let viewModel = MyTransactionViewModel(dataSource: dataSource)
        return viewModel
    }()
    var dateFormatter: DateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        viewModel.fetch()
        
        let settingUpdateNotification = UserDefaultConstants.settingUpdateNotification
        NotificationCenter.default.setObserver(self, selector: #selector(settingUpdate), name: settingUpdateNotification, object: nil)
    }
    
    @IBAction func refreshClicked(_ sender: UIBarButtonItem) {
        self.isShowIndicator(isShowProgress: true)
        viewModel.fetch()
    }
}

extension MyTransactionViewController {
    func setUpView() {
        self.title = "My Transactions"
        transactionsTableView.dataSource = self.dataSource
        transactionsTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.transactionChartView.isHidden = true
        
        dataSource.data.addAndNotify(observer: self) { [weak self] in
            DispatchQueue.main.async {
                guard let dataVanue = self?.dataSource.data.value,
                    dataVanue.count > 0 else {
                        if let error = self?.dataSource.data.error {
                            self?.noTransactionLabel.text = error 
                            self?.noTransactionLabel.isHidden = false
                            self?.isShowIndicator(isShowProgress: false)
                            self?.transactionsTableView.reloadData()
                            self?.transactionChartView.isHidden = true
                        }
                        return
                }
                self?.isShowIndicator(isShowProgress: false)
                self?.transactionsTableView.reloadData()
                self?.transactionChartView.isHidden = false
                self?.noTransactionLabel.isHidden = true
                self?.setChart()
            }
        }
        self.isShowIndicator(isShowProgress: true)
    }
    
    func setChart() {
        self.transactionChartView.chartDescription?.enabled = false
        self.transactionChartView.dragEnabled = false
        self.transactionChartView.pinchZoomEnabled = false
        
        self.transactionChartView.rightAxis.enabled = false
        self.transactionChartView.rightAxis.gridColor = .clear
        
        self.transactionChartView.xAxis.labelPosition = .bottom
        self.transactionChartView.xAxis.enabled = true
        self.transactionChartView.xAxis.granularityEnabled = true
        self.transactionChartView.xAxis.granularity = 1.0
        self.transactionChartView.xAxis.gridColor = .clear
        
        self.transactionChartView.leftAxis.enabled = true
        self.transactionChartView.leftAxis.gridColor = .clear
        
        self.transactionChartView.clear()
        self.transactionChartView.clearValues()
        
        let address = UserDefaults.standard.value(forKey: UserDefaultConstants.transactionAddress) as? String ?? ""
        
        var dataPoints: [String] = []
        var values: [Double] = []
        
        let monthDateFormatter = DateFormatter()
        monthDateFormatter.dateFormat = "MMM"
        
        var transactions: [Transaction] = []
        for transaction in dataSource.data.value {
            transactions = transactions + transaction.sortedTransactions
        }
        
        transactions = transactions.filter {
            return $0.to.lowercased() == address.lowercased()
        }
        
        for transaction in transactions {
            guard let date = transaction.date else { return }
            let month = monthDateFormatter.string(from: date)
            let monthlyBalance = transaction.value
            dataPoints.append(month)
            guard let value = Double(monthlyBalance) else { return }
            values.append(value / 10E+17)
        }
        
        let xaxis = XAxis()
        let chartFormatter = LineChartFormatter(months: dataPoints)
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i], data: "a" as AnyObject?)
            dataEntries.append(dataEntry)
            _ = chartFormatter.stringForValue(Double(i), axis: xaxis)
        }
        
        xaxis.valueFormatter = chartFormatter
        transactionChartView.xAxis.valueFormatter = xaxis.valueFormatter
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "ETH Balance")
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.colors = [NSUIColor(red: 38.0/255.0, green: 92.0/255.0, blue: 149.0/255.0, alpha: 1.0)]
        
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartData.setDrawValues(false)
        
        transactionChartView.data = lineChartData
    }
    
    @objc func settingUpdate() {
        self.isShowIndicator(isShowProgress: false)
        viewModel.fetch()
    }
    
    func isShowIndicator(isShowProgress: Bool) {
        if isShowProgress {
            let attributes = RappleActivityIndicatorView.attribute(style: RappleStyle.circle)
            RappleActivityIndicatorView.startAnimatingWithLabel("", attributes: attributes)
        }
        else {
            RappleActivityIndicatorView.stopAnimation()
        }
    }
}

extension MyTransactionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.tableHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let transaction = dataSource.data.value[section].sortedTransactions[0]
        guard let date = transaction.date else { return nil }
        dateFormatter.dateFormat = "MMMM YYYY"
        let stringDate = dateFormatter.string(from: date)
        
        let headerViewFrame = CGRect(x: 12, y: 0, width: UIScreen.main.bounds.width, height: tableHeaderHeight)
        let headerView = UIView(frame: headerViewFrame)
        headerView.backgroundColor = UIColor.white
        let headerLabel = UILabel(frame: headerViewFrame)
        headerLabel.text = stringDate
        headerLabel.textAlignment = .left
        headerView.addSubview(headerLabel)
        return headerView
    }
}



//
//  LineChartFormatter.swift
//  LibertyPoolTest
//
//  Created by Nidhi  on 18/01/19.
//  Copyright © 2019 LibertyPool. All rights reserved.
//

import UIKit
import Charts

class LineChartFormatter: NSObject, IAxisValueFormatter {
    
    private var monthsArray: [String] = []

    init(months: [String]) {
        self.monthsArray = months
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return monthsArray[Int(value)]
    }
}


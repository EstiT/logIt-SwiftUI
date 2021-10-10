//
//  ChartXAxisFormatter.swift
//  logIt (iOS)
//
//  Created by Esti Tweg on 1/10/21.
//

import Foundation
import Charts


class ChartXAxisFormatter: NSObject, AxisValueFormatter {
    private let dateFormatter = DateFormatter()
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM YYYY"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}

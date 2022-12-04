//
//  Utils.swift
//  logIt
//
//  Created by Esti Tweg on 28/11/2022.
//

import Foundation
import SwiftUI

enum TimeRange {
    case last30Days
    case last12Months
}

struct TimeRangePicker: View {
    @Binding var value: TimeRange

    var body: some View {
        Picker("Time Range", selection: $value.animation(.easeInOut)) {
            Text("30 Days").tag(TimeRange.last30Days)
            Text("12 Months").tag(TimeRange.last12Months)
        }
        .pickerStyle(.segmented)
    }
}

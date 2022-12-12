//
//  StatsView.swift
//  logIt
//
//  Created by Esti Tweg on 12/12/2022.
//

import Foundation
import SwiftUI

func calcSessionsInDateRange(sessions: [Session], range: TimeRange) -> Int {
    switch range {
    case .last30Days:
        return 5
    case .last6Months:
        return 6
    case .last12Months:
        return 7
    }
}


struct StatsView: View {
    var sessions: [Session]
    @State private var timeRange: TimeRange = .last30Days

    var body: some View {
        List {
            VStack(alignment: .leading) {
                TimeRangePicker(value: $timeRange)
                    .padding(.bottom)
                Spacer()
                Text("Number of sessions \(calcSessionsInDateRange(sessions: sessions, range: timeRange))")
                Spacer()
                Text("Average number of sessions per week \(calcSessionsInDateRange(sessions: sessions, range: timeRange))")
                Spacer()
                Text("Average strength rating \(calcSessionsInDateRange(sessions: sessions, range: timeRange))")
                Spacer()
                Text("Average session rating \(calcSessionsInDateRange(sessions: sessions, range: timeRange))")
                Spacer()
                Text("Percentage of time injured")
            }
            .onChange(of: timeRange, perform: { value in

            })
        }
        .navigationTitle("Session Stats")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//
//  StatsView.swift
//  logIt
//
//  Created by Esti Tweg on 12/12/2022.
//

import Foundation
import SwiftUI

func sessionsInDateRange(sessions: [Session], range: TimeRange) -> [Session] {
    var past: Date
    switch range {
    case .last30Days:
        past = Calendar.current.date(byAdding: .day, value: -30, to: Date.now)!
    case .last6Months:
        past = Calendar.current.date(byAdding: .month, value: -6, to: Date.now)!
    case .last12Months:
        past = Calendar.current.date(byAdding: .year, value: -1, to: Date.now)!
    }
    return sessions.filter { sesh in return sesh.date! >= past }
}

func calcSessionsInDateRange(sessions: [Session], range: TimeRange) -> Int {
    return sessionsInDateRange(sessions: sessions, range: range).count
}

func calcSessionsPerWeek(sessions: [Session], range: TimeRange) -> String {
    let numSessions = sessionsInDateRange(sessions: sessions, range: range).count
    switch range {
    case .last30Days:
        return String(format:"%.2f", Double(numSessions)/Double(4))
    case .last6Months:
        return String(format:"%.2f", Double(numSessions)/Double(24))
    case .last12Months:
        return String(format:"%.2f", Double(numSessions)/Double(52))
    }
}

func calcSessionRating(sessions: [Session], range: TimeRange) -> String {
    let filteredSessions = sessionsInDateRange(sessions: sessions, range: range)
    let sessionSum = Double(filteredSessions.compactMap { $0.sessionRating }.reduce(0, +))
    return String(format:"%.2f", sessionSum / Double(filteredSessions.count))
}

func calcStrengthRating(sessions: [Session], range: TimeRange) -> String {
    let filteredSessions = sessionsInDateRange(sessions: sessions, range: range)
    let strengthSum = Double(filteredSessions.compactMap { $0.strengthRating }.reduce(0, +))
    return String(format:"%.2f", strengthSum / Double(filteredSessions.count))
}

func calcInjuryPercentage(sessions: [Session], range: TimeRange) -> String {
    let filteredSessions = sessionsInDateRange(sessions: sessions, range: range)
    let injuryCount = Double(filteredSessions.filter { $0.injured }.count)
    return String(format:"%.2f", (injuryCount / Double(filteredSessions.count) * 100))
}


struct StatsView: View {
    var sessions: [Session]
    @State private var timeRange: TimeRange = .last30Days

    var body: some View {
        List {
            Text("Total number of sessions logged: \(sessions.count)").padding(.bottom)
            VStack(alignment: .leading) {
                TimeRangePicker(value: $timeRange)
                    .padding(.bottom)
                
                Text("Number of sessions logged: \(calcSessionsInDateRange(sessions: sessions, range: timeRange))").padding(.bottom)
                Text("Average number of sessions per week: \(calcSessionsPerWeek(sessions: sessions, range: timeRange))").padding(.bottom)
                Text("Average strength rating: \(calcStrengthRating(sessions: sessions, range: timeRange))/5").padding(.bottom)
                Text("Average session rating: \(calcSessionRating(sessions: sessions, range: timeRange))/5").padding(.bottom)
                Text("Percentage of time injured: \(calcInjuryPercentage(sessions: sessions, range: timeRange))%").padding(.bottom)
            }
            .onChange(of: timeRange, perform: { value in
            })
        }
        .navigationTitle("Session Statistics")
        .navigationBarTitleDisplayMode(.inline)
    }
}

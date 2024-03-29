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

func calcSessionsPerWeek(sessions: [Session], range: TimeRange) -> String {
    let numSessions = sessions.count
    switch range {
    case .last30Days:
        return String(format:"%.2f", Double(numSessions)/Double(4))
    case .last6Months:
        return String(format:"%.2f", Double(numSessions)/Double(24))
    case .last12Months:
        return String(format:"%.2f", Double(numSessions)/Double(52))
    }
}

func calcSessionRating(sessions: [Session]) -> String {
    let sessionSum = Double(sessions.compactMap { $0.sessionRating }.reduce(0, +))
    return String(format:"%.2f", sessionSum / Double(sessions.count))
}

func calcStrengthRating(sessions: [Session]) -> String {
    let strengthSum = Double(sessions.compactMap { $0.strengthRating }.reduce(0, +))
    return String(format:"%.2f", strengthSum / Double(sessions.count))
}

func calcInjuryPercentage(sessions: [Session], range: TimeRange) -> Double {
    let injuryCount = Double(sessions.filter { $0.injured }.count)
    return injuryCount / Double(sessions.count) * 100
}


struct StatsView: View {
    var climbingSessions: [Session]
    var gymSessions: [Session]
    @State private var timeRange: TimeRange = .last30Days
    @State private var slices: [(Double, Color)] = []
    @State private var injuryPercent: Double = 0.0
    
    var body: some View {
        List {
            
            Text("Total number of sessions logged: \(climbingSessions.count + gymSessions.count) since \(climbingSessions[0].date?.formatted(Date.FormatStyle().year().month().day()) ?? "")").padding(.bottom)
            VStack(alignment: .leading) {
                TimeRangePicker(value: $timeRange)
                    .padding(.bottom)
                let filteredClimbingSessions = sessionsInDateRange(sessions: climbingSessions, range: timeRange)
                
                let filteredGymSessions = sessionsInDateRange(sessions: gymSessions, range: timeRange)
                
                Text("Number of sessions logged: \(filteredClimbingSessions.count + filteredGymSessions.count)").padding(.bottom)
                
                Text("Number of climbing sessions logged: \(filteredClimbingSessions.count)").padding(.bottom)
                Text("Average number of climbing sessions per week: \(calcSessionsPerWeek(sessions: filteredClimbingSessions, range: timeRange))").padding(.bottom)
                Text("Average number of sessions per week: \(calcSessionsPerWeek(sessions: filteredClimbingSessions + filteredGymSessions, range: timeRange))").padding(.bottom)
                Text("Average climbing strength rating: \(calcStrengthRating(sessions: filteredClimbingSessions))/5").padding(.bottom)
                Text("Average climbing session rating: \(calcSessionRating(sessions: filteredClimbingSessions))/5").padding(.bottom)
            }
            HStack {
                Text("Percentage of sessions injured: \(String(format:"%.1f", injuryPercent))%").padding(.bottom)
                PieView(slices: $slices, id: timeRange.description).scaleEffect(0.5, anchor: .center)
            }
            .onChange(of: timeRange, perform: { value in
                let filteredClimbingSessions = sessionsInDateRange(sessions: climbingSessions, range: timeRange)
                
                let filteredGymSessions = sessionsInDateRange(sessions: gymSessions, range: timeRange)

                injuryPercent = calcInjuryPercentage(sessions: filteredClimbingSessions + filteredGymSessions, range: timeRange)
                slices = [(injuryPercent, .red), (100 - injuryPercent, .blue)]
            })
            .onAppear() {
                let filteredClimbingSessions = sessionsInDateRange(sessions: climbingSessions, range: timeRange)
                
                let filteredGymSessions = sessionsInDateRange(sessions: gymSessions, range: timeRange)
                
                injuryPercent = calcInjuryPercentage(sessions: filteredClimbingSessions + filteredGymSessions, range: timeRange)
                slices = [(injuryPercent, .red), (100 - injuryPercent, .blue)]
            }
        }
        .navigationTitle("Session Statistics")
        .navigationBarTitleDisplayMode(.inline)
    }
}

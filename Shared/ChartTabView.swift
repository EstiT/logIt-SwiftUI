//
//  ChartTabView.swift
//  logIt
//
//  Created by Esti Tweg on 25/9/21.
//

import CoreData
import SwiftUI
import Charts


enum SwipeHVDirection: String {
    case left, right, up, down, none
}

func detectDirection(value: DragGesture.Value) -> SwipeHVDirection {
    if value.startLocation.x < value.location.x - 24 {
        return .left
    }
    if value.startLocation.x > value.location.x + 24 {
        return .right
    }
    if value.startLocation.y < value.location.y - 24 {
        return .down
    }
    if value.startLocation.y > value.location.y + 24 {
        return .up
    }
    return .none
}


var date: Date {
    get {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: "2022-09-14T10:44:00+0000")!
    }
}

struct ChartTabView: View {
    
    @State var domain: ClosedRange<Date> = date...Date()
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Session.date, ascending: true)],
        animation: .default)
    private var sessions: FetchedResults<Session>
    
    
    var body: some View {
        
        NavigationView {
            GeometryReader { geometry in
                
                if sessions.count > 0 {
                    Text(domain)
                    Chart {
                        ForEach(sessions) { session in
                            LineMark(
                                x: .value("Date", session.date!),
                                y: .value("Session Rating", session.sessionRating),
                                series: .value("Session", "Session")
                            )
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(by: .value("Session", "Session"))
                            PointMark(
                                x: .value("Date", session.date!),
                                y: .value("Session Rating", session.sessionRating)
                            )
                            .symbolSize(20)
                            .foregroundStyle(session.injured ? .red : .blue)
                        }
                        
                        ForEach(sessions) { session in
                            LineMark(
                                x: .value("Date", session.date!),
                                y: .value("Strength Rating", session.strengthRating),
                                series: .value("Strength", "Strength")
                            )
                            .foregroundStyle(by: .value("Strength", "Strength"))
                            .interpolationMethod(.catmullRom)
                            
                            
                            PointMark(
                                x: .value("Date", session.date!),
                                y: .value("Strength Rating", session.strengthRating)
                            )
                            .symbolSize(20)
                            .foregroundStyle(session.injured ? .red : .green)
                        }
                    }
                    .chartOverlay { proxy in
                        GeometryReader { geometry in
                            Rectangle().fill(.clear).contentShape(Rectangle())
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            var delta = 0
                                            
                                            let direction = detectDirection(value: value)
                                            if direction == .left {
                                                delta = -2
                                            } else if direction == .right {
                                                delta = 2
                                            }
                                            
                                            var dayComponent = DateComponents()
                                            dayComponent.day = delta
                                            
                                            let newStart = Calendar.current.date(byAdding: dayComponent, to: domain.lowerBound)
                                            let newEnd = Calendar.current.date(byAdding: dayComponent, to: domain.upperBound)
                                            domain = newStart!...newEnd!
                                        }
                                )
                        }
                    }
                    .chartXScale(domain: domain)
                }
                else {
                    HStack{
                        Spacer()
                        Text("No data")
                        Spacer()
                    } .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }
            } .navigationBarTitle("Trends")
        }
    }
}

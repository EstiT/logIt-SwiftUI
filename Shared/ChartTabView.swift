//
//  ChartTabView.swift
//  logIt
//
//  Created by Esti Tweg on 25/9/21.
//

import CoreData
import SwiftUI
import Charts


var date: Date {
    get {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: "2022-09-14T10:44:00+0000")!
    }
}

struct ChartTabView: View {
    
    @State var domain: ClosedRange<Date> = date...Date.now
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
                            .symbolSize(25)
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
                            .symbolSize(25)
                            .foregroundStyle(session.injured ? .red : .green)
                        }
                    }
                    .chartOverlay { proxy in
                        GeometryReader { geometry in
                            Rectangle().fill(.clear).contentShape(Rectangle())
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            let xStart = (value.startLocation.x - geometry[proxy.plotAreaFrame].origin.x) / 5
                                            let xCurrent = (value.location.x - geometry[proxy.plotAreaFrame].origin.x) / 5
                                            if let dateStart: Date = proxy.value(atX: xStart),
                                               let dateCurrent: Date = proxy.value(atX: xCurrent) {
                                                let delta = Calendar.current.dateComponents([.year, .month, .day], from: dateCurrent , to: dateStart)
                                                
                                                if let day = delta.day {
                                                    let newStart = Calendar.current.date(byAdding: delta, to: domain.lowerBound)!
                                                    let newEnd = Calendar.current.date(byAdding: delta, to: domain.upperBound)!
                                                    
                                                    if day != 0 && newStart >= sessions[0].date! && newEnd <= sessions[sessions.count-1].date! {
                                                        domain = newStart...newEnd
                                                    }
                                                }
                                            }
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
                .onAppear() {
                    if sessions.count > 0{
                        self.domain = date...sessions[sessions.count-1].date!
                    }
                }
        }
    }
}

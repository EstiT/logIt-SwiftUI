//
//  ChartTabView.swift
//  logIt
//
//  Created by Esti Tweg on 25/9/21.
//

import CoreData
import SwiftUI
import Charts


var thirtyDaysAgo: Date {
    get {
        return Calendar.current.date(byAdding: .day, value: -30, to: Date.now)!
    }
}

struct SessionChart: View {
    @Binding var selectedElement: (date: Date, notes: String)?
    var sessions: FetchedResults<Session>
    @Binding var domain: ClosedRange<Date>
    
    
    func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> (date: Date?, notes: String?)? {
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            for sessionIndex in sessions.indices {
                let nthSalesDataDistance = sessions[sessionIndex].date!.distance(to: date)
                if abs(nthSalesDataDistance) < minDistance {
                    minDistance = abs(nthSalesDataDistance)
                    index = sessionIndex
                }
            }
            if let index = index {
                let notes = sessions[index].notes == "Notes" ? "" : sessions[index].notes
                let el = (date: sessions[index].date, notes: notes)
                return el
            }
        }
        return nil
    }
    
    func makeLine(session: Session, series: String) -> LineMark {
        return LineMark(
            x: .value("Date", session.date!),
            y: .value(series + " Rating", series == "Strength" ? session.strengthRating : session.sessionRating),
            series: .value(series, series)
        )
    }
    
    func makePoint(session: Session, series: String) -> PointMark {
        return PointMark(
            x: .value("Date", session.date!),
            y: .value(series + " Rating", series == "Strength" ? session.strengthRating : session.sessionRating)
        )
    }
    
    var body: some View {
        Chart {
            ForEach(sessions) { session in
                makeLine(session: session, series: "Session")
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(by: .value("Session", "Session"))
                makePoint(session: session, series: "Session")
                    .symbolSize(25)
                    .foregroundStyle(session.injured ? .red : .blue)
            }
            
            ForEach(sessions) { session in
                makeLine(session: session, series: "Strength")
                    .foregroundStyle(by: .value("Strength", "Strength"))
                    .interpolationMethod(.catmullRom)
                makePoint(session: session, series: "Strength")
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
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { value in
                                let element = findElement(location: value.location, proxy: proxy, geometry: geometry)
                                if selectedElement?.date == element?.date {
                                    // If tapping the same element, clear the selection.
                                    selectedElement = nil
                                } else {
                                    selectedElement = element as? (date: Date, notes: String)
                                }
                            }
                            .exclusively(
                                before: DragGesture()
                                    .onChanged { value in
                                        selectedElement = findElement(location: value.location, proxy: proxy, geometry: geometry) as? (date: Date, notes: String)
                                    }
                            )
                    )
            }
        }
        .chartXScale(domain: domain)
    }
}

struct ChartTabView: View {
    @State private var selectedElement: (date: Date, notes: String)? = nil
    @State private var timeRange: TimeRange = .last30Days
    @State var domain: ClosedRange<Date> = thirtyDaysAgo...Date.now
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Session.date, ascending: true)],
        predicate: NSPredicate(format: "type != %@", SeshType.gymWeights.description),
        animation: .default)
    private var climbingSessions: FetchedResults<Session>
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Session.date, ascending: true)],
        predicate: NSPredicate(format: "type == %@", SeshType.gymWeights.description),
        animation: .default)
    private var gymSessions: FetchedResults<Session>
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                if climbingSessions.count > 0 {
                    VStack(alignment: .leading) {
                        TimeRangePicker(value: $timeRange)
                            .padding(.bottom)
                        Text(domain)
                            .opacity(selectedElement == nil ? 1 : 0)
                        SessionChart(selectedElement: $selectedElement, sessions: climbingSessions, domain: $domain)
                            .frame(height: 360)
                            .padding()
                        List {
                            Section() {
                                StatsLink()
                            }
                        }
                        .listStyle(.plain)
                        .navigationDestination(for: [Session].self) { key in
                            StatsView(climbingSessions: Array(climbingSessions), gymSessions: Array(gymSessions))
                        }
                    }
                    
                    .onChange(of: timeRange, perform: { value in
                        switch timeRange {
                        case .last30Days:
                            let past = Calendar.current.date(byAdding: .day, value: -30, to: Date.now)!
                            domain = past...Date.now
                        case .last6Months:
                            let past = Calendar.current.date(byAdding: .month, value: -6, to: Date.now)!
                            domain = past...Date.now
                        case .last12Months:
                            let past = Calendar.current.date(byAdding: .year, value: -1, to: Date.now)!
                            domain = past...Date.now
                        }
                    })
                    
                    .chartBackground { proxy in
                        ZStack(alignment: .topLeading) {
                            GeometryReader { nthGeoItem in
                                if let selectedElement = selectedElement {
                                    let dateInterval = Calendar.current.dateInterval(of: .day, for: selectedElement.date)!
                                    let startPositionX1 = proxy.position(forX: dateInterval.start) ?? 0
                                    let startPositionX2 = proxy.position(forX: dateInterval.end) ?? 0
                                    let midStartPositionX = (startPositionX1 + startPositionX2) / 2 + nthGeoItem[proxy.plotAreaFrame].origin.x
                                    
                                    let lineX = midStartPositionX
                                    let lineHeight = nthGeoItem[proxy.plotAreaFrame].maxY
                                    let boxWidth: CGFloat = 150
                                    let boxOffset = max(0, min(nthGeoItem.size.width - boxWidth, lineX - boxWidth / 2))
                                    
                                    Rectangle()
                                        .fill(.quaternary)
                                        .frame(width: 2, height: lineHeight - 60)
                                        .position(x: lineX, y: lineHeight / 2 + 50)
                                    
                                    VStack(alignment: .leading) {
                                        Text("\(selectedElement.date, format: .dateTime.year().month().day())")
                                            .font(.callout)
                                            .foregroundStyle(.secondary)
                                        Text("\(selectedElement.notes)")
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                    }
                                    .frame(width: boxWidth, alignment: .leading)
                                    .background {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(.background)
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(.quaternary.opacity(0.7))
                                        }
                                        .padding([.leading, .trailing], -8)
                                        .padding([.top, .bottom], -4)
                                    }
                                    
                                    .offset(x: boxOffset, y: 45)
                                }
                            }
                        }
                    }
                }
                else {
                    HStack{
                        Spacer()
                        Text("No data")
                        Spacer()
                    } .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }
            }
            .navigationBarTitle("Trends")
            .onAppear() {
                if climbingSessions.count > 0 {
                    self.domain = thirtyDaysAgo...Date.now
                    self.timeRange = .last30Days
                }
            }
        }
    }
}

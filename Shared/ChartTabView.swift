//
//  ChartTabView.swift
//  logIt
//
//  Created by Esti Tweg on 25/9/21.
//

import CoreData
import SwiftUI
import Charts

struct ChartTabView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Session.date, ascending: true)],
        animation: .default)
    private var sessions: FetchedResults<Session>
    
    static func dataEntries(strength: Bool) -> [ChartDataEntry] {
        let storageProvider = PersistenceController()
        let sessions = storageProvider.getAllSessions()
        let now = Date().timeIntervalSince1970
        let hourSeconds: TimeInterval = 3600
        
        let count = 30 // todo change
        let range = UInt32(30) // todo change
        
        let from = now - (Double(count) / 2) * hourSeconds
        let to = now + (Double(count) / 2) * hourSeconds
        
        let values = stride(from: from, to: to, by: hourSeconds).map { (x) -> ChartDataEntry in
            let y = arc4random_uniform(range) + 50
            return ChartDataEntry(x: x, y: Double(y))
        }
        
        return values
    }
    
    @State private var dates = ["1D", "1W", "1M", "6M", "1Y"]
    @State private var selectedDate = "1Y"
    
    var body: some View {

        NavigationView {
            GeometryReader { geometry in
                
                if sessions.count > 0 {
                    VStack{
                        Picker("Please choose a date", selection: $selectedDate) {
                            ForEach(dates, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        ChartView(entries: ChartTabView.dataEntries(strength: true), entries2: ChartTabView.dataEntries(strength: false), selectedZoom: .constant(2021))
                    }
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

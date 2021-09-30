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
    
    static func dataEntriesForYear(_ year: Int, sessions: [Session], strength: Bool) -> [ChartDataEntry] {
        let yearSessions = sessions.filter {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            let seshYear = formatter.string(from: $0.date!)
            return seshYear == String(year)
        }
       
        return yearSessions.enumerated().map{ChartDataEntry(x: Double($0),
                                                            y: Double(strength ? $1.strengthRating : $1.sessionRating), data: $1)}
    }
    @State private var dates = ["1D", "1W", "1M", "6M", "1Y"]
    @State private var selectedDate = "1Y"
    
    
    
    var body: some View {
        let strengthArr = sessions.map{Double($0.strengthRating)/5*100}
        let sessionArr = sessions.map{Double($0.sessionRating)/5*100}
        NavigationView {
            GeometryReader { geometry in
                
                if sessions.count > 0 {
                    let storageProvider = PersistenceController()
                    let sessionsArr = storageProvider.getAllSessions()
                    VStack{
                        Picker("Please choose a date", selection: $selectedDate) {
                            ForEach(dates, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        //                    ChartView_previews.previews
                        ChartView(entries: ChartTabView.dataEntriesForYear(2021, sessions: sessionsArr, strength: true), entries2: ChartTabView.dataEntriesForYear(2021, sessions: sessionsArr, strength: false), selectedYear: .constant(2021))
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

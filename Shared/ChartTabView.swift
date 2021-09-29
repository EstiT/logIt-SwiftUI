//
//  ChartTabView.swift
//  logIt
//
//  Created by Esti Tweg on 25/9/21.
//

import CoreData
import SwiftUI
import SwiftUICharts
import StockCharts

struct ChartTabView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Session.date, ascending: true)],
        animation: .default)
    private var sessions: FetchedResults<Session>
    @State private var dates = ["1D", "1W", "1M", "6M", "1Y"]
    @State private var selectedDate = "1Y"
    
    var body: some View {
        
        let datesArr = sessions.map{dateToString(date: $0.date!)}
        let strengthArr = sessions.map{Double($0.strengthRating)/5*100}
//        let sessionArr = sessions.map{Double($0.sessionRating)/5*100}
        
        NavigationView {
            GeometryReader { geometry in
                
                if sessions.count > 0 {
                    Picker("Please choose a date", selection: $selectedDate) {
                                            ForEach(dates, id: \.self) {
                                                Text($0)
                                            }
                                        }
                                        .pickerStyle(SegmentedPickerStyle())
                let lineChartController = LineChartController(
                        prices: strengthArr,
                        dates: datesArr,
                        labelColor: .blue,
                        indicatorPointColor: .blue,
                        showingIndicatorLineColor: .blue,
                        flatTrendLineColor: .green,
                        uptrendLineColor: .blue,
                        downtrendLineColor: .red,
                        dragGesture: true
                    )
                    LineChartView(lineChartController: lineChartController)
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
    
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func strengthValues() -> [Double] {
        
    }
}

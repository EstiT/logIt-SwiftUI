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
    
    
    var body: some View {
//        let strengthArr = sessions.map{Double($0.strengthRating)/5*100}
//        let sessionArr = sessions.map{Double($0.sessionRating)/5*100}
        NavigationView {
            GeometryReader { geometry in
                
                if sessions.count > 0 {
                    Chart {
                        ForEach(sessions) { session in
                            LineMark(
                                x: .value("Date", session.date!),
                                y: .value("Session Rating", session.sessionRating),
                                series: .value("Session", "Session")
                            )
                            .interpolationMethod(.monotone)
                            .foregroundStyle(.blue)
                            
                            PointMark(
                                x: .value("Date", session.date!),
                                y: .value("Session Rating", session.sessionRating)
                            )
                            .foregroundStyle(by: .value("injured", session.injured ? "Injured" : "Not Injured"))
                        }
                        
                        ForEach(sessions) { session in
                            LineMark(
                                x: .value("Date", session.date!),
                                y: .value("Strength Rating", session.strengthRating),
                                series: .value("Strength", "Strength")
                            )
                            .foregroundStyle(.purple)
                            .interpolationMethod(.monotone)
                            

                            PointMark(
                                x: .value("Date", session.date!),
                                y: .value("Strength Rating", session.strengthRating)
                            )
                            .foregroundStyle(by: .value("injured", session.injured ? "Injured" : "Not Injured"))
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
            } .navigationBarTitle("Trends")
        }
    }
}

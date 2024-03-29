//
//  ContentView.swift
//  Shared
//
//  Created by Esti Tweg on 25/9/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TabView {
            LogTabView()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Log")
                }
            ListTabView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("List")
                }
            CalendarTabView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            ChartTabView()
                .tabItem {
                    Image(systemName: "waveform.path.ecg") //chart.xyaxis.line  / chart.line.uptrend.xyaxis
                    Text("Trends")
                }
        }
        
    }
}


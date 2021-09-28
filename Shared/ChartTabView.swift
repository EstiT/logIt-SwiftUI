//
//  ChartTabView.swift
//  logIt
//
//  Created by Esti Tweg on 25/9/21.
//

import CoreData
import SwiftUI
import SwiftUICharts

struct ChartTabView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Session.date, ascending: true)],
        animation: .default)
    private var sessions: FetchedResults<Session>
   
    
    var body: some View {
        let strengthArr = sessions.map{Double($0.strengthRating)/5*100}
        let sessionArr = sessions.map{Double($0.sessionRating)/5*100}
        NavigationView {
        GeometryReader { geometry in
            MultiLineChartView(data: [
                                (strengthArr, GradientColors.green),
                                (sessionArr, GradientColors.bluPurpl)],
                                    title: "",form: ChartForm.extraLarge,
                                    rateValue: nil)
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                .navigationBarTitle("Trends")
        }
        }
    }
}

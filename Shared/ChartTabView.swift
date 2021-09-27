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
        GeometryReader { geometry in
            MultiLineChartView(data: [
                                ([8,32,11,23,40,28], GradientColors.green),([34,56,72,38,43,100,50], GradientColors.bluPurpl)], title: "Trends",form: ChartForm.large)
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
    }
}

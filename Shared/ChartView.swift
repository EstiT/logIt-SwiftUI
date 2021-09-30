//
//  ChartView.swift
//  logIt (iOS)
//
//  Created by Esti Tweg on 29/9/21.
//

import Foundation
import SwiftUI
import Charts


struct ChartView: UIViewRepresentable {
    let entries: [ChartDataEntry]
    @Binding var selectedYear: Int
    
    func makeUIView(context: Context) -> LineChartView {
        return LineChartView()
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        let dataSet = LineChartDataSet(entries: entries)
        uiView.rightAxis.enabled = false
        uiView.legend.enabled = false
//        uiView.zoom(scaleX: 1.5, scaleY: 1, x: 0, y: 0)
        formatDataSet(dataSet: dataSet)
        formatYAxis(yAxis: uiView.leftAxis)
        formatXAxis(xAxis: uiView.xAxis)
//        formatLegend(legend: uiView.legend)
        uiView.data = LineChartData(dataSet: dataSet)
    }
    
    func formatDataSet(dataSet: LineChartDataSet){
//        dataSet.colors = [.green]
//        dataSet.drawCubicEnabled = true
        dataSet.lineWidth = 2.0
        dataSet.circleRadius = 4.0
        dataSet.drawValuesEnabled = false
        dataSet.isDrawLineWithGradientEnabled = true
        dataSet.colors = [UIColor(red: 0.192, green: 0.686, blue: 0.980, alpha: 1.00), UIColor(red: 0.212, green: 0.863, blue: 0.318, alpha: 1.00), UIColor(red: 0.996, green: 0.867, blue: 0.275, alpha: 1.00), UIColor(red: 0.980, green: 0.090, blue: 0.157, alpha: 1.00)]
        dataSet.gradientPositions = [35.0, 36.6, 38.0, 40.0]
        dataSet.label = ""
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        dataSet.mode = .horizontalBezier
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
    }
    
    func formatYAxis(yAxis: YAxis){
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        yAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 5
        yAxis.drawGridLinesEnabled = false
        yAxis.granularity = 1.0
    }
    
    func formatXAxis(xAxis: XAxis){
//        xAxis.valueFormatter = IndexAxisValueFormatter(
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
    }
    
    func formatLegend(legend: Legend){
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.drawInside = true
        legend.yOffset = 30
    }
}

struct ChartView_previews: PreviewProvider {
//    let storageProvider: PersistenceController
//    @State private var sessions: [Session] = []
    
    static var previews: some View {
        let storageProvider = PersistenceController()
        let sessions = storageProvider.getAllSessions()
        ChartView(entries: ChartTabView.dataEntriesForYear(2021, sessions: sessions), selectedYear: .constant(2021))
    }
}

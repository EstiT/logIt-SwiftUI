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
    let entries2: [ChartDataEntry]
    @Binding var selectedYear: Int
    
    func makeUIView(context: Context) -> LineChartView {
        return LineChartView()
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        let dataSet = LineChartDataSet(entries: entries)
        let dataSet2 = LineChartDataSet(entries: entries2)
        uiView.rightAxis.enabled = false
        uiView.legend.enabled = false
//        uiView.zoom(scaleX: 1.5, scaleY: 1, x: 0, y: 0)
        let marker = PillMarker(color: .white, font: UIFont.boldSystemFont(ofSize: 14), textColor: .black)
        uiView.marker = marker
        formatDataSet(dataSet: dataSet)
        formatDataSet(dataSet: dataSet2)
        dataSet2.colors = [.cyan]
        dataSet2.label = "Session Rating"
        formatYAxis(yAxis: uiView.leftAxis)
        formatXAxis(xAxis: uiView.xAxis)
        formatLegend(legend: uiView.legend)
        
        uiView.data = LineChartData(dataSets:[dataSet, dataSet2])
    }
    
    func formatDataSet(dataSet: LineChartDataSet){
        dataSet.colors = [.green]
//        dataSet.drawCubicEnabled = true
        dataSet.lineWidth = 3.0
        dataSet.circleRadius = 8.0
        dataSet.drawValuesEnabled = false
        dataSet.drawCircleHoleEnabled = false
        dataSet.label = "Strength Rating"
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
        legend.yOffset = 40
    }
}

struct ChartView_previews: PreviewProvider {
//    let storageProvider: PersistenceController
//    @State private var sessions: [Session] = []
    
    static var previews: some View {
        let storageProvider = PersistenceController()
        let sessions = storageProvider.getAllSessions()
        ChartView(entries: ChartTabView.dataEntriesForYear(2021, sessions: sessions, strength: true),
                  entries2: ChartTabView.dataEntriesForYear(2021, sessions: sessions, strength: false),
                  selectedYear: .constant(2021))
    }
}

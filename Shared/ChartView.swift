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
    @Binding var selectedZoom: Int
    
    func makeUIView(context: Context) -> LineChartView {
        return LineChartView()
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        let dataSet = LineChartDataSet(entries: entries)
        let dataSet2 = LineChartDataSet(entries: entries2)
        uiView.rightAxis.enabled = false
        uiView.legend.enabled = false
        let marker = PillMarker(color: .white, font: UIFont.boldSystemFont(ofSize: 14), textColor: .black, insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
                                xAxisValueFormatter: uiView.xAxis.valueFormatter!)
        marker.minimumSize = CGSize(width: 75.0, height: 35.0)
        uiView.highlightPerTapEnabled = true
        
        uiView.marker = marker
        uiView.drawMarkers = true
        uiView.animate(xAxisDuration: TimeInterval(dataSet.count/4))
        //        uiView.animate(yAxisDuration: 3)
        //        uiView.viewPortHandler.setMaximumScaleY( Float(2.f))
        //        uiView.zoom(scawleX: 1.5, scaleY: 1, x: 0, y: 0)
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
        //        dataSet.cubicIntensity = 0.4
        //        dataSet.drawCubicEnabled = true
        dataSet.lineWidth = 3.0
        dataSet.circleRadius = 4.0
        dataSet.drawValuesEnabled = false
        //        dataSet.drawCirclesEnabled = false
        dataSet.drawCircleHoleEnabled = false
        //        dataSet.isDrawLineWithGradientEnabled = true
        //        dataSet.colors = [UIColor(red: 0.192, green: 0.686, blue: 0.980, alpha: 1.00), UIColor(red: 0.212, green: 0.863, blue: 0.318, alpha: 1.00), UIColor(red: 0.996, green: 0.867, blue: 0.275, alpha: 1.00), UIColor(red: 0.980, green: 0.090, blue: 0.157, alpha: 1.00)]
        //        dataSet.gradientPositions = [35.0, 36.6, 38.0, 40.0]
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
        yAxis.axisMinimum = 1
        yAxis.axisMaximum = 5
        yAxis.drawGridLinesEnabled = false
        yAxis.granularity = 1.0
        //        yAxis.enabled = false
    }
    
    func formatXAxis(xAxis: XAxis){
        //     let xValuesFormatter = DateFormatter()
        //        xValuesFormatter.dateStyle = .short
        //    let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: xValuesFormatter)
        //        xValuesNumberFormatter.dateFormatter = xValuesFormatter // e.g. "wed 26"
        xAxis.valueFormatter = ChartXAxisFormatter()
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
    static var previews: some View {
        ChartView(entries: ChartTabView.dataEntries(strength: true),
                  entries2: ChartTabView.dataEntries(strength: false),
                  selectedZoom: .constant(2021))
    }
}

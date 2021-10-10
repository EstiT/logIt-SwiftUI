//
//  ChartView.swift
//  logIt
//
//  Created by Esti Tweg on 10/10/21.
//

import Foundation
import SwiftUI
import SwiftCharts


struct ChartView: UIViewRepresentable {
    let sessions: [Session]
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
       
        let bgColors = [UIColor.red, UIColor.blue, UIColor(red: 0, green: 0.7, blue: 0, alpha: 1), UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)]
        
        func createChartPoints0(_ color: UIColor) -> [ChartPoint] {
            return [
                createChartPoint(0, 0, color),
                createChartPoint(2, 2, color),
                createChartPoint(5, 2, color),
                createChartPoint(8, 11, color),
                createChartPoint(10, 2, color),
                createChartPoint(12, 3, color),
                createChartPoint(16, 22, color),
                createChartPoint(20, 5, color)
            ]
        }
        
        func createChartPoints1(_ color: UIColor) -> [ChartPoint] {
            return [
                createChartPoint(0, 7, color),
                createChartPoint(1, 10, color),
                createChartPoint(3, 9, color),
                createChartPoint(9, 2, color),
                createChartPoint(10, -5, color),
                createChartPoint(13, -12, color)
            ]
        }
        
        let chartPoints0 = createChartPoints0(bgColors[0])
        let chartPoints1 = createChartPoints1(bgColors[1])
        
        let xValues0 = chartPoints0.map{$0.x}
        let xValues1 = chartPoints1.map{$0.x}
        
        let chartSettings = createChartSettings()
        
        let top: CGFloat = 80
        let viewFrame = CGRect(x: 0, y: top, width: 300, height: 500)
        
        let yValues1 = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(chartPoints0, minSegmentCount: 10, maxSegmentCount: 20, multiple: 2, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: ChartLabelSettings(font: UIFont.systemFont(ofSize: 13), fontColor: bgColors[0]))}, addPaddingSegmentIfEdge: false)
        
        let yValues2 = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(chartPoints1, minSegmentCount: 10, maxSegmentCount: 20, multiple: 2, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: ChartLabelSettings(font: UIFont.systemFont(ofSize: 13), fontColor: bgColors[1]))}, addPaddingSegmentIfEdge: false)
        
       
        let axisTitleFont = UIFont.systemFont(ofSize: 15)
        
        let yLowModels: [ChartAxisModel] = [
            ChartAxisModel(axisValues: yValues2, lineColor: bgColors[1], axisTitleLabels: [ChartAxisLabel(text: "Axis title", settings: ChartLabelSettings(font: axisTitleFont, fontColor: bgColors[1]).defaultVertical())]),
            ChartAxisModel(axisValues: yValues1, lineColor: bgColors[0], axisTitleLabels: [ChartAxisLabel(text: "Axis title", settings: ChartLabelSettings(font: axisTitleFont, fontColor: bgColors[0]).defaultVertical())])
        ]
        
        let xLowModels: [ChartAxisModel] = [
            ChartAxisModel(axisValues: xValues0, lineColor: bgColors[0], axisTitleLabels: [ChartAxisLabel(text: "Axis title", settings: ChartLabelSettings(font: axisTitleFont, fontColor: bgColors[0]))]),
            ChartAxisModel(axisValues: xValues1, lineColor: bgColors[1], axisTitleLabels: [ChartAxisLabel(text: "Axis title", settings: ChartLabelSettings(font: axisTitleFont, fontColor: bgColors[1]))])
        ]
        
        // calculate coords space in the background to keep UI smooth
        DispatchQueue.global(qos: .background).async {
            
            let coordsSpace = ChartCoordsSpace(chartSettings: chartSettings, chartSize: viewFrame.size, yLowModels: yLowModels,  xLowModels: xLowModels)
            
            DispatchQueue.main.async {
                
                let chartInnerFrame = coordsSpace.chartInnerFrame
                
                // create axes
                let yLowAxes = coordsSpace.yLowAxesLayers
                let xLowAxes = coordsSpace.xLowAxesLayers
                
                // create layers with references to axes
                let lineModel0 = ChartLineModel(chartPoints: chartPoints0, lineColor: bgColors[0], animDuration: 1, animDelay: 0)
                let lineModel1 = ChartLineModel(chartPoints: chartPoints1, lineColor: bgColors[1], animDuration: 1, animDelay: 0)
             
                let chartPointsLineLayer0 = ChartPointsLineLayer<ChartPoint>(xAxis: xLowAxes[0].axis, yAxis: yLowAxes[1].axis, lineModels: [lineModel0])
                let chartPointsLineLayer1 = ChartPointsLineLayer<ChartPoint>(xAxis: xLowAxes[1].axis, yAxis: yLowAxes[0].axis, lineModels: [lineModel1])
               
                
                let lineLayers = [chartPointsLineLayer0, chartPointsLineLayer1]
                
                let layers: [ChartLayer] = [
                    yLowAxes[1], xLowAxes[0], lineLayers[0],
                    yLowAxes[0], xLowAxes[1], lineLayers[1]
                ]
                
                let chart = Chart(
                    frame: viewFrame,
                    innerFrame: chartInnerFrame,
                    settings: chartSettings,
                    layers: layers
                )
                
                uiView.addSubview(chart.view)
               
            }
        }

    }
    
    fileprivate func createChartPoint(_ x: Double, _ y: Double, _ labelColor: UIColor) -> ChartPoint {
        let labelSettings = ChartLabelSettings(font: UIFont.systemFont(ofSize: 15), fontColor: labelColor)
        return ChartPoint(x: ChartAxisValueDouble(x, labelSettings: labelSettings), y: ChartAxisValueDouble(y, labelSettings: labelSettings))
    }
    func createChartSettings() -> ChartSettings {
        var chartSettings = ChartSettings()
        chartSettings.leading = 10
        chartSettings.top = 10
        chartSettings.trailing = 10
        chartSettings.bottom = 10
        chartSettings.labelsToAxisSpacingX = 5
        chartSettings.labelsToAxisSpacingY = 5
        chartSettings.axisTitleLabelsToLabelsSpacing = 4
        chartSettings.axisStrokeWidth = 0.2
        chartSettings.spacingBetweenAxesX = 8
        chartSettings.spacingBetweenAxesY = 8
        chartSettings.labelsSpacing = 0
        chartSettings.zoomPan.panEnabled = true
        chartSettings.zoomPan.zoomEnabled = true
        
        return chartSettings
    }
}

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
        let chartSettings = createChartSettings()
        let labelSettings = chartLabelSettings()
        
        let chartPoints1 = makeChartPoints(sessions: sessions, strength: true)
        let chartPoints2 = makeChartPoints(sessions: sessions, strength: false)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "MMMM dd, yyyy" // h a ?
        let xAxisValues = ChartAxisValuesStaticGenerator.generateXAxisValuesWithChartPoints(chartPoints1, minSegmentCount: 5, maxSegmentCount: 10, multiple: TimeInterval(60 * 60), axisValueGenerator: { ChartAxisValueDate(date: ChartAxisValueDate.dateFromScalar($0), formatter: timeFormatter, labelSettings: labelSettings)
            }, addPaddingSegmentIfEdge: false)
        
        let yValues = ChartAxisValuesStaticGenerator.generateYAxisValuesWithChartPoints(chartPoints1, minSegmentCount: 10, maxSegmentCount: 20, multiple: 2, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: false)
        
        
        let xModel = ChartAxisModel(axisValues: xAxisValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings.defaultVertical()))

        let top: CGFloat = 80
        let chartFrame = CGRect(x: 0, y: top, width: 400, height: 500)

        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let lineModel1 = ChartLineModel(chartPoints: chartPoints1, lineColors: [UIColor.blue, UIColor.purple], lineWidth: 2, animDuration: 1, animDelay: 0)
        let lineModel2 = ChartLineModel(chartPoints: chartPoints2, lineColors: [UIColor.red, UIColor.yellow], lineWidth: 2, animDuration: 1, animDelay: 1)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, lineModels: [lineModel1, lineModel2], pathGenerator: CatmullPathGenerator()) // || CubicLinePathGenerator
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth:  0.1)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
        
        let chart = Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                guidelinesLayer,
                chartPointsLineLayer
            ]
        )
                
        uiView.addSubview(chart.view)
    }
}

private let dateFormatter: DateFormatter = {
    let timeFormatter = DateFormatter()
    timeFormatter.dateStyle = .short
    timeFormatter.timeStyle = .none
    
    return timeFormatter
}()

private let localDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    return dateFormatter
}()
    
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

func chartLabelSettings() -> ChartLabelSettings {
    var settings = ChartLabelSettings()
    settings.font = UIFont.systemFont(ofSize: 14)
    settings.fontColor = UIColor.black
    settings.rotation = 0
    settings.rotationKeep = .center
    settings.shiftXOnRotation = true
    settings.textAlignment = .default
    
    return settings
}

func makeChartPoints(sessions: [Session], strength: Bool) -> [ChartPoint] {
    return sessions.map{
        ChartPoint(x: ChartAxisValueDate(date: $0.date!, formatter: dateFormatter), y: ChartAxisValueInt(Int(strength ? $0.strengthRating : $0.sessionRating)))
    }
}

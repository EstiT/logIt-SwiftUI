//
//  Utils.swift
//  logIt
//
//  Created by Esti Tweg on 28/11/2022.
//

import Foundation
import SwiftUI

enum TimeRange {
    case last30Days
    case last6Months
    case last12Months
}

struct TimeRangePicker: View {
    @Binding var value: TimeRange

    var body: some View {
        Picker("Time Range", selection: $value.animation(.easeInOut)) {
            Text("30 Days").tag(TimeRange.last30Days)
            Text("6 Months").tag(TimeRange.last6Months)
            Text("12 Months").tag(TimeRange.last12Months)
        }
        .pickerStyle(.segmented)
    }
}

let sessions: [Session] = []
struct StatsLink: View {
    var body: some View {
        NavigationLink("Session Statistics", value: sessions)
    }
}

struct PieView: View {
    @Binding var slices: [(Double, Color)]
    var body: some View {
        Canvas { context, size in
            let total = slices.reduce(0) { $0 + $1.0 }
            context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
            var pieContext = context
            pieContext.rotate(by: .degrees(-90))
            let radius = min(size.width, size.height) * 0.48
            var startAngle = Angle.zero
            for (value, color) in slices {
                let angle = Angle(degrees: 360 * (value / total))
                let endAngle = startAngle + angle
                let path = Path { p in
                    p.move(to: .zero)
                    p.addArc(center: .zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                    p.closeSubpath()
                }
                pieContext.fill(path, with: .color(color))
                
                startAngle = endAngle
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

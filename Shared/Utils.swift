//
//  Utils.swift
//  logIt
//
//  Created by Esti Tweg on 28/11/2022.
//

import Foundation
import SwiftUI
import UIKit

enum SeshType: CustomStringConvertible {
    case climbInside
    case climbOutside
    case gymWeights
    var description: String {
        switch self {
        case .climbInside: return "Climb Inside"
        case .climbOutside: return "Climb Outside"
        case .gymWeights: return "Gym Weights"
        }
    }
}

enum TimeRange: CustomStringConvertible {
    case last30Days
    case last6Months
    case last12Months
    var description: String {
        switch self {
            case .last30Days: return "30 Days"
            case .last6Months: return "6 Months"
            case .last12Months: return "12 Months"
        }
    }
}

struct TimeRangePicker: View {
    @Binding var value: TimeRange

    var body: some View {
        Picker("Time Range", selection: $value.animation(.easeInOut)) {
            Text(TimeRange.last30Days.description).tag(TimeRange.last30Days)
            Text(TimeRange.last6Months.description).tag(TimeRange.last6Months)
            Text(TimeRange.last12Months.description).tag(TimeRange.last12Months)
        }
        .pickerStyle(.segmented)
    }
}

let sessions: [Session] = []
struct StatsLink: View {
    var body: some View {
        NavigationLink("Climbing Session Statistics", value: sessions)
    }
}

struct PieView: View {
    @Binding var slices: [(Double, Color)]
    var id: String
    @State private var animate = false
    var body: some View {
        ZStack {
            ForEach(0..<slices.count, id: \.self) { index in
                Circle()
                    .trim(from: index == 0 ? 0.0 : slices[index-1].0/100,
                          to: index == slices.count-1 ? 100.0 : slices[index].0/100)
                    .stroke(slices[index].1, lineWidth: 100)
                    .animation(.spring(), value: animate)
            }
        }
        .onChange(of: id) { value in
            animate = !animate
        }
    }
}


extension String {
    func textToImage() -> UIImage? {
        let nsString = (self as NSString)
        let font = UIFont.systemFont(ofSize: 22) // you can change your font size here
        let stringAttributes = [NSAttributedString.Key.font: font]
        let imageSize = nsString.size(withAttributes: stringAttributes)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0) //  begin image context
        UIColor.clear.set() // clear background
        UIRectFill(CGRect(origin: CGPoint(), size: imageSize)) // set rect size
        nsString.draw(at: CGPoint.zero, withAttributes: stringAttributes) // draw text within rect
        let image = UIGraphicsGetImageFromCurrentImageContext() // create image from context
        UIGraphicsEndImageContext() //  end image context
        
        return image ?? UIImage()
    }
}

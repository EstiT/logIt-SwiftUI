//
//  ChartTabView.swift
//  logIt
//
//  Created by Esti Tweg on 25/9/21.
//

import CoreData
import SwiftUI

struct ChartTabView: View {
    var body: some View {
        Text("The content of the first view")
            .tabItem {
                Image(systemName: "calendar")
                Text("Trend")
            }
    }
}

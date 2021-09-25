//
//  LogTabView.swift
//  logIt
//
//  Created by Esti Tweg on 25/9/21.
//

import CoreData
import SwiftUI

struct LogTabView: View {
    var body: some View {
        Text("The content of the second view")
            .tabItem {
                Image(systemName: "square.and.pencil")
                Text("Log")
            }
    }
}

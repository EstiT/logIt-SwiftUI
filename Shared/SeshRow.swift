//
//  SeshRow.swift
//  logIt
//
//  Created by Esti Tweg on 27/9/21.
//

import SwiftUI

struct SeshRow: View {
    let sesh: Session
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(Self.dateFormatter.string(from: sesh.date!))
                .font(.title)
            HStack {
                Text("Session: \(String(sesh.sessionRating+1))")
                    .font(.subheadline)
                Spacer()
                Text("Strength: \(String(sesh.strengthRating+1))")
                    .font(.subheadline)
                Spacer()
            }
            if (sesh.notes != "Notes" && sesh.notes != "") {
                Spacer()
                Text(sesh.notes ?? "")
                    .font(.subheadline)
                Spacer()
            }
        }
    }
}

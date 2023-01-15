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
            HStack {
                Text(Self.dateFormatter.string(from: sesh.date!))
                    .font(.title)
                Spacer()
                Text(sessionEmoji(sesh))
                    .font(.callout)
                    .multilineTextAlignment(.trailing)
            }
            HStack {
                Text("Session: \(String(sesh.sessionRating))")
                    .font(.subheadline)
                if sesh.type != SeshType.gymWeights.description {
                    Spacer()
                    Text("Strength: \(String(sesh.strengthRating))")
                        .font(.subheadline)
                    Spacer()
                }
                
            }
            if (sesh.notes != "Notes" && sesh.notes != "") {
                Spacer()
                Text(sesh.notes ?? "")
                    .font(.subheadline)
                Spacer()
            }
        }.textSelection(.enabled)
    }
}

func sessionEmoji(_ sesh: Session) -> String {
    if let type = sesh.type {
        if type.description == SeshType.gymWeights.description {
            return "🏋🏻"
        }
        if type.description == SeshType.climbOutside.description {
            return "🪨"
        }
    }
    return "🧗🏻‍♀️"
}

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
      
        Text("Session Rating: \(String(sesh.sessionRating+1))")
          .font(.subheadline)
        Spacer()
        Text("Strength Rating: \(String(sesh.strengthRating+1))")
          .font(.subheadline)
        Spacer()
      
    }
  }
}

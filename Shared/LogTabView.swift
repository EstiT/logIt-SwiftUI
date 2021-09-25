//
//  LogTabView.swift
//  logIt
//
//  Created by Esti Tweg on 25/9/21.
//

import CoreData
import SwiftUI

struct LogTabView: View {
    @State var selectedDate = Date()
    
    var body: some View {
        VStack{
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
            Text("Strength Rating:")
            HStack{
                Button(action: select) {
                    Label("Weak", systemImage: "minus")
                }
                Button(action: select) {
                    Label("Average", systemImage: "")
                }
                Button(action: select) {
                    Label("Strong", systemImage: "")
                    Label("", systemImage: "plus")
                }
            }
            Text("Overall Session Rating:")
            HStack{
                Button(action: select) {
                    Label("Meh", systemImage: "minus")
                }
                Button(action: select) {
                    Label("Average", systemImage: "")
                }
                Button(action: select) {
                    Label("Good", systemImage: "")
                    Label("", systemImage: "plus")
                }
            }
            Button(action: select) {
                Label("Save", systemImage: "")
            }
        }
        .tabItem {
            Image(systemName: "square.and.pencil")
            Text("Log")
        }
        
    }
}

private func select(){
    
}

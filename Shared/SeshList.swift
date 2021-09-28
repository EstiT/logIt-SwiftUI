//
//  SeshList.swift
//  logIt
//
//  Created by Esti Tweg on 27/9/21.
//

import CoreData
import SwiftUI
import AlertToast

struct SeshList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Session.date, ascending: true)],
        animation: .default)
    private var sessions: FetchedResults<Session>
    @State private var showFail = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                List {
                    ForEach(sessions) { session in
                        SeshRow(sesh: session)
                    }.onDelete(perform: deleteItem)
                }
                .toast(isPresenting: $showFail){
                    AlertToast(displayMode: .alert, type: .regular, title: "Failed to save")
                }
                .navigationBarTitle("Session List")
            }
        }
    }
    
    private func deleteItem(offsets: IndexSet) {
        withAnimation {
            offsets.map { sessions[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                showFail.toggle()
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }

        saveContext()
    }
    
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            showFail.toggle()
            print("Error saving managed object context: \(error)")
        }
    }
    
}

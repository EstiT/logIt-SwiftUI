//
//  LogTabView.swift
//  logIt
//
//  Created by Esti Tweg on 25/9/21.
//

import CoreData
import SwiftUI
import AlertToast

struct LogTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var selectedDate = Date()
    @State var note = "Notes"
    @State private var strengthIndex = 2
    @State private var sessionIndex = 2
    @State var injured = false
    var strengthOptions = ["1 - Weak Sauce", "2 - Weak", "3 - Average", "4 - Good", "5 - Strong"]
    var sessionOptions = ["1 - Shit", "2 - Meh", "3 - Average", "4 - Good", "5 - Excellent"]
    @State private var showSuccess = false
    @State private var showFail = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                Form {
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                    
                    Section(header: Text("Ratings")){
                        Picker(selection: $strengthIndex, label: Text("Strength Rating")) {
                            ForEach(0 ..< strengthOptions.count) {
                                Text(self.strengthOptions[$0])
                            }
                        }
                        Picker(selection: $sessionIndex, label: Text("Session Rating")) {
                            ForEach(0 ..< sessionOptions.count) {
                                Text(self.sessionOptions[$0])
                            }
                        }
                    }
                    Section(header: Text("Details")) {
                        Toggle(isOn: $injured) {
                            Text("Injured?")
                        }
                        TextEditor(text: $note)
                            .frame(height: geometry.size.height / 5, alignment: .center)
                            .onTapGesture {
                                if self.note == "Notes" {
                                    self.note = ""
                                }
                            }
                    }
                    Section {
                        Button(action: save) {
                            Text("Save")
                        }
                    }
                }.toast(isPresenting: $showSuccess){
                    AlertToast(displayMode: .alert, type: .regular, title: "Saved")
                }
                .toast(isPresenting: $showFail){
                    AlertToast(displayMode: .alert, type: .regular, title: "Failed to save")
                }
                .navigationTitle("Log a sesh")
            }
        }
    }
    
    private func save(){
        let newSesh = Session(context: viewContext)
        newSesh.date = selectedDate
        newSesh.injured = injured
        newSesh.notes = note
        newSesh.strengthRating = Int16(strengthIndex + 1)
        newSesh.sessionRating = Int16(sessionIndex + 1)
        do {
            try viewContext.save()
            showSuccess.toggle()
            clearForm()
        } catch {
            showFail.toggle()
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    
    private func clearForm() {
        note = "Notes"
        strengthIndex = 2
        sessionIndex = 2
        selectedDate = Date()
    }
}



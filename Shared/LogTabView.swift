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
    @State var seshType: SeshType = .climbInside
    
    var strengthOptions = ["1 - Weak Sauce", "2 - Weak", "3 - Average", "4 - Good", "5 - Strong"]
    var sessionOptions = ["1 - Shit", "2 - Meh", "3 - Average", "4 - Good", "5 - Excellent"]
    var weightOptions = ["N/A", "5kg", "10kg", "15kg","17kg", "20kg", "22kg", "25kg", "30kg", "35kg", "40kg", "45kg", "50kg", "55kg","60kg", "65kg", "70kg", "75kg"]
    
    @State private var showSuccess = false
    @State private var showFail = false
    
    @State var weightExercises = ["Deadlift", "Bench Press", "Rows"]
    @State var weightSelectedIndex = [14, 8, 3]
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                Form {
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                    
                    Section(header: Text("Session Type")){
                        Picker("Session Type", selection: $seshType.animation(.easeInOut)) {
                            Text(SeshType.climbInside.description).tag(SeshType.climbInside)
                            Text(SeshType.climbOutside.description).tag(SeshType.climbOutside)
                            Text(SeshType.gymWeights.description).tag(SeshType.gymWeights)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    
                    Section(header: Text(seshType == .gymWeights ? "Rating": "Ratings")){
                        
                        if seshType != .gymWeights {
                            Picker(selection: $strengthIndex, label: Text("Strength Rating")) {
                                ForEach(0 ..< strengthOptions.count, id: \.self) {
                                    Text(self.strengthOptions[$0])
                                }
                            }
                        }
                        
                        Picker(selection: $sessionIndex, label: Text("Session Rating")) {
                            ForEach(0 ..< sessionOptions.count, id: \.self) {
                                Text(self.sessionOptions[$0])
                            }
                        }
                    }
                    
                    if seshType == .gymWeights {
                        Section(header: Text("Exercises")){
                            ForEach(weightExercises.indices, id: \.self) { index in
                                Picker(selection: $weightSelectedIndex[index], label: Text(weightExercises[index])) {
                                    ForEach(0 ..< weightOptions.count, id: \.self) {
                                        Text(self.weightOptions[$0])
                                    }
                                }
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
        newSesh.type = seshType.description
        newSesh.injured = injured
        newSesh.notes = note
        newSesh.strengthRating = Int16(strengthIndex + 1)
        newSesh.sessionRating = Int16(sessionIndex + 1)
        
        if seshType == .gymWeights {
            newSesh.strengthRating = 3
            newSesh.deadliftWeight = weightOptions[weightSelectedIndex[0]]
            newSesh.benchPressWeight = weightOptions[weightSelectedIndex[1]]
            newSesh.rowWeight = weightOptions[weightSelectedIndex[2]]
        }
        
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
        seshType = SeshType.climbInside
    }
}



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
                .modifier(DismissingKeyboard())
                .navigationTitle("Log a sesh")
            }
        }
    }
    
    private func save(){
        let newSesh = Session(context: viewContext)
        newSesh.date = selectedDate
        newSesh.injured = injured
        newSesh.strengthRating = Int16(strengthIndex)
        newSesh.sessionRating = Int16(sessionIndex)
        do {
            try viewContext.save()
            showSuccess.toggle()
        } catch {
            showFail.toggle()
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    struct DismissingKeyboard: ViewModifier {
        func body(content: Content) -> some View {
            content
                .onTapGesture {
                    let keyWindow = UIApplication.shared.connectedScenes
                            .filter({$0.activationState == .foregroundActive})
                            .map({$0 as? UIWindowScene})
                            .compactMap({$0})
                            .first?.windows
                            .filter({$0.isKeyWindow}).first
                    keyWindow?.endEditing(true)
            }
        }
    }
}



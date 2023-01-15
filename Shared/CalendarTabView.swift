//
//  CalendarTabView.swift
//  logIt
//
//  Created by Esti Tweg on 12/1/2023.
//

import Foundation
import CoreData
import SwiftUI
import UIKit

struct CalendarTabView: View {
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Session.date, ascending: true)],
        predicate: NSPredicate(format: "type != %@", SeshType.gymWeights.description),
        animation: .default)
    private var climbingSessions: FetchedResults<Session>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Session.date, ascending: true)],
        predicate: NSPredicate(format: "type == %@", SeshType.gymWeights.description),
        animation: .default)
    private var weightsSessions: FetchedResults<Session>
    
    
   @State private var selectedSession: Session? = nil
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                List {
                    CalendarView(climbingSessions: climbingSessions, weightsSessions: weightsSessions, selectedSession: $selectedSession)
                        .frame(idealHeight: 290, maxHeight: 315)
                    
                    
                    if let selectedSession {
                        Section(header: Text("Details")) {
                            SeshRow(sesh: selectedSession)
                        }
                    }
                }
                
            }.navigationBarTitle("Calendar View")
        }
    }
}


struct CalendarView: UIViewRepresentable {
    var climbingSessions: FetchedResults<Session>
    var weightsSessions: FetchedResults<Session>
    @Binding var selectedSession: Session?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(climbingSessions: climbingSessions, weightsSessions: weightsSessions, selectedSession: $selectedSession)
    }
    
    
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.delegate = context.coordinator
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.tintColor = .systemTeal
        calendarView.layer.cornerCurve = .continuous
        calendarView.layer.cornerRadius = 10.0
        calendarView.availableDateRange = DateInterval(start: .distantPast, end: .now)
        
        let selection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        calendarView.selectionBehavior = selection

        calendarView.transform = CGAffineTransform.identity.scaledBy(x: 0.85, y: 0.85)

        return calendarView
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
    }
    
   
}

extension CalendarView {
    class Coordinator: NSObject, UICalendarSelectionSingleDateDelegate, UICalendarViewDelegate {
        
        var climbingSessions: FetchedResults<Session>
        var weightsSessions: FetchedResults<Session>
        @Binding var selectedSession: Session?
        
        init(climbingSessions: FetchedResults<Session>, weightsSessions: FetchedResults<Session>, selectedSession: Binding<Session?>) {
            
            self.climbingSessions = climbingSessions
            self.weightsSessions = weightsSessions
            self._selectedSession = selectedSession
            super.init()
        }

        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            if let dateComponents = dateComponents {
                guard let date = NSCalendar.current.date(from: dateComponents) else {
                    return
                }
                let sessions = Array(climbingSessions) + Array(weightsSessions)
                selectedSession = sessions.first(where: { Calendar.current.isDate($0.date!, equalTo: date, toGranularity: .day)})!
            }
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
            if let dateComponents = dateComponents {
                guard let date = NSCalendar.current.date(from: dateComponents) else {
                    return true
                }
                if climbingSessions.contains(where: { Calendar.current.isDate($0.date!, equalTo: date, toGranularity: .day) }) ||
                    weightsSessions.contains(where: { Calendar.current.isDate($0.date!, equalTo: date, toGranularity: .day) })  {
                    return true
                }
            }
            return false
        }
        
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            guard let date = NSCalendar.current.date(from: dateComponents) else {
                return nil
            }
        
            if let climbSesh = climbingSessions.first(where: { Calendar.current.isDate($0.date!, equalTo: date, toGranularity: .day) }) {
                if climbSesh.type == SeshType.climbOutside.description {
                    return UICalendarView.Decoration.image("🪨".textToImage())
                }
                return UICalendarView.Decoration.image("🧗🏻‍♀️".textToImage())
            }
            
            if weightsSessions.contains(where: { Calendar.current.isDate($0.date!, equalTo: date, toGranularity: .day) }) {
                return UICalendarView.Decoration.image("🏋🏻".textToImage())
            }
            
            return nil
        }
        
        
    }
}

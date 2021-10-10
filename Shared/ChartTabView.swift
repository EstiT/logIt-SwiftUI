//
//  ChartTabView.swift
//  logIt
//
//  Created by Esti Tweg on 25/9/21.
//

import CoreData
import SwiftUI

struct ChartTabView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Session.date, ascending: true)],
        animation: .default)
    private var sessions: FetchedResults<Session>
    
    
    var body: some View {
//        let strengthArr = sessions.map{Double($0.strengthRating)/5*100}
//        let sessionArr = sessions.map{Double($0.sessionRating)/5*100}
        NavigationView {
            GeometryReader { geometry in
                
                if sessions.count > 0 {
                    let storageProvider = PersistenceController()
                    let sessionsArr = storageProvider.getAllSessions()

                    ChartView(sessions: sessionsArr).frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }
                else {
                    HStack{
                        Spacer()
                        Text("No data")
                        Spacer()
                    } .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }
            } .navigationBarTitle("Trends")
        }
    }
}

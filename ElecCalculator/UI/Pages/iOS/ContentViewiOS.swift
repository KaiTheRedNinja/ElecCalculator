//
//  ContentViewiOS.swift
//  ElecCalculator
//
//  Created by Kai Quan Tay on 3/2/23.
//

import SwiftUI

#if os(iOS)
struct ContentViewiOS: View {
    var body: some View {
        TabView {
            ResistorIdentificationViewiOS()
                .tabItem {
                    Label("Resistors Identifier", systemImage: "dumbbell.fill")
                }

            CircuitCalculatorViewiOS()
                .tabItem {
                    Label("Circuit Calculator", systemImage: "arrow.triangle.branch")
                }

            RelationCalculatorViewiOS()
                .tabItem {
                    Label("Formulas", systemImage: "x.squareroot")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewiOS()
    }
}
#endif

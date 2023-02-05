//
//  ContentView.swift
//  ElecCalculator
//
//  Created by Kai Quan Tay on 3/2/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ResistorIdentificationView()
                .tabItem {
                    Label("Resistors Identifier", systemImage: "circle.fill")
                }

            CircuitCalculatorView()
                .tabItem {
                    Label("Circuit Calculator", systemImage: "circle.fill")
                }

            RelationCalculatorView()
                .tabItem {
                    Label("Formulas", systemImage: "circle.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

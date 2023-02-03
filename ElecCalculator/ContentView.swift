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
            CircuitCalculatorView()
                .tabItem {
                    Label("HI", systemImage: "circle.fill")
                }

            RelationCalculatorView()
                .tabItem {
                    Label("HI2", systemImage: "circle.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

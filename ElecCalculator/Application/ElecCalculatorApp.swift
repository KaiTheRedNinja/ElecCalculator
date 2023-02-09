//
//  ElecCalculatorApp.swift
//  ElecCalculator
//
//  Created by Kai Quan Tay on 3/2/23.
//

import SwiftUI

@main
struct ElecCalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            ContentViewiOS()
            #elseif os(macOS)
            Text("HI!")
            #endif
        }
    }
}

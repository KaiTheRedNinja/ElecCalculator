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
        #if os(iOS)
        WindowGroup {
            ContentViewiOS()
        }

        #elseif os(macOS)

        WindowGroup {
            ContentViewmacOS()
        }
        #endif
    }
}

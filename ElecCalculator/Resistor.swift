//
//  Resistor.swift
//  ElecCalculator
//
//  Created by Kai Quan Tay on 4/2/23.
//

import SwiftUI

struct Resistor: Identifiable, Hashable {
    var id: String { "\(resistance) +- \(tolerance)" }

    var resistance: Int
    var tolerance: Int

    var multiplier: Int {
        var value = 0
        var mutableRes = resistance
        while mutableRes > 99 {
            value += 1
            mutableRes /= 10
        }
        return value
    }

    var valueWithoutMultiplier: Int {
        return resistance / Int(pow(CGFloat(10), CGFloat(multiplier)))
    }

    var firstValue: Int {
        Int(valueWithoutMultiplier / 10)
    }

    var secondValue: Int {
        Int(valueWithoutMultiplier % 10)
    }

    static func valueToColor(value: Int) -> Color {
        switch value {
        case 0: return .black
        case 1: return .brown
        case 2: return .red
        case 3: return .orange
        case 4: return .yellow
        case 5: return .green
        case 6: return .blue
        case 7: return .purple
        case 8: return .gray
        case 9: return .white
        default: return .white.opacity(0.01)
        }
    }

    static func multiplierToColor(multiplier: Int) -> Color {
        switch multiplier+1 {
        case 1: return .black   // 1
        case 2: return .brown
        case 3: return .red
        case 4: return .orange  // 1K
        case 5: return .yellow
        case 6: return .green
        case 7: return .blue    // 1M
        case 8: return .purple
        default: return .white.opacity(0.01)
        }
    }

    static func toleranceToColor(tolerance: Int) -> Color {
        switch tolerance {
        case 1: return .brown
        case 2: return .red
        case 5: return .yellow
        case 10: return .gray
        default: return .white.opacity(0.01)
        }
    }
}

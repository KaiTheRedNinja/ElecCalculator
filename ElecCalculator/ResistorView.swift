//
//  ResistorView.swift
//  ElecCalculator
//
//  Created by Kai Quan Tay on 3/2/23.
//

import SwiftUI

struct ResistorView: View {
    var resistor: Resistor

    var body: some View {
        ZStack {
            Color.brown
            Color.white.opacity(0.3)
            HStack {
                Spacer()
//                Text("\(resistor.firstValue)")
                valueToColor(value: resistor.firstValue)
                    .frame(width: 20)
//                Text("\(resistor.secondValue)")
                valueToColor(value: resistor.secondValue)
                    .frame(width: 20)
//                Text("\(Int(pow(CGFloat(10), CGFloat(resistor.multiplier))))")
                multiplierToColor(multiplier: resistor.multiplier)
                    .frame(width: 20)
                Spacer()
//                Text("\(resistor.tolerance)")
                toleranceToColor(tolerance: resistor.tolerance)
                    .frame(width: 20)
                Spacer()
            }
        }
        .overlay {
            VStack {
                HStack {
                    Spacer().frame(width: 60)
                    Color.white.frame(height: 8)
                    Spacer().frame(width: 60)
                }
                Spacer()
                HStack {
                    Spacer().frame(width: 60)
                    Color.white.frame(height: 8)
                    Spacer().frame(width: 60)
                }
            }
        }
        .cornerRadius(30)
        .frame(width: 300, height: 100)
    }

    func valueToColor(value: Int) -> Color {
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
        default: return .clear
        }
    }

    func multiplierToColor(multiplier: Int) -> Color {
        switch multiplier+1 {
        case 1: return .black   // 1
        case 2: return .brown
        case 3: return .red
        case 4: return .orange  // 1K
        case 5: return .yellow
        case 6: return .green
        case 7: return .blue    // 1M
        case 8: return .purple
        default: return .clear
        }
    }

    func toleranceToColor(tolerance: Int) -> Color {
        switch tolerance {
        case 1: return .brown
        case 2: return .red
        case 5: return .yellow
        case 10: return .gray
        default: return .clear
        }
    }
}

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
}

struct ResistorView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ResistorView(resistor: .init(resistance: 10,
                                         tolerance: 5))
            ResistorView(resistor: .init(resistance: 220,
                                         tolerance: 5))
            ResistorView(resistor: .init(resistance: 2095,
                                         tolerance: 5))
            ResistorView(resistor: .init(resistance: 3,
                                         tolerance: 5))
            ResistorView(resistor: .init(resistance: 0,
                                         tolerance: 5))
        }
    }
}

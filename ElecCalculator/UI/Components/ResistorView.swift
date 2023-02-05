//
//  ResistorView.swift
//  ElecCalculator
//
//  Created by Kai Quan Tay on 3/2/23.
//

import SwiftUI

struct ResistorView: View {
    @State
    var resistor: Resistor

    var body: some View {
        ZStack {
            Color.brown
            Color.white.opacity(0.3)
            HStack {
                Spacer()
                Resistor.valueToColor(value: resistor.firstValue)
                    .frame(width: 20)
                Resistor.valueToColor(value: resistor.secondValue)
                    .frame(width: 20)
                Resistor.multiplierToColor(multiplier: resistor.multiplier)
                    .frame(width: 20)
                Spacer()
                Resistor.toleranceToColor(tolerance: resistor.tolerance)
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

//
//  ResistorIdentificationView.swift
//  ElecCalculator
//
//  Created by Kai Quan Tay on 4/2/23.
//

import SwiftUI

struct ResistorIdentificationView: View {
    @State var resistor: Resistor = .init(resistance: 220, tolerance: 5)

    var body: some View {
        List {
            Section {
                EditableResistorView(resistor: $resistor)
                    .frame(height: 110)
            }

            Section {
                HStack {
                    Text("Resistance:")
                    Spacer()
                    Text("\(resistor.resistance) Ω")
                }
                HStack {
                    Text("Tolerance")
                    Spacer()
                    Text("±\(resistor.tolerance)%")
                }
                HStack {
                    Text("Maximum Value:")
                    Spacer()
                    Text("\(String(format: "%.2f", CGFloat(resistor.resistance) * CGFloat(100 + resistor.tolerance) / CGFloat(100))) Ω")
                }
                HStack {
                    Text("Minimum Value:")
                    Spacer()
                    Text("\(String(format: "%.2f", CGFloat(resistor.resistance) * CGFloat(100 - resistor.tolerance) / CGFloat(100))) Ω")
                }
            }
        }
    }
}

struct ResistorIdentificationView_Previews: PreviewProvider {
    static var previews: some View {
        ResistorIdentificationView()
    }
}

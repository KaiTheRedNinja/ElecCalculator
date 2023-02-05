//
//  ResistorIdentificationView.swift
//  ElecCalculator
//
//  Created by Kai Quan Tay on 4/2/23.
//

import SwiftUI

struct ResistorIdentificationView: View {
    @State var resistor: Resistor = .init(resistance: 220, tolerance: 5)

    // incremented whenever the resistor view needs updating
    @State var updator: Int = 0

    var body: some View {
        List {
            Section {
                EditableResistorView(resistor: $resistor)
                    .frame(height: 110)
                    .id(updator)
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

            Section("Common Resistors") {
                ForEach([220, 1000], id: \.self) { resistance in
                    Button {
                        resistor.resistance = resistance
                        updator += 1
                    } label: {
                        HStack {
                            ResistorView(resistor: .init(resistance: resistance, tolerance: 5))
                                .scaleEffect(.init(0.2))
                                .frame(width: 60, height: 30)
                            Spacer()
                            Text("\(resistance) Ω")
                                .foregroundColor(.primary)
                        }
                    }
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
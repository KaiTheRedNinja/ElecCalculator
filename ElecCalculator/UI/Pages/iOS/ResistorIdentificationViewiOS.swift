//
//  ResistorIdentificationViewiOS.swift
//  ElecCalculator
//
//  Created by Kai Quan Tay on 4/2/23.
//

import SwiftUI
import Equation

#if os(iOS)
struct ResistorIdentificationViewiOS: View {
    @State var resistor: Resistor = .init(resistance: 220, tolerance: 5)

    // incremented whenever the resistor view needs updating
    @State var updator: Int = 0

    var body: some View {
        List {
            Section {
                HStack {
                    Text("Resistance:")
                    Spacer()
                    Text("\(resistor.resistance)")
                    UnitTextView("Ω", font: .system(.body, design: .serif))
                }
                HStack {
                    Text("Tolerance")
                    Spacer()
                    Text("±\(resistor.tolerance)%")
                }
                HStack {
                    Text("Maximum Value:")
                    Spacer()
                    Text("\(String(format: "%.2f", CGFloat(resistor.resistance) * CGFloat(100 + resistor.tolerance) / CGFloat(100)))")
                    UnitTextView("Ω", font: .system(.body, design: .serif))
                }
                HStack {
                    Text("Minimum Value:")
                    Spacer()
                    Text("\(String(format: "%.2f", CGFloat(resistor.resistance) * CGFloat(100 - resistor.tolerance) / CGFloat(100)))")
                    UnitTextView("Ω", font: .system(.body, design: .serif))
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
                            Text("\(resistance)")
                            UnitTextView("Ω", font: .system(.body, design: .serif))
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
        }
        .safeAreaInset(edge: .top) {
            EditableResistorView(resistor: $resistor)
                .frame(height: 200)
                .offset(y: 20)
                .id(updator)
        }
    }
}

struct ResistorIdentificationView_Previews: PreviewProvider {
    static var previews: some View {
        ResistorIdentificationViewiOS()
    }
}
#endif

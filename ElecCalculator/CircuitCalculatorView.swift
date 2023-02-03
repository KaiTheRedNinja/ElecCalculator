//
//  CircuitCalculatorView.swift
//  ElecCalculator
//
//  Created by Kai Quan Tay on 3/2/23.
//

import SwiftUI

struct CircuitCalculatorView: View {
    // in ohms
    @State var resistences: [Double] = [10, 10]

    @State var tempResist: Double = 0

    @State var voltage: Double = 0

    @State var circuitType: CircuitType = .series

    enum CircuitType: String, CaseIterable {
        case parallel = "Parallel"
        case series = "Series"
    }

    var body: some View {
        List {
            Section {
                ZStack {
                    Color.black.frame(height: 10)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(resistences, id: \.self) { resistance in
                                ResistorView(resistor: .init(resistance: Int(resistance),
                                                             tolerance: 5))
                                .scaleEffect(.init(0.2))
                                .frame(width: 80)
                            }
                        }
                    }
                }
                .padding(.horizontal, -20)
            }

            Section {
                Picker("Circuit Type", selection: $circuitType) {
                    ForEach(CircuitType.allCases, id: \.rawValue) { type in
                        Text(type.rawValue)
                            .tag(type)
                    }
                }
                .pickerStyle(.segmented)
                HStack {
                    Text("Voltage")
                    TextField("Voltage",
                              value: $voltage,
                              formatter: NumberFormatter())
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(voltage == 0 ? .gray : .primary)
                    Text("V")
                        .foregroundColor(voltage == 0 ? .gray : .primary)
                }

                ForEach(0..<resistences.count, id: \.self) { index in
                    HStack {
                        Text("R\(index+1)")
                        TextField("Resistence",
                                  value: $resistences[index],
                                  formatter: NumberFormatter())
                        .multilineTextAlignment(.trailing)
                        Text("Ω")
                    }
                }
                .onDelete { indexSet in
                    resistences.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, index in
                    resistences.move(fromOffsets: indexSet, toOffset: index)
                }

                HStack {
                    Text("R\(resistences.count+1)")
                        .italic()
                    TextField("Resistence",
                              value: $tempResist,
                              formatter: NumberFormatter())
                    .onSubmit {
                        tempResist = 0
                        resistences.append(tempResist)
                    }
                    .multilineTextAlignment(.trailing)
                    Text("Ω")
                }
                .foregroundColor(.gray)
            }

            Section {
                HStack {
                    Text("Effective Resistence:")
                    Spacer()
                    Text(totalResistence().twoDP + " Ω")
                }
                HStack {
                    Text("Current:")
                    Spacer()
                    Text((voltage/totalResistence()).twoDP + " A")
                }
                ForEach(0..<resistences.count, id: \.self) { index in
                    HStack {
                        Text("V\(index)")
                        Spacer()
                        Text((voltage * resistences[index] / totalResistence()).twoDP + " V")
                    }
                }
                .foregroundColor(voltage == 0 ? .gray : .primary)
            }
            .animation(.default, value: circuitType)
        }
    }

    func totalResistence() -> Double {
        switch circuitType {
        case .series:
            return resistences.reduce(Double(0), { $0 + $1 })
        case .parallel:
            return 1/resistences.reduce(Double(0)) { partialResult, next in
                partialResult + (1/next)
            }
        }
    }

    // V = IR
    func current() -> Double {
        let resistence = totalResistence()
        return resistence != 0 ? (voltage / resistence) : 0
    }
}

struct CircuitCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CircuitCalculatorView()
    }
}

extension Double {
    var twoDP: String {
        String(format: "%.2f", self)
    }
}

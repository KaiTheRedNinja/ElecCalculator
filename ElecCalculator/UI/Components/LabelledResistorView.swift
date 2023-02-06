//
//  LabelledResistorView.swift
//  ElecCalculator
//
//  Created by Kai Quan Tay on 5/2/23.
//

import SwiftUI
import Updating

struct LabelledResistorView: View {
    @Updating var circuitType: CircuitType
    @Updating var voltage: Double
    @Updating var totalResistence: Double

    @Updating var resistance: Double

    var body: some View {
        ZStack {
            if circuitType == .parallel {
                VStack {
                    Rectangle()
                        .fill(LinearGradient(stops: [.init(color: .red, location: 0),
                                                     .init(color: .blue, location: 1)],
                                             startPoint: .top,
                                             endPoint: .bottom))
                    Rectangle()
                        .fill(LinearGradient(stops: [.init(color: .blue, location: 0),
                                                     .init(color: .red, location: 1)],
                                             startPoint: .bottom,
                                             endPoint: .top))
                }
                .frame(width: 10)
            }
            ResistorView(resistor: .init(resistance: Int(resistance),
                                         tolerance: 5))
            .scaleEffect(.init(0.2))
            .frame(width: circuitType == .series ? 80 : 100)
            .rotationEffect(circuitType == .series ? .zero : .degrees(90))
        }
        .overlay {
            switch circuitType {
            case .series:
                VStack {
                    Spacer()
                    Text("\(resistance.twoDP) Ω")
                    Spacer()
                    Text("\(Double(thisVoltage).twoDP) V")
                    Spacer()
                }
            case .parallel:
                HStack {
                    Text("\(Int(resistance.rounded()))\nΩ")
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing, 15)
                    Spacer()
                        .frame(width: 40)
                    Text("\(Int((thisVoltage/resistance).rounded()))\nA")
                        .multilineTextAlignment(.leading)
                        .padding(.leading, -18)
                }
            }
        }
    }

    var thisVoltage: CGFloat {
        switch circuitType {
        case .parallel:
            return voltage // voltage is the same across the whole circuit
        case .series:
            guard totalResistence != 0 else { return 0 }
            return voltage * resistance / totalResistence
        }
    }
}

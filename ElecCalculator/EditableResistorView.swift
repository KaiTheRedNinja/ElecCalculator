//
//  EditableResistorView.swift
//  ElecCalculator
//
//  Created by Kai Quan Tay on 3/2/23.
//

import SwiftUI

struct EditableResistorView: View {
    @Binding var resistor: Resistor
    @State var firstValue: Int
    @State var secondValue: Int
    @State var multiplier: Int
    @State var tolerance: Int

    init(resistor: Binding<Resistor>) {
        self._resistor = resistor
        self.firstValue = resistor.wrappedValue.firstValue
        self.secondValue = resistor.wrappedValue.secondValue
        self.multiplier = resistor.wrappedValue.multiplier
        self.tolerance = resistor.wrappedValue.tolerance
    }

    var body: some View {
        ZStack {
            Color.brown
            Color.white.opacity(0.3)
            HStack {
                Spacer()
//                Resistor.valueToColor(value: firstValue)
//                    .gesture(upDownGesture(change: { amount in
//                        let newValue = resistor.firstValue + amount
//                        guard newValue >= 0 && newValue < 10 else { return }
//                        withAnimation {
//                            firstValue = newValue
//                        }
//                    }, confirm: {
//                        let amount = resistor.firstValue - firstValue
//                        let subtraction = amount * 10 * Int(pow(CGFloat(10), CGFloat(resistor.multiplier)))
//                        withAnimation {
//                            resistor.resistance -= subtraction
//                        }
//                    }))
//                    .frame(width: 20)
//                Resistor.valueToColor(value: secondValue)
//                    .gesture(upDownGesture(change: { amount in
//                        let newValue = resistor.secondValue + amount
//                        guard newValue >= 0 && newValue < 10 else { return }
//                        withAnimation {
//                            secondValue = newValue
//                        }
//                    }, confirm: {
//                        let amount = resistor.secondValue - secondValue
//                        let subtraction = amount * Int(pow(CGFloat(10), CGFloat(resistor.multiplier)))
//                        withAnimation {
//                            resistor.resistance -= subtraction
//                        }
//                    }))
//                    .frame(width: 20)
//                Resistor.multiplierToColor(multiplier: multiplier)
//                    .gesture(upDownGesture(change: { amount in
//                        let newValue = resistor.multiplier + amount
//                        guard newValue >= 0 && newValue < 8 else { return }
//                        withAnimation {
//                            multiplier = newValue
//                        }
//                    }, confirm: {
//                        let amount = resistor.multiplier - multiplier
//                        var value = resistor.resistance
//                        for _ in 0..<abs(amount) {
//                            if amount > 0 {
//                                value /= 10
//                            } else {
//                                value *= 10
//                            }
//                        }
//                        withAnimation {
//                            resistor.resistance = value
//                        }
//                    }))
//                    .frame(width: 20)
                Spacer()
//                Resistor.toleranceToColor(tolerance: tolerance)
//                    .gesture(upDownGesture(change: { amount in
//                        tolerance = resistor.tolerance + amount
//                    }, confirm: {
////                        resistor.tolerance = tolerance
//                    }))
//                    .frame(width: 20)
                Spacer()
            }

            Text("Res: \(resistor.resistance)")
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

    func upDownGesture(change: @escaping (Int) -> Void,
                       confirm: @escaping () -> Void) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let length = value.translation.diagonalLength
                let magnitude = value.translation.height / abs(value.translation.height)
                change(Int(floor(length*magnitude/CGFloat(30))))
            }
            .onEnded { value in
                confirm()
            }
    }
}

extension CGSize {
    /// Initialises a CGSize from the difference between two points
    init(point1: CGPoint, point2: CGPoint) {
        self.init(width: point1.x-point2.x,
                  height: point1.y-point2.y)
    }

    /// The diagonal length between two opposite corners of the CGSize. Always positive.
    var diagonalLength: CGFloat {
        return sqrt(pow(self.width, 2) + pow(self.height, 2))
    }
}

struct EditableResistorView_Previews: PreviewProvider {
    static var previews: some View {
        EditableResistorViewWrapper()
    }

    struct EditableResistorViewWrapper: View {
        @State var resistor: Resistor = .init(resistance: 690, tolerance: 1)
        var body: some View {
            VStack {
                EditableResistorView(resistor: $resistor)
                Text("Resistance: \(resistor.resistance)")
                Text("Multiplier: \(resistor.multiplier)")
            }
        }
    }
}

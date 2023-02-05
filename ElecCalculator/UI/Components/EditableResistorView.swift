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

    init(resistor: Binding<Resistor>) {
        self._resistor = resistor
        self.firstValue = resistor.wrappedValue.firstValue
        self.secondValue = resistor.wrappedValue.secondValue
        self.multiplier = resistor.wrappedValue.multiplier
    }

    var body: some View {
        ZStack {
            // the resistor shape
            ZStack {
                Color.brown
                Color.white.opacity(0.3)
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
            }
            .cornerRadius(30)
            .padding(.vertical, 50)

            HStack {
                Spacer()
                selectorForResistance(value: $firstValue)
                selectorForResistance(value: $secondValue)
                ColorSnappingScrollView(values: Array(0..<8),
                                        height: 100-16,
                                        currentValue: $multiplier,
                                        colorForValue: Resistor.multiplierToColor(multiplier:))
                .frame(width: 20, height: 200)
                .contextMenu {
                    ForEach(0..<8) { index in
                        Button {
                            multiplier = index
                        } label: {
                            Text("x\(10**index): \(Resistor.multiplierToColor(multiplier: index).description)")
                            if index == multiplier {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                } preview: {
                    Resistor.valueToColor(value: multiplier)
                        .frame(width: 20, height: 100-16)
                }
                Spacer()
                ColorSnappingScrollView(values: [1, 2, 5, 10],
                                        height: 100-16,
                                        currentValue: $resistor.tolerance,
                                        colorForValue: Resistor.toleranceToColor(tolerance:))
                .frame(width: 20, height: 200)
                .contextMenu {
                    ForEach([1, 2, 5, 10], id: \.self) { value in
                        Button {
                            resistor.tolerance = value
                        } label: {
                            Text("\(value)%: \(Resistor.toleranceToColor(tolerance: value).description)")
                            if value == resistor.tolerance {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                } preview: {
                    Resistor.toleranceToColor(tolerance: resistor.tolerance)
                        .frame(width: 20, height: 100-16)
                }
                Spacer()
            }
            .offset(y: 20)
        }
        .padding(.vertical, -100)
        .frame(width: 300, height: 0)
        .onChange(of: firstValue) { _ in
            let difference = resistor.firstValue - firstValue
            let subtract = difference * (10**(resistor.multiplier+1))
            resistor.resistance -= subtract
        }
        .onChange(of: secondValue) { _ in
            let difference = resistor.secondValue - secondValue
            let subtract = difference * (10**(resistor.multiplier))
            resistor.resistance -= subtract
        }
        .onChange(of: multiplier) { _ in
            let difference = resistor.multiplier - multiplier
            var newValue = resistor.resistance
            for _ in 0..<abs(difference) {
                if difference > 0 {
                    newValue /= 10
                } else if difference < 0 {
                    newValue *= 10
                }
            }
            resistor.resistance = newValue
        }
    }

    func selectorForResistance(value: Binding<Int>) -> some View {
        ColorSnappingScrollView(values: Array(0..<10),
                                height: 100-16,
                                currentValue: value,
                                colorForValue: Resistor.valueToColor(value:))
        .contextMenu {
            ForEach(0..<10) { index in
                Button {
                    value.wrappedValue = index
                } label: {
                    Text("\(index): \(Resistor.valueToColor(value: index).description)")
                    if index == value.wrappedValue {
                        Image(systemName: "checkmark")
                    }
                }
            }
        } preview: {
            Resistor.valueToColor(value: value.wrappedValue)
                .frame(width: 20, height: 100-16)
        }
        .frame(width: 20, height: 200)
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

infix operator **
func ** (lhs: Int, rhs: Int) -> Int {
    Int(pow(CGFloat(lhs), CGFloat(rhs)))
}

struct EditableResistorView_Previews: PreviewProvider {
    static var previews: some View {
        EditableResistorViewWrapper()
    }

    struct EditableResistorViewWrapper: View {
        @State var resistor: Resistor = .init(resistance: 69, tolerance: 1)
        var body: some View {
            VStack {
                EditableResistorView(resistor: $resistor)
                    .frame(height: 300)
                Text("Resistance: \(resistor.resistance)")
                Text("Multiplier: \(resistor.multiplier)")
                Text("Tolerance: \(resistor.tolerance)%")
            }
        }
    }
}

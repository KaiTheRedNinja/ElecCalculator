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
            ZStack {
                ResistorShape()
                    .fill(Color.brown)
                ResistorShape()
                    .fill(Color.white.opacity(0.3))
            }
                .frame(height: 100)
            .cornerRadius(30)
            .padding(.vertical, 50)

            HStack {
                Spacer()
                selectorFor(value: $firstValue,
                            values: Array(0..<10),
                            label: { "\($0)" },
                            color: Resistor.valueToColor(value:))
                selectorFor(value: $secondValue,
                            values: Array(0..<10),
                            label: { "\($0)" },
                            color: Resistor.valueToColor(value:))
                selectorFor(value: $multiplier,
                            values: Array(0..<8),
                            label: { "x\(10**$0)" },
                            color: Resistor.multiplierToColor(multiplier:))
                Spacer()
                selectorFor(value: $resistor.tolerance,
                            values: [1, 2, 5, 10],
                            label: { "\($0)%" },
                            color: Resistor.toleranceToColor(tolerance:))
                Spacer()
            }
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

    func selectorFor(value: Binding<Int>,
                     values: Array<Int>,
                     label: @escaping (Int) -> String,
                     color: @escaping (Int) -> Color) -> some View {
        ColorSnappingScrollView(values: values,
                                height: 100-16,
                                currentValue: value,
                                colorForValue: color)
        .contextMenu {
            ForEach(values, id: \.self) { val in
                Button {
                    value.wrappedValue = val
                } label: {
                    Text("\(label(val)): \(color(val).description)")
                    if val == value.wrappedValue {
                        Image(systemName: "checkmark")
                    }
                }
            }
        } preview: {
            Resistor.valueToColor(value: value.wrappedValue)
                .frame(width: 20, height: 100-16)
        }
        .frame(width: 20, height: 200)
        .mask {
            VStack {
                LinearGradient(colors: [.clear, .white],
                               startPoint: .top,
                               endPoint: .bottom)
                .padding(.vertical, -4)
                Color.white
                    .padding(.vertical, -4)
                LinearGradient(colors: [.white, .clear],
                               startPoint: .top,
                               endPoint: .bottom)
                .padding(.vertical, -4)
            }
        }
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
            List {
                Text("Resistance: \(resistor.resistance)")
                Text("Multiplier: \(resistor.multiplier)")
                Text("Tolerance: \(resistor.tolerance)%")
            }
            .safeAreaInset(edge: .top) {
                EditableResistorView(resistor: $resistor)
                    .frame(height: 200)
                    .offset(y: 20)
                    .background {
                    }
            }
        }
    }
}

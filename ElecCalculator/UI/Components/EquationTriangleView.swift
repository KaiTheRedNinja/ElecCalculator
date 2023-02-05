//
//  EquationTriangleView.swift
//  ElecCalculator
//
//  Created by Kai Quan Tay on 5/2/23.
//

import SwiftUI
import Updating

struct EquationTriangleView: View {
    @Updating var equation: Equation
    @Binding var selected: UnitTarget

    @Namespace var namespace

    init(equation: Equation,
         selected: Binding<UnitTarget>) {
        self._equation = <-equation
        self._selected = selected
    }

    var body: some View {
        VStack {
            viewForUnit(unit: equation.operation == .times ? equation.value : equation.var1,
                        target: equation.operation == .times ? .value : .var1)
                .background {
                    if selected == (equation.operation == .times ? .value : .var1) {
                        selectionColor
                    }
                }
            HStack {
                viewForUnit(unit: equation.operation == .times ? equation.var1 : equation.value,
                            target: equation.operation == .times ? .var1 : .value)
                    .background {
                        if selected == (equation.operation == .times ? .var1 : .value) {
                            selectionColor
                        }
                    }
                viewForUnit(unit: equation.var2, target: .var2)
                    .background {
                        if selected == .var2 {
                            selectionColor
                        }
                    }
            }
            .padding(.top, 10)
        }
        .overlay {
            Color.primary
                .frame(height: 1)
        }
    }

    var selectionColor: some View {
        Color.green
            .cornerRadius(10)
            .matchedGeometryEffect(id: "selectionThing", in: namespace)
    }

    func viewForUnit(unit: EquationUnit, target: UnitTarget) -> some View {
        Button {
            withAnimation {
                selected = target
            }
        } label: {
            VStack {
                Text(unit.equationSymbol)
                    .font(.title)
                Text(unit.unitPurpose)
                    .truncationMode(.tail)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
            }
            .foregroundColor(.primary)
            .padding(5)
            .background {
                ZStack {
                    if target != selected {
                        Color.gray
                    }
                }
                .cornerRadius(10)
                .opacity(0.5)
            }
        }
        .buttonStyle(.plain)
    }
}

struct EquationTriangleView_Previews: PreviewProvider {
    static var previews: some View {
        EquationTriangleViewWrapper()
    }

    struct EquationTriangleViewWrapper: View {
        @State var equation: Equation = .init(value: .p,
                                              var1: .q,
                                              var2: .t,
                                              operation: .div) // THIS EQUATION DOES NOT EXIST
        @State var selected: UnitTarget = .value

        var body: some View {
            EquationTriangleView(equation: equation, selected: $selected)
                .frame(width: 130, height: 170)
                .background {
//                    Color.blue
                }
        }
    }
}

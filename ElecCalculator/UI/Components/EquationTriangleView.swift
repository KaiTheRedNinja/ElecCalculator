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

    var body: some View {
        VStack {
            viewForUnit(unit: equation.value, target: .value)
            HStack {
                viewForUnit(unit: equation.var1, target: .var1)
                viewForUnit(unit: equation.var2, target: .var2)
            }
            .padding(.top, 10)
        }
        .overlay {
            Color.primary
                .frame(height: 1)
        }
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
                    if target == selected {
                        Color.green
                    } else {
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
        @State var equation: Equation = RelationFormula.wqv.equation
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

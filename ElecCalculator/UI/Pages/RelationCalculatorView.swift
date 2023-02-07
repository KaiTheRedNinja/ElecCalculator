//
//  RelationCalculatorView.swift
//  ElecCalculator
//
//  Created by Kai Quan Tay on 3/2/23.
//

import SwiftUI
import Equation

struct RelationCalculatorView: View {
    @State var formula: EquationGroup = .vir
    @State var firstValue: Double = 0
    @State var secondValue: Double = 0

    @State var unitTarget: SolveTarget = .top(0)

    @Namespace var namespace

    @State var numbers: [EquationUnit: Int] = [:]

    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    EquationTriangleView(equation: formula, selected: $unitTarget)
                        .frame(height: 170)
                    Spacer()
                }
            } header: {
                HStack {
                    Text("Formula")
                    Spacer()
                    Menu(formula.description) {
                        ForEach(EquationGroup.allEquations, id: \.description) { equation in
                            Button(equation.description) {
                                formula = equation
                            }
                        }
                    }
                    Button {
                        // TODO: show list of formulas
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }

            Section {
                ForEach(formula.flatUnits, id: \.1) { unit, role in
                    if unitTarget != role {
                        viewForUnit(unit: unit)
                    }
                }
            }

            Section {
                viewForUnit(unit: formula[unitTarget], computed: true)
            }
        }
    }

    func viewForUnit(unit: EquationUnit, computed: Bool = false) -> some View {
        HStack {
            Text(unit.unitPurpose)
            if computed {
                Spacer()
                Text(String(format: "%.2f", result()))
            } else {
                TextField(unit.unitName, value: .init(get: {
                    numbers[unit] ?? 0
                }, set: { newValue in
                    numbers[unit] = newValue
                }), formatter: NumberFormatter())
                .multilineTextAlignment(.trailing)
            }
            Text(unit.unitSymbol)
        }
        .matchedGeometryEffect(id: unit.id, in: namespace)
    }

    func result() -> Double {
        let values = numbers.map({ ($0, Double($1)) })
        return formula.solve(target: unitTarget,
                             values: .init(uniqueKeysWithValues: values))
    }
}

struct RelationCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        RelationCalculatorView()
    }
}

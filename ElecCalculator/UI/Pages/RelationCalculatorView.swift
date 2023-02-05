//
//  RelationCalculatorView.swift
//  ElecCalculator
//
//  Created by Kai Quan Tay on 3/2/23.
//

import SwiftUI

struct RelationCalculatorView: View {
    @State var formula: RelationFormula = .vir
    @State var firstValue: Double = 0
    @State var secondValue: Double = 0

    @State var unitTarget: UnitTarget = .value

    @Namespace
    var namespace

    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    EquationTriangleView(equation: formula.equation, selected: $unitTarget)
                    Spacer()
                    Picker("", selection: $formula) {
                        ForEach(RelationFormula.allCases, id: \.hashValue) { form in
                            Text(form.equation.briefDescription)
                                .tag(form)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 150)
                    .padding(.vertical, -40)
                }
                .offset(y: -15)
            } header: {
                HStack {
                    Text("Formula")
                    Spacer()
                    Button {
                        // TODO: show list of formulas
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }

            Section("Inputs") {
                HStack {
                    Text(unitForActiveTarget(target: .var1).unitPurpose)
                    Spacer()
                    TextField(unitForActiveTarget(target: .var1).unitName,
                              value: $firstValue,
                              formatter: NumberFormatter())
                    .multilineTextAlignment(.trailing)
                    Text(unitForActiveTarget(target: .var1).unitSymbol)
                }
                HStack {
                    Text(unitForActiveTarget(target: .var2).unitPurpose)
                    Spacer()
                    TextField(unitForActiveTarget(target: .var2).unitName,
                              value: $secondValue,
                              formatter: NumberFormatter())
                    .multilineTextAlignment(.trailing)
                    Text(unitForActiveTarget(target: .var2).unitSymbol)
                }
            }

            Section("Output") {
                HStack {
                    Text("\(unitForActiveTarget(target: .value).unitPurpose)")
                    Spacer()
                    Text(formula.equation.evaluate(for: unitTarget,
                                                   given: firstValue,
                                                   and: secondValue).twoDP)
                    Text(unitForActiveTarget(target: .value).unitSymbol)
                }
            }
        }
    }

    func unitForActiveTarget(target: UnitTarget) -> EquationUnit {
        return formula.equation[Equation.unitTarget(value: unitTarget, target: target)]
    }
}

struct RelationCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        RelationCalculatorView()
    }
}

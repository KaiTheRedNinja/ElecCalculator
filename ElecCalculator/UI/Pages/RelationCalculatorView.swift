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
            Section("Formula") {
                ZStack(alignment: .leading) {
                    Text("Formula:")
                    Picker("", selection: $formula) {
                        ForEach(RelationFormula.allCases, id: \.hashValue) { form in
                            Text(form.equation.semiBriefDescription)
                                .tag(form)
                        }
                    }
                }
                HStack {
                    formulaElement(target: Equation.unitTarget(value: unitTarget, target: .value))
                        .multilineTextAlignment(.center)
                    Spacer()
                    Text("=")
                    Spacer()
                    formulaElement(target: Equation.unitTarget(value: unitTarget, target: .var1))
                        .multilineTextAlignment(.center)
                    Spacer()
                    Text(unitTarget == .value ? formula.equation.operation.rawValue :
                            formula.equation.operation.other.rawValue)
                    Spacer()
                    formulaElement(target: Equation.unitTarget(value: unitTarget, target: .var2))
                        .multilineTextAlignment(.center)
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

    func formulaElement(target: UnitTarget) -> some View {
        Button {
            withAnimation {
                unitTarget = target
            }
        } label: {
            ZStack {
                switch target {
                case .value:
                    Text(formula.equation.value.unitPurpose)
                case .var1:
                    Text(formula.equation.var1.unitPurpose)
                case .var2:
                    Text(formula.equation.var2.unitPurpose)
                }
            }
            .foregroundColor(.primary)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background {
                if target == unitTarget {
                    Color.green.opacity(0.5).cornerRadius(8)
                } else {
                    Color.gray.opacity(0.5).cornerRadius(8)
                }
            }
        }
        .buttonStyle(.plain)
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

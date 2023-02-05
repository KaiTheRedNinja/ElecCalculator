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
                    formulaElement(target: unitTargetToActiveUserTarget(target: .value))
                        .multilineTextAlignment(.center)
                    Spacer()
                    Text("=")
                    Spacer()
                    formulaElement(target: unitTargetToActiveUserTarget(target: .var1))
                        .multilineTextAlignment(.center)
                    Spacer()
                    Text(unitTarget == .value ? formula.equation.operation.rawValue :
                            formula.equation.operation.other.rawValue)
                    Spacer()
                    formulaElement(target: unitTargetToActiveUserTarget(target: .var2))
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
                    Text(result().twoDP)
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

    func result() -> Double {
        evaluate(var1: firstValue,
                 var2: secondValue,
                 operation: unitTarget == .value ? formula.equation.operation :
                    formula.equation.operation.other)
    }

    func unitTargetToActiveUserTarget(target: UnitTarget) -> UnitTarget {
        switch unitTarget {
        case .value: return target
        case .var1:
            switch target {
            case .var1: return .value
            case .var2: return .var2
            case .value: return .var1
            }
        case .var2:
            switch target {
            case .var1: return .value
            case .var2: return .var1
            case .value: return .var2
            }
        }
    }

    func unitForActiveTarget(target: UnitTarget) -> EquationUnit {
        return unitForTarget(target: unitTargetToActiveUserTarget(target: target))
    }

    func unitForTarget(target: UnitTarget) -> EquationUnit {
        switch target {
        case .value: return formula.equation.value
        case .var1: return formula.equation.var1
        case .var2: return formula.equation.var2
        }
    }

    func evaluate(var1: Double,
                  var2: Double,
                  operation: Equation.Operation) -> Double {
        switch operation {
        case .times:
            return var1 * var2
        case .div:
            return (var2 == 0) ? 0 : var1 / var2
        }
    }
}

struct RelationCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        RelationCalculatorView()
    }
}

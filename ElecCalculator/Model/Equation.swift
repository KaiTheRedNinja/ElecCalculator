//
//  Equation.swift
//  ElecCalculator
//
//  Created by Kai Quan Tay on 5/2/23.
//

import Foundation

struct EquationUnit: Identifiable, Hashable, Equatable {
    var id: String { "\(unitSymbol) \(unitName) \(unitPurpose)" }

    var equationSymbol: String
    var unitSymbol: String
    var unitName: String
    var unitPurpose: String

    static let w: EquationUnit = .init(equationSymbol: "W",
                                       unitSymbol: "J",
                                       unitName: "Joules",
                                       unitPurpose: "Work Done")
    static let v: EquationUnit = .init(equationSymbol: "V",
                                       unitSymbol: "V",
                                       unitName: "Volts",
                                       unitPurpose: "Potential Difference")
    static let i: EquationUnit = .init(equationSymbol: "I",
                                       unitSymbol: "A",
                                       unitName: "Ampere",
                                       unitPurpose: "Current")
    static let q: EquationUnit = .init(equationSymbol: "Q",
                                       unitSymbol: "C",
                                       unitName: "Coulombs",
                                       unitPurpose: "Charge")
    static let p: EquationUnit = .init(equationSymbol: "P",
                                       unitSymbol: "W",
                                       unitName: "Watts",
                                       unitPurpose: "Power")
    static let t: EquationUnit = .init(equationSymbol: "T",
                                       unitSymbol: "s",
                                       unitName: "Seconds",
                                       unitPurpose: "Time")
    static let r: EquationUnit = .init(equationSymbol: "R",
                                       unitSymbol: "Ω",
                                       unitName: "Ohms",
                                       unitPurpose: "Resistence")
}

struct Equation: Identifiable, Hashable, Equatable {
    init(value: EquationUnit,
         var1: EquationUnit,
         var2: EquationUnit,
         operation: Operation = .times) {
        self.value = value
        self.var1 = var1
        self.var2 = var2
        self.operation = operation
    }

    typealias RawValue = String

    var value: EquationUnit
    var var1: EquationUnit
    var var2: EquationUnit
    var operation: Operation = .times

    var id: String { description }
    var rawValue: String { description }

    var briefDescription: String {
        "\(value.equationSymbol) = \(var1.equationSymbol) \(operation.rawValue) \(var2.equationSymbol)"
    }

    var semiBriefDescription: String {
        "\(value.unitPurpose) = \(var1.equationSymbol) \(operation.rawValue) \(var2.equationSymbol)"
    }

    var description: String {
        "\(value.unitPurpose) = \(var1.unitPurpose) \(operation.rawValue) \(var2.unitPurpose)"
    }

    enum Operation: String {
        case div = "/"
        case times = "*"

        var other: Operation {
            switch self {
            case .div: return .times
            case .times: return .div
            }
        }
    }
}

enum UnitTarget: CaseIterable {
    case value, var1, var2
}

enum RelationFormula: CaseIterable {
    case vir, qit, wpt, wqv, pvi //, pv2r, pri2, rpla, g1r

    var equation: Equation { RelationFormula.equations[self]! }

    static let equations: [RelationFormula: Equation] = [
        .vir: .init(value: .v, var1: .i, var2: .r),
        .qit: .init(value: .q, var1: .i, var2: .t),
        .wpt: .init(value: .w, var1: .p, var2: .t),
        .wqv: .init(value: .w, var1: .q, var2: .v),
        .pvi: .init(value: .p, var1: .v, var2: .i)
        //            .pv2r: .init(value: "P", var1: "V^2", var2: "R", operation: .div),
        //            .pri2: .init(value: "P", var1: "R", var2: "I^2"),
        //            .rpla: .init(value: "R", var1: "pL", var2: "A", operation: .div),
        //            .g1r: .init(value: "G", var1: "1", var2: "R", operation: .div)
    ]
}
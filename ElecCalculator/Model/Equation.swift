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
    static let v2: EquationUnit = .init(equationSymbol: "V^2",
                                        unitSymbol: "V",
                                        unitName: "Volts",
                                        unitPurpose: "Potential Difference")
}

struct Equation: Identifiable, Hashable, Equatable {
    static func == (lhs: Equation, rhs: Equation) -> Bool {
        lhs.description == rhs.description
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }

    init(value: EquationUnit,
         var1: EquationUnit,
         var2: EquationUnit,
         operation: Operation = .times,
         overrideEvaluation: ((UnitTarget, Double, Double) -> Double)? = nil) {
        self.value = value
        self.var1 = var1
        self.var2 = var2
        self.operation = operation
        self.overrideEvaluation = overrideEvaluation
    }

    typealias RawValue = String

    var value: EquationUnit
    var var1: EquationUnit
    var var2: EquationUnit
    var operation: Operation = .times
    var overrideEvaluation: ((UnitTarget, Double, Double) -> Double)?

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

    func evaluate(for target: UnitTarget, given first: Double, and second: Double) -> Double {
        if let overrideEvaluation {
            return overrideEvaluation(target, first, second)
        }

        let operation = target == .value ? self.operation : self.operation.other

        switch operation {
        case .times:
            return first * second
        case .div:
            return (second == 0) ? 0 : first / second
        }
    }

    subscript (target: UnitTarget) -> EquationUnit {
        switch target {
        case .value: return self.value
        case .var1: return self.var1
        case .var2: return self.var2
        }
    }

    /// | val | value | var1 | var2 |
    /// | ------ | ------- | ------ | ------ |
    /// | value | value | var1 | var2 |
    /// | var1 | var1 | value | var2 |
    /// | var2 | var2 | value | var 1 |
    ///
    /// - Parameters:
    ///   - value: The value that you're trying to solve for
    ///   - target: The value to transform
    /// - Returns: A transformed unit target
    static func unitTarget(value: UnitTarget, target: UnitTarget) -> UnitTarget {
        switch value {
        case .value: return target
        case .var1:
            switch target {
            case .value: return .var1
            case .var1: return .value
            case .var2: return .var2
            }
        case .var2:
            switch target {
            case .value: return .var2
            case .var1: return .value
            case .var2: return .var1
            }
        }
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
    case vir, qit, wpt, wqv, pvi, pv2r //, pv2r, pri2, rpla, g1r

    var equation: Equation { RelationFormula.equations[self]! }

    static let equations: [RelationFormula: Equation] = [
        .vir: .init(value: .v, var1: .i, var2: .r),
        .qit: .init(value: .q, var1: .i, var2: .t),
        .wpt: .init(value: .w, var1: .p, var2: .t),
        .wqv: .init(value: .w, var1: .q, var2: .v),
        .pvi: .init(value: .p, var1: .v, var2: .i),
        .pv2r: .init(value: .p, var1: .v2, var2: .r, operation: .div, overrideEvaluation: { target, var1, var2 in
            switch target {
            case .value:
                return (var1*var1)/var2
            case .var1:
                return sqrt(var1*var2)
            case .var2:
                return (var1*var1)/var2
            }
        })
        //            .pv2r: .init(value: "P", var1: "V^2", var2: "R", operation: .div),
        //            .pri2: .init(value: "P", var1: "R", var2: "I^2"),
        //            .rpla: .init(value: "R", var1: "pL", var2: "A", operation: .div),
        //            .g1r: .init(value: "G", var1: "1", var2: "R", operation: .div)
    ]
}

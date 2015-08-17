//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Javier San Juan Cervera on 29/7/15.
//  Copyright (c) 2015 Javier San Juan Cervera. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, (Double) -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case Variable(String, () -> Double?)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    if "\(operand)" == "\(M_PI)" {
                        return "π"
                    } else {
                        if operand - Double(Int(operand)) > 0 {
                            return "\(operand)"
                        } else {
                            return "\(Int(operand))"
                        }
                    }
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .Variable(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    var variableValues = [String: Double]()
    
    // Guaranteed to be a PropertyList
    var program: AnyObject {
        get {
            return opStack.map { $0.description }
        }
        set {
            if let opSymbols = newValue as? [String] {
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    } else {
                        println("ERROR: Could not add opSymbol to program")
                    }
                }
                opStack = newOpStack
            }
        }
    }
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") { $1 - $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.UnaryOperation("±") { -$0 })
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .Variable(_, let fun):
                return (fun(), remainingOps)
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        //println("\(opStack) = \(result) with \(remainder) left over");
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol, { self.variableValues[symbol] }))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clearStack() {
        opStack.removeAll(keepCapacity: false);
    }
    
    func hasEmptyStack() -> Bool {
        return opStack.count == 0
    }
    
    var description: String {
        var desc = ""
        var ops = opStack
        while !ops.isEmpty {
            let result = describe(ops)
            if let string = result.string {
                let oldDesc = desc
                //if count(desc) > 0 { desc += "," }
                desc = string
                if count(oldDesc) > 0 { desc += "," + oldDesc }
                ops = result.remainingOps
            }
        }
        return desc
    }
    
    private func describe(ops: [Op]) -> (string: String?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .UnaryOperation(let symbol, _):
                let operandDesc = describe(remainingOps)
                if let string = operandDesc.string {
                    return (symbol + "(" + string + ")", operandDesc.remainingOps)
                }
            case .BinaryOperation(let symbol, _):
                let operand1Desc = describe(remainingOps)
                if let string1 = operand1Desc.string {
                    let differenceInStackPost = count(remainingOps) - count(operand1Desc.remainingOps)
                    let operand2Desc = describe(operand1Desc.remainingOps)
                    if let string2 = operand2Desc.string {
                        let differenceInStackPre = count(operand1Desc.remainingOps) - count(operand2Desc.remainingOps)
                        var pre = string2
                        var post = string1
                        if differenceInStackPre > 1 { pre = "(" + pre + ")" }
                        if differenceInStackPost > 1 { post = "(" + post + ")" }
                        return (pre + symbol + post, operand2Desc.remainingOps)
                    }
                }
            default:
                return (op.description, remainingOps)
            }
        }
        return ("?", ops)
    }
}

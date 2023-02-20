//
//  TreePredict.swift
//  LotteryStatistics
//
//  Created by Tai Le on 19/02/2023.
//  Copyright © 2023 levantAJ. All rights reserved.
//

import Foundation
import UIKit

class Node<Value> {
    var value: Value
    var count: Int = 1
    private(set) var children: [Node]

    init(_ value: Value) {
        self.value = value
        children = []
    }

    init(_ value: Value, child: Node) {
        self.value = value
        self.children = [child]
    }

    func add(child: Node) {
        children.append(child)
    }

    func visualize() {
        print(value)
        print("|")
        for child in children {
            print(" - ")
            child.visualize()
        }
    }

    func treeLines(
        _ nodeIndent: String = "",
        _ childIndent:String = ""
    ) -> [String] {
        return [nodeIndent + "\(value) - \(count)"]
            + children.enumerated().map { ($0 < children.count-1, $1) }
            .flatMap { $0 ? $1.treeLines("┣╸","┃ ") : $1.treeLines("┗╸","  ") }
            .map { childIndent + "\($0)" }
    }

    func printTree() {
        print(treeLines().joined(separator:"\n"))
    }

    func sortNumbers() {
        if children.isEmpty {
            return
        }
        children.sort(by: { $0.count > $1.count })
        for child in children {
            child.sortNumbers()
        }
    }

    func sumFirst() -> Int {
        if let first = children.first {
            return count + first.sumFirst()
        }
        return count
    }
}

final class TreePredictor {

    var nodes: [Int: Node<Int>] = [:]

    func build(draws: [Draw]) {
        for draw in draws {
            guard let firstNumber = draw.numbers.first else { continue }
            if let currentNode = nodes[firstNumber] {
                build(node: currentNode, numbers: Array(draw.numbers.dropFirst()))
                currentNode.count += 1
            } else {
                if let newNode = build(numbers: draw.numbers) {
                    nodes[newNode.value] = newNode
                }
            }
        }
    }

    func build(node: Node<Int>, numbers: [Int]) {
        guard let firstNumber = numbers.first else { return }

        if node.children.isEmpty {
            if let newNode = build(numbers: numbers) {
                node.add(child: newNode)
            }
        } else {
            var isUpdated = false
            for child in node.children {
                if child.value == firstNumber {
                    child.count += 1
                    build(node: child, numbers: Array(numbers.dropFirst()))
                    isUpdated = true
                }
            }
            if !isUpdated {
                if let newNode = build(numbers: numbers) {
                    node.add(child: newNode)
                }
            }
        }
    }

    ///  n1
    ///  |
    ///  n2
    ///  |
    ///  n...
    ///  |
    ///  nn
    func build(numbers: [Int]) -> Node<Int>? {
        guard let first = numbers.first else {
            return nil
        }

        if let child = build(numbers: Array(numbers.dropFirst())) {
            return Node<Int>(first, child: child)
        } else {
            return Node<Int>(first)
        }
    }

    func visualize() {
        for node in sort() {
            node.printTree()
            print("===============")
        }
    }

    func sort() -> [Node<Int>] {
        var nodes = Array(nodes.values).sorted(by: { $0.count > $1.count })
        for node in nodes {
            node.sortNumbers()
        }
        nodes = nodes.sorted(by: { $0.sumFirst() > $1.sumFirst() })
        return nodes
    }
}

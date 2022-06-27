//
//  Position.swift
//  ChassGame
//
//  Created by fran on 2022/06/23.
//

import Foundation

/**
 board 내 위치를 표현함.
 */
struct Position: Hashable {
    var x: Int = 0
    var y: Int = 0

    init?(string: String) {
        // string : ex) 'E5'

        let chars = Array(string)

        guard chars.count == 2,
              let file = File(name: String(chars[0])),
              let rank = Rank(name: String(chars[1])) else {
            return nil
        }

        guard isValid(x: file.index, y: rank.index) else { return nil }
        self.x = file.index
        self.y = rank.index
    }

    init?(x: Int, y: Int) {
        guard isValid(x: x, y: y) else { return nil }
        self.x = x
        self.y = y
    }

    func isValid(x: Int, y: Int) -> Bool {
        let minX: Int = 0
        let minY: Int = 0
        let maxX: Int = 7
        let maxY: Int = 7

        if x > maxX || x < minX || y > maxY || y < minY {
            return false
        }
        return true
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }

    static func ==(lhs: Position, rhs: Position) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}

enum File: Int, CaseIterable {
    case A = 0
    case B = 1
    case C = 2
    case D = 3
    case E = 4
    case F = 5
    case G = 6
    case H = 7

    var index: Int {
        return self.rawValue
    }

    init?(name: String) {
        switch name {
        case "A":
            self = .A
        case "B":
            self = .B
        case "C":
            self = .C
        case "D":
            self = .D
        case "E":
            self = .E
        case "F":
            self = .F
        case "G":
            self = .G
        case "H":
            self = .H
        default:
            return nil
        }
    }

    init?(index: Int) {
        guard let file = File(rawValue: index) else { return nil }
        self = file
    }

    static func name(index: Int) -> String {
        return String(UnicodeScalar(UInt8(index+97)))
    }
}

enum Rank: Int {
    case R1 = 0
    case R2 = 1
    case R3 = 2
    case R4 = 3
    case R5 = 4
    case R6 = 5
    case R7 = 6
    case R8 = 7

    var index: Int {
        return self.rawValue
    }

    init?(index: Int) {
        guard let rank = Rank(rawValue: index) else { return nil }
        self = rank
    }

    init?(name: String) {
        guard let number = Int(name), let rank = Rank(rawValue: number - 1) else { return nil }
        self = rank
    }
}

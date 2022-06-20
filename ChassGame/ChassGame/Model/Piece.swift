//
//  Piece.swift
//  ChassGame
//
//  Created by fran on 2022/06/20.
//

import Foundation

class Piece: ExpressibleByStringLiteral, CustomStringConvertible, Hashable {
    var type: PieceType
    var color: PieceColor
    var description: String {
        return "type: \(type), color: \(color), symbol: \(type.symbol(color: color))"
    }

    init(type: PieceType, color: PieceColor) {
        self.type = type
        self.color = color
    }

    required init(stringLiteral: String) {
        self.type = .none
        let unicodeScalars = stringLiteral.unicodeScalars
        let unicode = unicodeScalars[unicodeScalars.startIndex].value

        if unicode <= 0x2659 {
            // white
            self.color = .white
            self.type = PieceType(rawValue: Int(unicode)) ?? .none
        } else {
            // black
            self.color = .black
            self.type = PieceType(rawValue: Int(unicode - 6)) ?? .none
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(color)
    }

    static func ==(lhs: Piece, rhs: Piece) -> Bool {
        lhs.type == rhs.type && lhs.color == rhs.color
    }
}

enum PieceType: Int {
    case pawn = 0x2659
    case knight = 0x2658
    case bishop = 0x2657
    case luke = 0x2656
    case queen = 0x2655
    case none = 0

    var score: Int {
        switch self {
        case .pawn:
            return 1
        case .bishop, .knight:
            return 3
        case .luke:
            return 5
        case .queen:
            return 9
        default:
            return 0
        }
    }

    var whiteSymbol: String {
        if let unicodeScalar = UnicodeScalar(self.rawValue) {
            return String(unicodeScalar)
        }
        return ""
    }

    var blackSymbol: String {
        if let unicodeScalar = UnicodeScalar(self.rawValue + 6) {
            return String(unicodeScalar)
        }
        return ""
    }

    func symbol(color: PieceColor) -> String {
        if color == .black {
            return self.blackSymbol
        } else {
            return self.whiteSymbol
        }
    }
}

enum PieceColor {
    case white
    case black
}

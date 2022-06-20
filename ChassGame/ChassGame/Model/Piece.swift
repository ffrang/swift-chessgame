//
//  Piece.swift
//  ChassGame
//
//  Created by fran on 2022/06/20.
//

import Foundation

class Piece: ExpressibleByStringLiteral {
    var type: PieceType
    var color: PieceColor

    init(type: PieceType, color: PieceColor) {
        self.type = type
        self.color = color
    }

    required init(stringLiteral: String) {
        self.type = .none

        if stringLiteral <= "\u{2659}" {
            // white
            self.color = .white
            self.type = PieceType(rawValue: stringLiteral) ?? .none
        } else {
            // black
            self.color = .black
            if let value = Int(stringLiteral) {
                self.type = PieceType(rawValue: String(value - 6)) ?? .none
            }
        }
    }
}

enum PieceType: String {
    case pawn = "\u{2659}"
    case bishop = "\u{2658}"
    case knight = "\u{2657}"
    case luke = "\u{2656}"
    case queen = "\u{2655}"
    case none = ""

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
        return self.rawValue
    }

    var blackSymbol: String {
        if let value = Int(self.rawValue) {
            return String(value + 6)
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

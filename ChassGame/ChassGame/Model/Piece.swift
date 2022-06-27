//
//  Piece.swift
//  ChassGame
//
//  Created by fran on 2022/06/20.
//

import Foundation

class Piece: CustomStringConvertible, Hashable {
    var type: PieceType
    var color: PieceColor
    var position: Position = Position(x: 0, y: 0)!

    var moveRuleSet: [StepRule] {
        return []
    }

    var symbol: String {
        return type.symbol(color: color)
    }
    
    var description: String {
        return "type: \(type), color: \(color), symbol: \(type.symbol(color: color)), x: \(position.x), y: \(position.y)"
    }

    required init(type: PieceType, color: PieceColor) {
        self.type = type
        self.color = color
    }

    static func piece(for symbol: String) -> Piece? {
        let unicodeScalars = symbol.unicodeScalars
        let unicode = unicodeScalars[unicodeScalars.startIndex].value

        var color: PieceColor = .white
        var type: PieceType?

        if unicode <= 0x2659 {
            // white
            color = .white
            type = PieceType(rawValue: Int(unicode))
        } else {
            // black
            color = .black
            type = PieceType(rawValue: Int(unicode - 6))
        }

        guard let type = type else {
            return nil
        }

        return classType(type: type)?.init(type: type, color: color)
    }

    static func classType(type: PieceType) -> Piece.Type? {
        switch type {
        case .bishop:
            return Bishop.self
        case .queen:
            return Queen.self
        case .knight:
            return Knight.self
        case .pawn:
            return Pawn.self
        case .rook:
            return Rook.self
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(color)
    }

    static func ==(lhs: Piece, rhs: Piece) -> Bool {
        lhs.type == rhs.type && lhs.color == rhs.color
    }

    func display() {
        print(self.type.symbol(color: color), terminator: "")
    }
}

// MARK: - Piece move
extension Piece {
    // 현재 piece에서 가능한 모든 경로를 계산. (다른 piece 정보는 갖고 있지 않음.)
    func allRoutes() -> [Route] {
        var movableRoutes: [Route] = []

        for rule in moveRuleSet {
            if rule.repetable {
                // rook, bishop, queen
                var route = Route(positions: [], canStopOnlyLastPostion: false)
                var movePositions: [Position]? = self.route(position: self.position, to: rule.steps)
                while let newPositions = movePositions {
                    route.positions.append(contentsOf: newPositions)
                    movePositions = self.route(position: newPositions.last!, to: rule.steps)
                }

                if route.positions.count  > 0 {
                    movableRoutes.append(route)
                }
            } else {
                // pawn, knight
                if let movePositions = self.route(position: self.position, to: rule.steps) {
                    movableRoutes.append(Route(positions: movePositions, canStopOnlyLastPostion: true))
                }
            }
        }
        return movableRoutes
    }

    func route(position: Position, to steps: [Step]) -> [Position]? {
        var movePositions: [Position] = []
        var curPosition = position
        for step in steps {
            if let position = Position(x: curPosition.x + step.x, y: curPosition.y + step.y) {
                movePositions.append(position)
                curPosition = position
            }
        }

        return (movePositions.count > 0) ? movePositions : nil
    }
}

enum PieceType: Int {
    case pawn = 0x2659
    case knight = 0x2658
    case bishop = 0x2657
    case rook = 0x2656
    case queen = 0x2655

    var score: Int {
        switch self {
        case .pawn:
            return 1
        case .bishop, .knight:
            return 3
        case .rook:
            return 5
        case .queen:
            return 9
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

enum PieceColor: String {
    case white
    case black
}

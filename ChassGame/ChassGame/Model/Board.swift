//
//  Board.swift
//  ChassGame
//
//  Created by fran on 2022/06/20.
//

import Foundation
/**
 Board는 8x8 (가로 rank x 세로 file) 크기 체스판에 체스말(Piece) 존재 여부를 관리한다.

 Board는 현재 있는 말을 확인해서 흑과 백 점수를 출력한다.
 - 색상별로 Pawn 1점, Bishop와 Knight 3점, Rook 5점, 퀸은 9점으로 계산한다.

 Board는 모든 말의 위치를 알 수 있고, display() 함수는 1-rank부터 8-rank까지 rank 문자열 배열로 보드 위에 체스말을 리턴한다
 - 흑색 Pawn는 ♟ U+265F, Knight는 ♞ U+265E, Biship은 ♝ U+265D, Rook는 ♜ U+265C, Queen은 ♛ U+265B를 빈 곳은 "."을 표시한다.
 - 백색 Pawn는 ♙ U+2659, Knight는 ♘ U+2658, Biship은 ♗ U+2657, Rook는 ♖ U+2656, Queen은 ♕ U+2655를 빈 곳은 "."을 표시한다.
 - 예를 들어 초기화 상태에 Rook, Bishop, Queen만 있는 경우 1-rank는 "♜♞♝.♛♝♞♜" 가 된다.

 특정 위치에 특정 말을 생성한다.
 -  초기화할 때 1,2-rank는 흑백 체스말이, 7,8-rank는 백색 체스말이 위치한다.
 -  체스말 초기 위치가 아니면 생성하지 않는다.
 - 이미 해당 위치에 다른 말이 있으면 생성하지 않는다.
 - 체스말 종류별로 최대 개수보다 많이 생성할 수는 없다.
 - Pawn는 색상별로 8개. Bishop, Rook는 색상별로 2개, Queen는 색상별로 1개만 가능하다.

 특정 말을 옮기는 메소드는 Board에서 제공한다.
 - 같은 색상의 말이 to 위치에 다른 말이 이미 있으면 옮길 수 없다.
 - 말을 옮길 수 있으면 true, 옮길 수 없으면 false를 리턴한다.
 - 만약, 다른 색상의 말이 to 위치에 있는 경우는 기존에 있던 말을 제거하고 이동한다.

 체스말은 위치값은 가로 file은 A부터 H까지, 세로 rank는 1부터 8까지 입력이 가능하다.

 체스말은 색상값을 흑Black 또는 백White 중에 하나를 가진다.
 - 체스말 색상은 변경할 수 없다.

 체스말은 현재 위치를 기준으로 이동할 수 있는 모든 위치를 제공한다.
 - 다른 말이 있는지 여부는 판단하지 않는다.
 */

class Board {
    var positions: [[Piece?]] = []

    init() {
        let positionMap = [
            ["♜", "♞", "♝", ".", "♛", "♝", "♞", "♜"],
            ["♟", "♟", "♟", "♟", "♟", "♟", "♟", "♟"],
            [".", ".", ".", ".", ".", ".", ".", "."],
            [".", ".", ".", ".", ".", ".", ".", "."],
            [".", ".", ".", ".", ".", ".", ".", "."],
            [".", ".", ".", ".", ".", ".", ".", "."],
            ["♙", "♙", "♙", "♙", "♙", "♙", "♙", "♙"],
            ["♖", "♘", "♗", ".", "♕", "♗", "♘", "♖"]
        ]
        makeBoard(with: positionMap)
    }

    func makeBoard(with positionMap: [[String]]) {
        positions = [[Piece?]](repeating: Array(repeating: nil, count: 8 ), count: 8)
        for (y, symbolList) in positionMap.enumerated() {
            for (x, symbol) in symbolList.enumerated() {
                guard let piece = Piece.piece(for: symbol) else {
                    positions[y][x] = nil
                    continue
                }

                piece.position.x = x
                piece.position.y = y
                positions[y][x] = piece
            }
        }

        print("체스 보드를 초기화했습니다.")
        display()
    }

    func display() {
        print("  A B C D E F G H")
        for (rankIndex, rank) in positions.enumerated() {
            print(rankIndex+1, terminator: " ")
            for piece in rank {
                if let piece = piece {
                    piece.display()
                } else {
                    print(".", terminator: "")
                }
                print(" ", terminator: "")
            }
            print("")
        }
    }

    func score(for color: PieceColor) -> Int {
        var score = 0
        for rank in positions {
            for case let piece? in rank {
                if piece.color == color {
                    score += piece.type.score
                }
            }
        }
        return score
    }

    func printScore() {
        let blackScore = score(for: .black)
        let whiteScore = score(for: .white)

        print("==score== - \n", "black : \(blackScore) \n", "white: \(whiteScore)")
    }
}

// MARK: - move
extension Board {

    @discardableResult
    func move(_ inputStr: String) -> Bool {
        // inputStr : ex) 'B2->B3'

        print("=INPUT: ", inputStr)

        let positions: [String] = inputStr.components(separatedBy: "->").compactMap { string in
            let trimStr = string.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimStr.isEmpty ? nil : trimStr
        }

        guard positions.count == 2,
              positions[0] != positions[1],
              let from = Position(string: positions[0]),
              let to = Position(string: positions[1]) else {
            print("❗️INVALID INPUT")
            return false
        }

        return move(from: from, to: to)
    }

    @discardableResult
    func move(from: Position, to: Position) -> Bool {
        /**
         같은 색상의 말이 to 위치에 다른 말이 이미 있으면 옮길 수 없다.
         말을 옮길 수 있으면 true, 옮길 수 없으면 false를 리턴한다.
         만약, 다른 색상의 말이 to 위치에 있는 경우는 기존에 있던 말을 제거하고 이동한다.
         */

        guard let currentPiece = piece(at: from) else {
            print("❗️NO PIECE AT:", from)
            return false
        }

        print("=CUR: ", currentPiece)

        guard canMove(from: from, to: to) else { return false }

        print("🚙 MOVE!! \(from)", "->", to)

        // 다른 컬러 piece 가 가려는 위치에 있다면, 제거
        if let toPiece = piece(at: to) {
            print("👍 REMOVED: ", toPiece)
        }

        positions[to.y][to.x] = currentPiece
        positions[from.y][from.x] = nil

        currentPiece.position.x = to.x
        currentPiece.position.y = to.y

        display()
        printScore()

        return true
    }

    func canMove(from: Position, to: Position) -> Bool {

        guard let fromPiece = piece(at: from) else {
            // from 자리에 piece 가 없는 경우,
            print("❗️NO PIECE AT:", from)
            return false
        }

        if let toPiece = piece(at: to), toPiece.color == fromPiece.color {
            // to 자리에 piece가 동일한 컬러의 피스인 경우.
            print("❗️SAME COLOR TO:", to)
            return false
        }

        // route 검증
        let movablePositions = movablePositions(of: fromPiece)
        if !movablePositions.contains(to) {
            print("❗️CANT MOVE TO:", to)
            return false
        }

        return true
    }

    func movablePositions(of piece: Piece?) -> [Position] {
        guard let piece = piece else {
            return []
        }

        let allRoutes = piece.allRoutes()
        print("= allRoutes of piece: \n", allRoutes)

        var movablePositions: [Position] = []
        for route in allRoutes {
            for toPosition in route.positions {
                let isLastPosition = (route.positions.last == toPosition)
                let needCheckColor = (!route.canStopOnlyLastPostion ||  isLastPosition)

                // 경로 유효성 체크 - 경로에 같은 색 piece가 있는 경우 이동불가
                // 예외) canStopOnlyLastPostion == true 인 경우, 중간 step에서 색구분없이 piece가 있으면 이동 불가
                guard isValidMove(piece: piece, to: toPosition, checkColor: needCheckColor) else { break }

                if route.canStopOnlyLastPostion {
                    if isLastPosition {
                        movablePositions.append(toPosition)
                    }
                } else {
                    movablePositions.append(toPosition)
                }
            }
        }

        print("= can move positions: ", movablePositions)
        return movablePositions
    }

    func isValidMove(piece: Piece, to: Position, checkColor: Bool) -> Bool {
        guard let toPiece = self.piece(at: to) else {
            return true
        }

        if checkColor && piece.color != toPiece.color {
            return true
        } else {
            return false
        }
    }

    func piece(at: Position) -> Piece? {
        return positions[at.y][at.x]
    }
}

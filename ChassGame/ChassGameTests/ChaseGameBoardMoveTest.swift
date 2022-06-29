//
//  ChaseGameBoardMoveTest.swift
//  ChassGameTests
//
//  Created by fran on 2022/06/23.
//

import XCTest
@testable import ChassGame

class ChaseGameBoardMoveTest: XCTestCase {
    private var board: Board!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        board = Board()

//        let mockPositions = [
//            ["♜", "♞", "♝", ".", "♛", "♝", "♞", "♜"],
//            ["♟", "♟", "♟", "♟", "♟", "♟", "♟", "♟"],
//            [".", ".", ".", ".", ".", ".", ".", "."],
//            [".", ".", ".", ".", ".", ".", ".", "."],
//            [".", ".", ".", ".", ".", ".", ".", "."],
//            [".", ".", ".", ".", ".", ".", ".", "."],
//            ["♙", "♙", "♙", "♙", "♙", "♙", "♙", "♙"],
//            ["♖", "♘", "♗", ".", "♕", "♗", "♘", "♖"]
//        ]
//        makeBoard(with: mockPositions)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        board = nil
    }

    func testInitialPositionMovable() {
        for rank in board.positions {
            for case let piece? in rank {
                print("= PIECE: ", piece)
                print("= movable positions: \n", board.movablePositions(of: piece))
                let movablePositions = board.movablePositions(of: piece)
                switch piece.type {
                case .queen, .pawn:
                    XCTAssertEqual(movablePositions.count, 1, "movable logic 이상")
                default:
                    XCTAssertEqual(movablePositions.count, 0, "movable logic 이상")
                }
            }
        }
    }
}

// MARK: - bishop
extension ChaseGameBoardMoveTest {
    func loadMockBoardForBishop() {
        let mockPositions = [
            ["♜", ".", ".", ".", ".", "♝", "♞", "♜"],
            [".", "♟", ".", "♛", ".", ".", ".", "."],
            [".", ".", "♝", ".", ".", ".", ".", "."],
            [".", ".", ".", ".", ".", ".", ".", "."],
            ["♙", ".", ".", ".", "♖", ".", ".", "."],
            [".", ".", ".", ".", ".", ".", ".", "."],
            [".", ".", ".", ".", ".", ".", ".", "."],
            [".", ".", ".", ".", "♕", "♗", "♘", "♖"]
        ]
        board.makeBoard(with: mockPositions)
    }

    func testMoveBishop() {
        // false - 상하좌우
        loadMockBoardForBishop()
        XCTAssertFalse(board.move("C3->C1"), "잘못된 이동")
        XCTAssertFalse(board.move("C3->C4"), "잘못된 이동")
        XCTAssertFalse(board.move("C3->C2"), "잘못된 이동")
        XCTAssertFalse(board.move("C3->C7"), "잘못된 이동")

        // 대각선
        loadMockBoardForBishop()
        XCTAssertTrue(board.move("C3->B4"), "잘못된 이동")
        XCTAssertTrue(board.move("B4->A5"), "잘못된 이동")

        // remove
        loadMockBoardForBishop()
        XCTAssertFalse(board.move("C3->D2"), "잘못된 이동")
        XCTAssertTrue(board.move("C3->E5"), "잘못된 이동")
    }
}

// MARK: - knight
extension ChaseGameBoardMoveTest {
    func loadMockBoardForKnight() {
        let mockPositions = [
            ["♜", ".", ".", ".", ".", "♝", "♞", "♜"],
            [".", ".", ".", ".", ".", ".", ".", "."],
            [".", ".", "♞", "♛", ".", ".", ".", "."],
            ["♙", ".", ".", ".", ".", ".", ".", "."],
            [".", "♗", ".", ".", ".", ".", ".", "."],
            [".", "♖", ".", ".", ".", ".", ".", "."],
            [".", ".", "♘", ".", ".", ".", ".", "."],
            [".", ".", ".", ".", "♕", "♗", "♘", "♖"]
        ]
        board.makeBoard(with: mockPositions)
    }

    func testMoveKnight() {
        loadMockBoardForKnight()

        // false
        XCTAssertFalse(board.move("C3->A2"), "잘못된 이동")
        XCTAssertFalse(board.move("C3->A3"), "잘못된 이동")
        XCTAssertFalse(board.move("C3->A4"), "잘못된 이동")
        XCTAssertFalse(board.move("C3->C4"), "잘못된 이동")
        XCTAssertFalse(board.move("C3->B1"), "잘못된 이동")
        XCTAssertFalse(board.move("C3->B2"), "잘못된 이동")
        XCTAssertFalse(board.move("C3->B3"), "잘못된 이동")
        XCTAssertFalse(board.move("C3->B4"), "잘못된 이동")
        XCTAssertFalse(board.move("C3->D1"), "잘못된 이동")
        XCTAssertFalse(board.move("C3->D2"), "잘못된 이동")
        XCTAssertFalse(board.move("C3->E1"), "잘못된 이동")

        // true
        XCTAssertTrue(board.move("C3->B5"), "잘못된 이동")
        XCTAssertFalse(board.move("B5->C7"), "잘못된 이동")
    }
}

// MARK: - pawn
extension ChaseGameBoardMoveTest {
    func testMovePawn() {
        let mockPositions = [
            [".", ".", ".", ".", ".", ".", ".", "."],
            [".", ".", "♟", ".", ".", ".", ".", "."],
            ["♟", ".", ".", "♟", ".", ".", "♟", "."],
            [".", ".", ".", ".", "♟", ".", ".", "."],
            [".", "♙", ".", ".", "♙", ".", ".", "."],
            [".", ".", ".", ".", ".", ".", ".", "."],
            [".", ".", ".", ".", ".", ".", ".", "♟"],
            [".", ".", ".", ".", "♕", "♗", "♘", "♖"]
        ]
        board.makeBoard(with: mockPositions)

        // black 상하
        XCTAssertFalse(board.move("A3->A1"), "잘못된 이동")
        XCTAssertFalse(board.move("A3->A2"), "잘못된 이동")
        XCTAssertFalse(board.move("A3->A3"), "잘못된 이동")
        XCTAssertTrue(board.move("A3->A4"), "잘못된 이동")
        XCTAssertFalse(board.move("A3->A5"), "잘못된 이동")
        XCTAssertFalse(board.move("A3->A6"), "잘못된 이동")
        XCTAssertFalse(board.move("A3->A7"), "잘못된 이동")
        XCTAssertFalse(board.move("A3->A8"), "잘못된 이동")
        XCTAssertFalse(board.move("A3->A9"), "잘못된 이동")

        // false - 좌/우/대각선
        XCTAssertFalse(board.move("B5->A5"), "잘못된 이동")
        XCTAssertFalse(board.move("B5->C5"), "잘못된 이동")
        XCTAssertFalse(board.move("B5->H5"), "잘못된 이동")
        XCTAssertFalse(board.move("B5->C4"), "잘못된 이동")

        // white 상하
        XCTAssertFalse(board.move("B5->B1"), "잘못된 이동")
        XCTAssertFalse(board.move("B5->B2"), "잘못된 이동")
        XCTAssertFalse(board.move("B5->B3"), "잘못된 이동")
        XCTAssertTrue(board.move("B5->B4"), "잘못된 이동")
        XCTAssertFalse(board.move("B5->B5"), "잘못된 이동")
        XCTAssertFalse(board.move("B5->B6"), "잘못된 이동")
        XCTAssertFalse(board.move("B5->B7"), "잘못된 이동")
        XCTAssertFalse(board.move("B5->B8"), "잘못된 이동")

        // remove
        XCTAssertTrue(board.move("E5->E4"), "잘못된 이동")
        XCTAssertTrue(board.move("H7->H8"), "잘못된 이동")
    }

    func testMovePawnRepeat() {
        let mockPositions = [
            ["♜", "♞", "♝", ".", "♛", "♝", "♞", "♜"],
            ["♟", "♟", "♟", "♟", "♟", "♟", "♟", "♟"],
            [".", ".", ".", ".", ".", ".", ".", "."],
            [".", ".", ".", ".", ".", ".", ".", "."],
            [".", ".", ".", ".", ".", ".", ".", "."],
            [".", ".", ".", ".", ".", ".", ".", "."],
            ["♙", "♙", "♙", "♙", "♙", "♙", "♙", "♙"],
            ["♖", "♘", "♗", ".", "♕", "♗", "♘", "♖"]
        ]
        board.makeBoard(with: mockPositions)

        // 전체 pawn 전진 1줄
        board.move("A2->A3")
        board.move("A7->A6")

        board.move("B2->B3")
        board.move("B7->B6")

        board.move("C2->C3")
        board.move("C7->C6")

        board.move("D2->D3")
        board.move("D7->D6")

        board.move("E2->E3")
        board.move("E7->E6")

        board.move("F2->F3")
        board.move("F7->F6")

        board.move("G2->G3")
        board.move("G7->G6")

        board.move("H2->H3")
        board.move("H7->H6")

        // 전체 pawn 전진 1줄
        board.move("A3->A4")
        board.move("A6->A5")

        board.move("B3->B4")
        board.move("B6->B5")

        board.move("C3->C4")
        board.move("C6->C5")

        board.move("D3->D4")
        board.move("D6->D5")

        board.move("E3->E4")
        board.move("E6->E5")

        board.move("F3->F4")
        board.move("F6->F5")

        board.move("G3->G4")
        board.move("G6->G5")

        board.move("H3->H4")
        board.move("H6->H5")

        // 전체 pawn 전진 1줄
        board.move("A4->A5")
        board.move("B5->B4")
        board.move("C4->C5")
        board.move("D5->D4")
        board.move("E4->E5")
        board.move("F5->F4")
        board.move("G4->G5")
        board.move("H5->H4")
    }
}

// MARK: - rook
extension ChaseGameBoardMoveTest {
    func testMoveRook() {
        let mockPositions = [
            ["♜", ".", ".", ".", "♛", "♝", "♞", "♜"],
            [".", ".", ".", ".", ".", ".", ".", "."],
            [".", ".", ".", ".", ".", ".", ".", "."],
            [".", ".", ".", ".", ".", ".", ".", "."],
            [".", ".", ".", ".", "♖", ".", ".", "."],
            [".", ".", ".", ".", ".", ".", ".", "."],
            [".", ".", ".", ".", ".", ".", ".", "."],
            [".", ".", ".", ".", "♕", "♗", "♘", "♖"]
        ]
        board.makeBoard(with: mockPositions)

        XCTAssertFalse(board.move("A1->E1"), "잘못된 이동")
        XCTAssertFalse(board.move("A1->D3"), "잘못된 이동")
        XCTAssertTrue(board.move("A1->A7"), "잘못된 이동")
        XCTAssertTrue(board.move("E5->E1"), "잘못된 이동")
    }
}

// MARK: - queen
extension ChaseGameBoardMoveTest {
    func testMoveQueen() {
        let mockPositions = [
            ["♜", ".", ".", ".", "♛", "♝", "♞", "♜"],
            [".", ".", ".", ".", ".", ".", ".", "."],
            [".", ".", ".", ".", ".", ".", ".", "."],
            [".", ".", ".", ".", ".", ".", ".", "♖"],
            [".", ".", ".", ".", "♖", ".", ".", "."],
            [".", ".", ".", ".", ".", ".", ".", "."],
            [".", ".", ".", ".", ".", ".", "♘", "."],
            [".", ".", ".", ".", "♕", "♗", ".", "."]
        ]
        board.makeBoard(with: mockPositions)

        // false
        XCTAssertFalse(board.move("E1->F1"), "잘못된 이동")
        XCTAssertFalse(board.move("E1->F1"), "잘못된 이동")
        XCTAssertFalse(board.move("E1->A1"), "잘못된 이동")
        XCTAssertFalse(board.move("E1->C4"), "잘못된 이동")

        // true
        XCTAssertTrue(board.move("E1->E5"), "잘못된 이동")
        XCTAssertTrue(board.move("E5->G7"), "잘못된 이동")
    }
}

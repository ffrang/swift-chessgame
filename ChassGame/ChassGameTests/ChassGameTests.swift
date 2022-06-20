//
//  ChassGameTests.swift
//  ChassGameTests
//
//  Created by fran on 2022/06/20.
//

import XCTest
@testable import ChassGame

class ChassGameTests: XCTestCase {
    private var board: Board!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        board = Board()

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        board = nil
    }

    /* 특정 위치에 특정 말을 생성한다.
     1. 초기화할 때 1,2-rank는 흑백 체스말이, 7,8-rank는 백색 체스말이 위치한다.
     2. 체스말 초기 위치가 아니면 생성하지 않는다.
     - 이미 해당 위치에 다른 말이 있으면 생성하지 않는다.
     3. 체스말 종류별로 최대 개수보다 많이 생성할 수는 없다.
     - Pawn는 색상별로 8개. Bishop, Luke는 색상별로 2개, Queen는 색상별로 1개만 가능하다.*/

    // 1. 초기화할 때 1,2-rank는 흑백 체스말이, 7,8-rank는 백색 체스말이 위치한다.
    func testBoardInitColor() {
        for (index, rank) in board.positions.enumerated() {
            print(rank)
            for piece in rank {
                guard let piece = piece else { continue }
                let rowNum = index + 1
                if rowNum == 1 || rowNum == 2 {
                    XCTAssertEqual(piece.color, .black, "색 배열 잘못됨")

                } else if rowNum == 7 || rowNum == 8 {
                    XCTAssertEqual(piece.color, .white, "색 배열 잘못됨")
                }
            }
        }
    }

    // 2. 체스말 초기 위치가 아니면 생성하지 않는다.
    func testBoardInitPiecePosition() {
        /**
         - 1열 : luke, knight, bishop, . , queen, bishop, knight, luke
         - 2열 : pawn, pawn, pawn, pawn, pawn, pawn, pawn, pawn
         - 7열 : pawn, pawn, pawn, pawn, pawn, pawn, pawn, pawn
         - 8열 : luke, knight, bishop, . , queen, bishop, knight, luke
         */

        for (index, rank) in board.positions.enumerated() {
            let rowNum = index + 1
            print(rank)
            if rowNum == 1 || rowNum == 8 {
                let validRank: [PieceType?] = [.luke, .knight, .bishop, nil, .queen, .bishop, .knight, .luke]
                if !rank.elementsEqual(validRank, by: { $0?.type == $1 }) {
                    XCTFail("rank[\(rowNum)] Failed")
                }
            } else if rowNum == 2 || rowNum == 7 {
                let validRank: [PieceType?] = [.pawn, .pawn, .pawn, .pawn, .pawn, .pawn, .pawn, .pawn]
                if !rank.elementsEqual(validRank, by: { $0?.type == $1 }) {
                    XCTFail("rank[\(rowNum)] Failed")
                }
            }
        }
    }

    // 3. 체스말 종류별로 최대 개수보다 많이 생성할 수는 없다.
    // - Pawn는 색상별로 8개. Bishop, Luke는 색상별로 2개, Queen는 색상별로 1개만 가능하다.
    func testBoardInitPieceMaxCount() {
        var pieceCounts: [Piece: Int] = [:]

        for rank in board.positions {
            for case let piece? in rank {
                if pieceCounts[piece] == nil {
                    pieceCounts[piece] = 0
                }
                pieceCounts[piece]? += 1
            }
        }

        print(pieceCounts)

        for (piece , count) in pieceCounts {
            switch piece.type {
            case .pawn:
                XCTAssertEqual(count, 8, "최대갯수 이상")
            case .bishop, .luke, .knight:
                XCTAssertEqual(count, 2, "최대갯수 이상")
            case .queen:
                XCTAssertEqual(count, 1, "최대갯수 이상")
            default:
                XCTFail("wrong type")
            }
        }
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

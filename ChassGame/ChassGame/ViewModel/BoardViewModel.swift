//
//  BoardViewModel.swift
//  ChassGame
//
//  Created by fran on 2022/06/30.
//

import Foundation
import Combine

class BoardViewModel {
    private var subscriptions = Set<AnyCancellable>()

    public let updateBoard = PassthroughSubject<Result<[[Piece?]], GameError>, Never>()
    public let pickedPosition = PassthroughSubject<(Position, [Position]), Never>()

    let board: Board = Board()

    private var inputStart: Position?
    private var inputEnd: Position?

    @Published var turn: PieceColor = .white
    @Published var blackScore: Int = 0
    @Published var whiteScore: Int = 0

    var positions: [[Piece?]] {
        return board.positions
    }

    init() {
        addSubscription()

        blackScore = board.score(for: .black)
        whiteScore = board.score(for: .white)
    }

    private func addSubscription() {
        board.updateSubject
            .sink { [weak self] in
                guard let self = self else { return }
                self.updateBoard.send(.success(self.board.positions))
                self.blackScore = self.board.score(for: .black)
                self.whiteScore = self.board.score(for: .black)
            }.store(in: &subscriptions)
    }

    func addInput(position: Position) {
        if let inputStart = inputStart, inputStart == position {
            resetInputs()
            return
        }

        if inputStart != nil && inputEnd != nil {
            resetInputs()
        }

        // first input
        if inputStart == nil {
            // piece 있는지 체크
            guard let piece = board.piece(at: position) else {
                return
            }

            if piece.color != turn {
                updateBoard.send(.failure(GameError.notYourTurn))
                return
            }

            inputStart = position

            // 해당 piece 가 선택됨, 선택가능한 영역 표시
            pickedPosition.send((position, board.movablePositions(of: piece)))
            return
        }

        // second input
        if inputEnd == nil {
            guard let inputStart = inputStart,
                  board.canMove(from: inputStart, to: position) else {
                return
            }

            // move
            board.move(from: inputStart, to: position)
            resetInputs()
            changeTurn()
        }
    }

    func resetInputs() {
        self.updateBoard.send(.success(self.board.positions))
        self.inputStart = nil
        self.inputEnd = nil
    }

    func changeTurn() {
        if self.turn == .black {
            self.turn = .white
        } else {
            self.turn = .black
        }
    }
}

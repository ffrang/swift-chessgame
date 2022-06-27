//
//  BoardViewController.swift
//  ChassGame
//
//  Created by fran on 2022/06/27.
//

import UIKit
import Combine

class BoardViewController: UIViewController {
    @IBOutlet weak var boardView: BoardView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var turnLabel: UILabel!

    private var subscriptions = Set<AnyCancellable>()

    var board: Board = Board()
    var inputStart: Position?
    var inputEnd: Position?
    var turn: PieceColor = .white {
        didSet {
            showTurn()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        turn = .white
        boardView.board = self.board
        showScore()
        addSubscription()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        boardView.reloadItemViewsLayout()
    }

    private func addSubscription() {
        // 입력
        boardView.tapEventSubject
            .sink { [weak self] position in
                self?.addInput(position: position)
            }.store(in: &subscriptions)

        // board 업데이트
        board.updateSubject
            .sink { [weak self] in
                self?.boardView.board = self?.board
                self?.showScore()
            }.store(in: &subscriptions)
    }

    func addInput(position: Position) {
        if inputStart != nil && inputEnd != nil {
            resetInputs()
        }

        if let inputStart = inputStart, inputStart == position {
            resetInputs()
            return
        }

        // first input
        if inputStart == nil {
            // piece 있는지 체크
            guard let piece = board.piece(at: position) else {
                return
            }

            if piece.color != turn {
                // TODO: 만약 백색 차례에 흑색 체스말을 선택하면 진동(haptic)을 발생한다

                let alert = UIAlertController(title: "not your turn", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
                present(alert, animated: true)
                return
            }

            inputStart = position

            // 해당 piece 가 선택됨, 선택가능한 영역 표시
            boardView.pick(at: position, movablePositions: board.movablePositions(of: piece))
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
        boardView.board = self.board
        self.inputStart = nil
        self.inputEnd = nil
    }

    func showScore() {
        let blackScore = board.score(for: .black)
        let whiteScore = board.score(for: .white)

        scoreLabel.text = "score\n black \(blackScore) : \(whiteScore) white"
    }

    func changeTurn() {
        if self.turn == .black {
            self.turn = .white
        } else {
            self.turn = .black
        }
    }

    func showTurn() {
        turnLabel.text = "턴 - \(turn.rawValue)"
    }
}

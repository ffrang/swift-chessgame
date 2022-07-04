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
    var viewModel: BoardViewModel = BoardViewModel()

    var blackScore: Int = 0 {
        didSet {
            showScore()
        }
    }

    var whiteScore: Int = 0 {
        didSet {
            showScore()
        }
    }

    var turn: PieceColor = .white {
        didSet {
            showTurn()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        addSubscription()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        boardView.reloadItemViewsLayout()
    }

    private func bindViewModel() {
        self.blackScore = viewModel.blackScore
        self.whiteScore = viewModel.whiteScore
        self.turn = viewModel.turn
        self.boardView.positions = viewModel.positions

        viewModel.updateBoard
            .sink { [weak self] result in
                switch result {
                case .success(let positions):
                    self?.boardView.positions = positions
                    self?.showScore()
                case .failure(let error) where error == .notYourTurn:
                    self?.notYourTurnAction()
                case .failure(_):
                    print("no action")
                }
            }.store(in: &subscriptions)

        viewModel.pickedPosition
            .sink { [weak self] (position, movablePositions) in
                self?.boardView.pick(at: position, movablePositions: movablePositions)
            }.store(in: &subscriptions)

        viewModel.$turn
            .sink { [weak self] turn in
                self?.turn = turn
            }.store(in: &subscriptions)

        viewModel.$blackScore
            .sink { [weak self] score in
                self?.blackScore = score
            }.store(in: &subscriptions)

        viewModel.$whiteScore
            .sink { [weak self] score in
                self?.whiteScore = score
            }.store(in: &subscriptions)
    }

    private func addSubscription() {
        // 입력
        boardView.tapEventSubject
            .sink { [weak self] position in
                self?.sendInput(position: position)
            }.store(in: &subscriptions)
    }

    private func notYourTurnAction() {
        // TODO: 만약 백색 차례에 흑색 체스말을 선택하면 진동(haptic)을 발생한다
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "not your turn", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

    func sendInput(position: Position) {
        viewModel.addInput(position: position)
    }

    func showScore() {
        scoreLabel.text = "score\n black \(blackScore) : \(whiteScore) white"
    }

    func showTurn() {
        turnLabel.text = "턴 - \(turn.rawValue)"
    }
}

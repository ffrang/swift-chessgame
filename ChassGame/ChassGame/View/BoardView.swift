//
//  BoardView.swift
//  ChassGame
//
//  Created by fran on 2022/06/27.
//

import UIKit
import Combine

class BoardView: UIView {
    var itemViews: [[BoardItemView]] = []
    var board: Board? {
        didSet {
            showBoard()
        }
    }

    public let tapEventSubject = PassthroughSubject<Position, Never>()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.makeItemViews()
    }

    func makeItemViews() {
        // 8x8
        itemViews = []
        self.subviews.forEach({ $0.removeFromSuperview() })

        for y in 0...7 {
            var rank: [BoardItemView] = []
            for x in 0...7 {
                let bgColor:BoardBGColor = (y % 2 == x % 2) ? .white : .black
                if let itemView = Bundle.main.loadNibNamed("BoardItemView", owner: nil, options: nil)?[0] as? BoardItemView {
                    itemView.bgColor = bgColor
                    itemView.position.x = x
                    itemView.position.y = y
                    itemView.didTap = { [weak self] (position) in
                        self?.tapEventSubject.send(position)
                    }
                    rank.append(itemView)
                    self.addSubview(itemView)
                }
            }
            itemViews.append(rank)
        }

        reloadItemViewsLayout()
    }

    func reloadItemViewsLayout() {
        let width: CGFloat = self.bounds.width / 8
        let height: CGFloat = self.bounds.height / 8
        var y: CGFloat = 0
        for rank in itemViews {
            var x: CGFloat = 0
            for itemView in rank {
                itemView.frame = CGRect(x: x, y: y, width: width, height: height)
                x += width
            }

            y += height
        }
    }

    func showBoard() {
        guard let board = board else {
            makeItemViews()
            return
        }

        for (i, rank) in board.positions.enumerated() {
            for (j, piece) in rank.enumerated() {
                let itemView = itemViews[i][j]
                itemView.piece = piece
            }
        }
    }

    func pick(at: Position, movablePositions: [Position]) {
        let itemView = itemView(at: at)
        itemView.isSelected = true
        showMovablePositions(movablePositions)
        
    }

    func itemView(at: Position) -> BoardItemView {
        return itemViews[at.y][at.x]
    }

    func showMovablePositions(_ positions: [Position]) {
        for position in positions {
            itemViews[position.y][position.x].canSelectable = true
        }
    }
}

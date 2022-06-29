//
//  BoardItemView.swift
//  ChassGame
//
//  Created by fran on 2022/06/27.
//

import UIKit

enum BoardBGColor {
    case white
    case black

    var color: UIColor {
        if self == .white {
            return .white
        } else {
            return UIColor(rgb: 0x335b51)
        }
    }
}

class BoardItemView: UIView {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    var position: Position = Position(x: 0, y: 0)!

    public var didTap: ((_ position: Position) -> Void)?

    var bgColor: BoardBGColor = .white {
        didSet {
            bgView.backgroundColor = bgColor.color
        }
    }

    var piece: Piece? {
        didSet {
            reloadView()
        }
    }

    var isSelected: Bool = false {
        didSet {
            button.isSelected = isSelected
        }
    }

    var canSelectable: Bool = false {
        didSet {
            if canSelectable {
                // border
                button.layer.borderColor = UIColor.systemPink.cgColor
                button.layer.borderWidth = 5
            } else {
                button.layer.borderWidth = 0
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func reloadView() {
        self.isSelected = false
        self.canSelectable = false

        guard let piece = piece else {
            label.text = ""
            return
        }
        label.text = piece.symbol

    }

    @IBAction func tap(_ sender: Any) {
        self.didTap?(position)
    }
}

class BoardItemButton: UIButton {
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .systemPink : .clear
        }
    }
}

//
//  Rook.swift
//  ChassGame
//
//  Created by fran on 2022/06/20.
//

import Foundation

/**
 생성 위치는 흑색은 A-1 과 H-1 에만 가능하고, 백색은 A-8 과 H-8 에만 가능하다.
 모든 색상이 놓여진 칸을 기준으로 좌-우 또는 위-아래 방향으로 움직일 수 있다.
 */

class Rook: Piece {
    override var moveRuleSet: [StepRule] {
        let routes = [
            StepRule(steps: [Step(x: 1, y: 0)], repetable: true),
            StepRule(steps: [Step(x: -1, y: 0)], repetable: true),
            StepRule(steps: [Step(x: 0, y: 1)], repetable: true),
            StepRule(steps: [Step(x: 0, y: -1)],  repetable: true)
        ]
        return routes
    }
}

//
//  Pawn.swift
//  ChassGame
//
//  Created by fran on 2022/06/20.
//

import Foundation

/**
 생성 위치는 흑색은 2-rank 또는 백색 7-rank에만 가능하다.
 백색은 더 작은 rank로 움직일 수 있고, 흑색은 더 큰 rank로 움직일 수 있다.
 체스 게임과 달리 처음에도 1칸만 움직일 수 있고, 다른 말을 잡을 때도 대각선이 아니라 직선으로 움직일 때 잡는다고 가정한다.
 */

class Pawn: Piece {
    override var moveRuleSet: [StepRule] {
        // 전진 방향 : black 은 아래로, white는 위로
        let stepY = (self.color == .black) ? 1 : -1
        let routes = [
            StepRule(steps: [Step(x: 0, y: stepY)], repetable: false)
        ]
        return routes
    }
}

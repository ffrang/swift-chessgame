//
//  Knight.swift
//  ChassGame
//
//  Created by fran on 2022/06/20.
//

import Foundation

/**
 생성 위치는 흑색은 B-1 과 G-1 에만 가능하고, 백색은 B-8 과 G-8 에만 가능하다.
 모든 색상이 놓여진 칸을 기준으로 전진1칸+대각선1칸으로만 움직일 수 있다.
 체스 게임과 달리 전진하는 칸이 막혀있으면 움직일 수 없다.
 */

class Knight: Piece {
    override var moveRuleSet: [StepRule] {
        // 전진 방향 : black 은 아래로, white는 위로
        let stepY = (self.color == .black) ? 1 : -1

        // step1 : 전진 1칸
        let step1 = Step(x: 0, y: stepY)

        // step2 : 대각선1칸 - 대각선은 전진하는 방향의 대각선만 인가?
        let routes = [
            StepRule(steps: [step1, Step(x: 1, y: stepY)], repetable: false),
            StepRule(steps: [step1, Step(x: -1, y: stepY)], repetable: false)
        ]
        return routes
    }
}

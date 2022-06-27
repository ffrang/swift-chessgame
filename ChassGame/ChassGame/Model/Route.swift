//
//  Route.swift
//  ChassGame
//
//  Created by fran on 2022/06/23.
//

import Foundation

/**
 Route - piece가 갈수있는 경로, positon(board 내 위치) 기준
 */
struct Route {
    var positions: [Position]
    var canStopOnlyLastPostion: Bool = false // 경로의 마지막 position에만 piece를 놓을수 있는지 여부 ex) knight
}

/**
 StepRule - piece가 움직일수 있는 rule 정의, step 기준
 */
struct StepRule {
    var steps: [Step]
    var repetable: Bool = false     // steps로 이동한 장소에서 더 반복할지 여부
}

/**
 Step - 1칸 이동 거리
 */
struct Step {
    var x: Int = 0
    var y: Int = 0
}

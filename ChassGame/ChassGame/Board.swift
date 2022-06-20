//
//  Board.swift
//  ChassGame
//
//  Created by fran on 2022/06/20.
//

import Foundation
/**
 Board는 8x8 (가로 rank x 세로 file) 크기 체스판에 체스말(Piece) 존재 여부를 관리한다.

 Board는 현재 있는 말을 확인해서 흑과 백 점수를 출력한다.
 - 색상별로 Pawn 1점, Bishop와 Knight 3점, Luke 5점, 퀸은 9점으로 계산한다.

 Board는 모든 말의 위치를 알 수 있고, display() 함수는 1-rank부터 8-rank까지 rank 문자열 배열로 보드 위에 체스말을 리턴한다
 - 흑색 Pawn는 ♟ U+265F, Knight는 ♞ U+265E, Biship은 ♝ U+265D, Luke는 ♜ U+265C, Queen은 ♛ U+265B를 빈 곳은 "."을 표시한다.
 - 백색 Pawn는 ♙ U+2659, Knight는 ♘ U+2658, Biship은 ♗ U+2657, Luke는 ♖ U+2656, Queen은 ♕ U+2655를 빈 곳은 "."을 표시한다.
 - 예를 들어 초기화 상태에 Luke, Bishop, Queen만 있는 경우 1-rank는 "♜♞♝.♛♝♞♜" 가 된다.

 특정 위치에 특정 말을 생성한다.
-  초기화할 때 1,2-rank는 흑백 체스말이, 7,8-rank는 백색 체스말이 위치한다.
-  체스말 초기 위치가 아니면 생성하지 않는다.
 - 이미 해당 위치에 다른 말이 있으면 생성하지 않는다.
 - 체스말 종류별로 최대 개수보다 많이 생성할 수는 없다.
 - Pawn는 색상별로 8개. Bishop, Luke는 색상별로 2개, Queen는 색상별로 1개만 가능하다.

 특정 말을 옮기는 메소드는 Board에서 제공한다.
 - 같은 색상의 말이 to 위치에 다른 말이 이미 있으면 옮길 수 없다.
 - 말을 옮길 수 있으면 true, 옮길 수 없으면 false를 리턴한다.
 - 만약, 다른 색상의 말이 to 위치에 있는 경우는 기존에 있던 말을 제거하고 이동한다.

 체스말은 위치값은 가로 file은 A부터 H까지, 세로 rank는 1부터 8까지 입력이 가능하다.

 체스말은 색상값을 흑Black 또는 백White 중에 하나를 가진다.
 - 체스말 색상은 변경할 수 없다.

 체스말은 현재 위치를 기준으로 이동할 수 있는 모든 위치를 제공한다.
 - 다른 말이 있는지 여부는 판단하지 않는다.
 */

class Board {
    var ranks: [[Piece?]]?

    init() {
        ranks = [
            ["♜", "♞", "♝", nil, "♛", "♝", "♞", "♜"],
            ["♟", "♟", "♟", "♟", "♟", "♟", "♟", "♟"],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            ["♙", "♙", "♙", "♙", "♙", "♙", "♙", "♙"],
            ["♖", "♘", "♗", nil, "♕", "♗", "♘", "♖"]
        ]
    }


}

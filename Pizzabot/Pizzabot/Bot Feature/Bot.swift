//
//  Bot.swift
//  Pizzabot
//
//  Created by Islom Babaev on 16/11/21.
//


public protocol Bot {
    var position : (Int, Int) { get }
    typealias MoveResult = Result<Direction, Error>
    func move(to direction: Direction, completion: @escaping (MoveResult) -> Void)
}

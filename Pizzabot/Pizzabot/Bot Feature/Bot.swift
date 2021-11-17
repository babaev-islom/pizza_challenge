//
//  Bot.swift
//  Pizzabot
//
//  Created by Islom Babaev on 16/11/21.
//


public protocol Bot {
    var currentXPosition : Int {get}
    var currentYPosition : Int {get}
    @discardableResult mutating func move(to direction: Direction) -> Bool
}

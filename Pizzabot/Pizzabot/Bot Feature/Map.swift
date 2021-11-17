//
//  Map.swift
//  Pizzabot
//
//  Created by Islom Babaev on 16/11/21.
//

public protocol Map {
    func validateMove(direction: Direction, from position: (x: Int, y: Int)) -> Bool
}

//
//  Direction.swift
//  Pizzabot
//
//  Created by Islom Babaev on 15/11/21.
//

public enum Direction {
    case east
    case south
    case west
    case north
    case drop
    
    ///Enums must have unique rawValue for each case
    ///Thus, moveValue defines a value in the range [-1,1] to move the bot on the grid
    var moveValue : Int {
        switch self {
        case .east, .north:
            return 1
        case .west, .south:
            return -1
        case .drop:
            return 0
        }
    }
}

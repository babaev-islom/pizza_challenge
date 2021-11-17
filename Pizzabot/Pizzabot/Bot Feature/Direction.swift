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
    public var moveValue : Int {
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

public extension Direction {
    static func convertDirectionsIntoPathString(_ directions: [Direction]) -> String {
        var path = ""
        directions.forEach { direction in
            switch direction {
            case .east:
                path += "E"
            case .west:
                path += "W"
            case .north:
                path += "N"
            case .south:
                path += "S"
            case .drop:
                path += "D"
            }
        }
        return path
    }
}

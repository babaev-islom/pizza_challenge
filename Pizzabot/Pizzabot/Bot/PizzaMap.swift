//
//  PizzaMap.swift
//  Pizzabot
//
//  Created by Islom Babaev on 15/11/21.
//

public struct PizzaMap : Map {
    
    private let mapSize : Int
    
    public init(mapSize: Int) {
        self.mapSize = mapSize
    }
    
    public func validateMove(direction: Direction, from position: (x: Int, y: Int)) -> Bool {
        let (xPos, yPos) = position
        
        switch direction {
        case .east:
            return xPos < mapSize
        case .west:
            return xPos > 0
        case .south:
            return yPos > 0
        case .north:
            return yPos < mapSize
        case .drop:
            return true
        }
    }
}

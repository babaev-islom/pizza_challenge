//
//  PizzaBot.swift
//  Pizzabot
//
//  Created by Islom Babaev on 15/11/21.
//

public struct PizzaBot : Bot {
    public var currentXPosition : Int = 0
    public var currentYPosition : Int = 0
    
    private var map: Map
    
    public init(map: Map) {
        self.map = map
    }
    
    @discardableResult
    mutating public func move(to direction: Direction) -> Bool {
        guard map.validateMove(direction: direction, from: (currentXPosition, currentYPosition)) else { return false }
        
        switch direction {
        case .east, .west:
            currentXPosition += direction.moveValue
        case .north, .south:
            currentYPosition += direction.moveValue
        case .drop:
            break
        }
        
        return true
    }
}
  

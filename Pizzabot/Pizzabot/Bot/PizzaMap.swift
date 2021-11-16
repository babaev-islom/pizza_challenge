//
//  PizzaMap.swift
//  Pizzabot
//
//  Created by Islom Babaev on 15/11/21.
//

public final class PizzaMap : Map {
    private let mapSize : Int
    
    public init(mapSize: Int) {
        self.mapSize = mapSize
    }
    
    public func validateMove(direction: Direction, from position: (x: Int, y: Int), completion: @escaping (Error?) -> Void) {
        let (xPos, yPos) = position
        let outOfBoundsError = NSError(domain: "Failed with out of bounds", code: -1)
        
        switch direction {
        case .east:
            xPos < mapSize ? completion(nil) : completion(outOfBoundsError)
        case .south:
            yPos > 0 ? completion(nil) : completion(outOfBoundsError)
        case .west:
            xPos > 0 ? completion(nil) : completion(outOfBoundsError)
        case .north:
            yPos < mapSize ? completion(nil) : completion(outOfBoundsError)
        case .drop:
            completion(nil)
        }
    }
}

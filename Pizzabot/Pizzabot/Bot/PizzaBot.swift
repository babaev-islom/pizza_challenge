//
//  PizzaBot.swift
//  Pizzabot
//
//  Created by Islom Babaev on 15/11/21.
//

public final class PizzaBot : Bot {
    private var currentXPosition: Int = 0
    private var currentYPosition: Int = 0
    
    public var position : (Int, Int) {
        return (currentXPosition, currentYPosition)
    }
    
    private let map: Map
    
    public init(map : Map) {
        self.map = map
    }
    
    public func move(to direction: Direction, completion: @escaping (MoveResult) -> Void) {
        map.validateMove(direction: direction, from: (x: currentXPosition, y: currentYPosition)) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                return completion(.failure(error))
            }
            
            switch direction {
            case .east, .west:
                self.currentXPosition += direction.moveValue
            case .south, .north:
                self.currentYPosition += direction.moveValue
            case .drop:
                break
            }
            
            completion(.success(direction))
        }
    }
}

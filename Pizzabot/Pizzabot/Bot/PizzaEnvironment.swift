//
//  PizzaEnvironment.swift
//  Pizzabot
//
//  Created by Islom Babaev on 16/11/21.
//

public final class PizzaEnvironment : Environment {
    
    public let mapSize : Int
    public let inputPaths : [(Int,Int)]
    
    public var botMoves : [Direction] = []
    
    private var bot: Bot
    
    public init(input: String) throws {
        self.mapSize = try InputParser.parseInputMapSize(input: input)
        self.inputPaths = try InputParser.parseInputPaths(input: input, mapSize: self.mapSize)
        self.bot = PizzaBot(map: PizzaMap(mapSize: self.mapSize-1))
    }
    
    public func startBot() throws {
        try inputPaths.forEach { (xPos, yPos) in
            
            let currentBotXPosition = bot.currentXPosition
            let currentBotYPosition = bot.currentYPosition
            
            //if current X position value is less than the value that is in the path
            //we would move east and west otherwise
            if xPos > currentBotXPosition {
                try moveToDirection(.east, from: currentBotXPosition, to: xPos)
            } else if currentBotXPosition > xPos {
                try moveToDirection(.west, from: xPos, to: currentBotXPosition)
            }
            
            //if current Y position value is less than the value that is in the path
            //we would move north and south otherwise
            if yPos > currentBotYPosition {
                try moveToDirection(.north, from: currentBotYPosition, to: yPos)
            } else if currentBotYPosition > yPos {
                try moveToDirection(.south, from: yPos, to: currentBotYPosition)
            }
            
            //if the bot is on the same cell as the required target position
            if bot.currentXPosition == xPos && bot.currentYPosition == yPos {
                guard bot.move(to: .drop) else { throw NSError(domain: "out of bounds", code: -1)
                }
                botMoves.append(.drop)
            }
        }
    }
    
    private func moveToDirection(_ direction : Direction, from fromPosition : Int, to toPosition: Int) throws {
        for _ in fromPosition..<toPosition {
            let moveSuccess = bot.move(to: direction)
            guard moveSuccess else { throw NSError(domain: "out of bounds", code: -1)
            }
            botMoves.append(direction)
        }
    }
}

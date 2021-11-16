//
//  PizzaEnvironment.swift
//  Pizzabot
//
//  Created by Islom Babaev on 16/11/21.
//


public final class PizzaEnvironment : Environment {
    public let mapSize : Int
    public let inputPaths : [(Int, Int)]
    
    private let bot : PizzaBot
    
    public var botMoves = [Direction]()
    
    private var botXPos : Int = 0
    private var botYPos : Int = 0
    
    public var numberOfIterations: Int = 0
    
    public init(input: String) throws {
        self.mapSize = try InputParser.parseInputMapSize(input: input)
        self.inputPaths = try InputParser.parseInputPaths(input: input, mapSize: self.mapSize)
        self.bot = PizzaBot(map: PizzaMap(mapSize: self.mapSize-1))
    }
    
    public func startBot() throws {
        try inputPaths.forEach { (xPos, yPos) in
            numberOfIterations += 1
            
            let currentBotXPosition = botXPos
            let currentBotYPosition = botYPos
            
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
            if botXPos == xPos && botYPos == yPos {
                var capturedError : Error?
                bot.move(to: .drop) { [unowned self] result in
                    switch result {
                    case let .success(direction):
                        self.botMoves.append(direction)
                    case let .failure(receivedError):
                        capturedError = receivedError
                    }
                }
                
                if let error = capturedError {
                    throw error
                }
            }
        }
    }
    
    //helper method to move the bot in the app with respect to the direction and interval passed as arguments
    private func moveToDirection(_ direction : Direction, from fromPosition : Int, to toPosition: Int) throws {
        for _ in fromPosition..<toPosition {
            
            var capturedError : Error?
           
            bot.move(to: direction) { [unowned self] result in
                switch result {
                case let .success(direction):
                    self.botMoves.append(direction)
                    switch direction {
                    case .east:
                        self.botXPos += 1
                    case .west:
                        self.botXPos += -1
                    case .north:
                        self.botYPos += 1
                    case .south:
                        self.botYPos += -1
                    case .drop:
                        break
                    }
                case let .failure(receivedError):
                    capturedError = receivedError
                }
            }
            
            if let error = capturedError {
                throw error
            }
        }
    }
}

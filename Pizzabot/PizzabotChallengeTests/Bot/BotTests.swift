//
//  BotTests.swift
//  PizzabotChallengeTests
//
//  Created by Islom Babaev on 17/11/21.
//

import XCTest
import Pizzabot
  

class BotTests : XCTestCase {
    
    func test_moveWest_failsToMoveFromOriginOnMapOutOfBounds() {
        var sut = makeSUT()
        
        let moveWest = sut.move(to: .west)
        
        XCTAssertFalse(moveWest)
    }
    
    func test_moveSouth_failsToMoveFromOriginOnMapOutOfBounds() {
        var sut = makeSUT()
        
        let moveSouth = sut.move(to: .south)
        
        XCTAssertFalse(moveSouth)
    }
    
    func test_moveEast_incrementsXPositionSuccesfully() {
        var sut = makeSUT()

        sut.move(to: .east)

        XCTAssertEqual(sut.currentXPosition, 1)
    }

    func test_moveEast_returnsTrueOnSuccessfulMove() {
        var sut = makeSUT()

        let moveEast = sut.move(to: .east)

        XCTAssertTrue(moveEast)
    }

    func test_moveWest_failsToMoveOnMapValidation() {
        var sut = makeSUT()
        
        XCTAssertFalse(sut.move(to: .west))
    }
    
    func test_moveWest_succeedsWhenMovingNotAtMapBounds() {
        var sut = makeSUT()
        sut.move(to: .east)
        
        let moveWestSuccess = sut.move(to: .west)
        
        XCTAssertTrue(moveWestSuccess)
    }
    
    func test_moveWest_decrementsXPositionOnMapValidation() {
        var sut = makeSUT()
        sut.move(to: .east)
        XCTAssertEqual(sut.currentXPosition, 1)
        
        sut.move(to: .west)
        
        XCTAssertEqual(sut.currentXPosition, 0)
    }
    
    func test_moveNorth_succeedsOnMapValidation() {
        var sut = makeSUT()
        
        let moveSuccess = sut.move(to: .north)
        
        XCTAssertTrue(moveSuccess)
    }
    
    func test_moveNorth_incrementsYPositionOnMapValidation() {
        var sut = makeSUT()
        
        sut.move(to: .north)
        
        XCTAssertEqual(sut.currentYPosition, 1)
    }
    
    func test_moveNorth_failsOnMapValidationDueToOutOfBoundMap() {
        let mapSize = 5
        var sut = makeSUT(mapSize: mapSize-1)
        sut.move(to: .north)
        sut.move(to: .north)
        sut.move(to: .north)
        sut.move(to: .north)

        let moveSuccess = sut.move(to: .north)

        XCTAssertFalse(moveSuccess)
    }
    
    func test_moveSouth_succeedsOnMovingNotFromOrigin() {
        var sut = makeSUT()
        sut.move(to: .north)
        
        let moveSuccess = sut.move(to: .south)
        
        XCTAssertTrue(moveSuccess)
    }
    
    
    func test_moveSouth_decrementsYPositionOnMapValidation() {
        var sut = makeSUT()
        sut.move(to: .north)
        
        sut.move(to: .south)
        
        XCTAssertEqual(sut.currentYPosition, 0)
    }
    
    func test_moveDrop_alwaysSucceedsOnMapValidation() {
        var sut = makeSUT()
        
        let actionSuccess = sut.move(to: .drop)
        
        XCTAssertTrue(actionSuccess)
    }
    
    func test_moveDrop_doesNotIncrementXPositionOnMapValidation() {
        var sut = makeSUT()
        
        sut.move(to: .drop)
        
        XCTAssertEqual(sut.currentXPosition, 0)
    }
    
    func test_moveDrop_doesNotIncrementYPositionOnMapValidation() {
        var sut = makeSUT()
        
        sut.move(to: .drop)
        
        XCTAssertEqual(sut.currentYPosition, 0)
    }

    private func makeSUT(mapSize: Int = 5) -> Bot {
        let client = PizzaMap(mapSize: mapSize)
        return PizzaBot(map: client)
    }
}

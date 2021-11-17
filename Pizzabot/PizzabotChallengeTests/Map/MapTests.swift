//
//  MapTests.swift
//  PizzabotChallengeTests
//
//  Created by Islom Babaev on 17/11/21.
//

import XCTest
import Pizzabot


class MapTests : XCTestCase {
    
    func test_validateMove_returnsFalseOnMoveWestFromOrigin() {
        let sut = makeSUT(mapSize: 5)
        
        let moveSuccess = sut.validateMove(direction: .west, from: (0,0))
        
        XCTAssertFalse(moveSuccess)
    }
    
    func test_validateMove_succeedsOnMovingEastFromOrigin() {
        let sut = makeSUT(mapSize: 5)
        
        let moveSuccess = sut.validateMove(direction: .east, from: (0,0))
        
        XCTAssertTrue(moveSuccess)
    }
    
    func test_validateMove_suceedsOnMovingWestFromPath_1_0() {
        let sut = makeSUT(mapSize: 5)

        let moveSuccess = sut.validateMove(direction: .west, from: (1,0))
        
        XCTAssertTrue(moveSuccess)
    }
    
    func test_validateMove_failsToMoveEastFromPathThatIsGreaterThanOrEqualToMapSize() {
        let mapSize = 5
        let anyYCoordinate = 3
        
        //Map size should be always less than the input we are providing.
        //For instance, 5x5 map's size should be 4 since the origin starts from 0
        let sut = makeSUT(mapSize: mapSize-1)
        
        let moveSuccess = sut.validateMove(direction: .east, from: (mapSize-1,anyYCoordinate))
        
        XCTAssertFalse(moveSuccess)
    }

    func test_validateMove_succeedsToMoveSouthFromPath_2_3() {
        let sut = makeSUT(mapSize: 5)

        let moveSuccess = sut.validateMove(direction: .south, from: (2,3))
        
        XCTAssertTrue(moveSuccess)
    }
    
    func test_validateMove_failsToMoveSouthFromOrigin() {
        let sut = makeSUT(mapSize: 5)

        let moveSuccess = sut.validateMove(direction: .south, from: (0,0))
        
        XCTAssertFalse(moveSuccess)
    }
    
    func test_validateMove_succeedsToMoveNorthFromOrigin() {
        let sut = makeSUT(mapSize: 5)

        let moveSuccess = sut.validateMove(direction: .north, from: (0,0))
        
        XCTAssertTrue(moveSuccess)
    }
    
    func test_validateMove_failsToMoveNorthFromPathThatIsGreaterThanOrEqualToMapSize() {
        let mapSize = 5
        let anyXCoordinate = 3
        
        //Map size should be always less than the input we are providing.
        //For instance, 5x5 map's size should be 4 since the origin starts from 0
        let sut = makeSUT(mapSize: mapSize-1)
        
        let moveSuccess = sut.validateMove(direction: .north, from: (anyXCoordinate,mapSize-1))
        
        XCTAssertFalse(moveSuccess)
    }
    
    func test_validateMove_alwaysSuceedsOnDrop() {
        let sut = makeSUT(mapSize: 5)

        let moveSuccess = sut.validateMove(direction: .drop, from: (0,0))
        
        XCTAssertTrue(moveSuccess)
    }
    
    private func makeSUT(mapSize: Int) -> Map {
        return PizzaMap(mapSize: mapSize)
    }
    
}

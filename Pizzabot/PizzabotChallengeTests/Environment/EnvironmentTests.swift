//
//  EnvironmentTests.swift
//  PizzabotChallengeTests
//
//  Created by Islom Babaev on 15/11/21.
//

import XCTest
import Pizzabot


class EnvironmentTests : XCTestCase {
    
    func test_init_throwsOnEmptyInputString() {
        XCTAssertThrowsError(try PizzaEnvironment(input: ""), "Should throw an error since the input string is empty")
    }
    
    func test_init_deliversErrorOnInvalidMapSize() {
        do {
            _ = try makeSUT(input: "5x (2, 5) (4, 3)")
            XCTFail("Expected initialization to fail with \(InputParser.ParseError.invalidMapSize) error")
        } catch {
            XCTAssertEqual(error as? InputParser.ParseError, InputParser.ParseError.invalidMapSize)
        }
    }
    
    func test_init_deliversErrorOnInvalidInputPaths() {
        do {
            _ = try makeSUT(input: "5x5 2,5)(4,3)")
            XCTFail("Expected initialization to fail with \(InputParser.ParseError.invalidPaths) error")
        } catch {
            XCTAssertEqual(error as? InputParser.ParseError, InputParser.ParseError.invalidPaths)
        }
    }
    
    func test_init_throwsOnInputPathCoordinatePositionOnGreaterThanOrEqualToMapSize() {
        do {
            _ = try makeSUT(input: "5x5 (2, 5)")
            XCTFail("Expected initialization to throw due to input path coordinate being greater than or equal to input map size")
        } catch {
            XCTAssertEqual(error as? InputParser.ParseError, InputParser.ParseError.coordinateOutOfMapSizeBounds)
        }
    }
    
    func test_init_parsesInputStringIntoValidMapSize() {
        do {
            let sut = try makeSUT(input: "5x5 (2, 4) (4, 3)")
            XCTAssertEqual(sut.mapSize, 5)
        } catch {
            XCTFail("Expected initialization to succeed, got \(error) error instead")
        }
    }
    
    func test_init_parsesInputStringIntoValidInputPaths() {
        do {
            let sut = try makeSUT(input: "5x5 (2, 4)")
            let firstTuple = try XCTUnwrap(sut.inputPaths.first)
            XCTAssertTrue(firstTuple == (2,4))
        } catch {
            XCTFail("Expected initialization to succeed, got \(error) error instead")
        }
    }
    
    func test_startBot_moveEastAndDropsOnPath_1_0() throws {
        let sut = try makeSUT(input: "5x5 (1, 0)")
        
        try sut.startBot()
        
        XCTAssertEqual(sut.botMoves, [.east, .drop])
    }


    func test_startBot_moveEastAndDropsTwiceOnPath_1_0() throws {
        let sut = try makeSUT(input: "5x5 (1, 0) (1, 0)")

        try sut.startBot()

        XCTAssertEqual(sut.botMoves, [.east, .drop, .drop])
    }

    func test_startBot_dropsOnPath_0_0() throws {
        let sut = try makeSUT(input: "5x5 (0, 0)")

        try sut.startBot()

        XCTAssertEqual(sut.botMoves, [.drop])
    }
    
    func test_startBot_correctlyFollowsTestInputPath() {
        let testInputPath = "5x5 (1, 3) (4, 4)"

        do {
            let sut = try makeSUT(input: testInputPath)
            try sut.startBot()
            XCTAssertEqual(Direction.convertDirectionsIntoPathString(sut.botMoves), "ENNNDEEEND")
        } catch {
            XCTFail("Expected initialization to succeed, got \(error) instead")
        }
    }

    func test_startBot_correctlyFollowsMainInputPath() {
        let testInputPath = "5x5 (0, 0) (1, 3) (4, 4) (4, 2) (4, 2) (0, 1) (3, 2) (2, 3) (4, 1)"
        do {
            let sut = try makeSUT(input: testInputPath)
            try sut.startBot()
            XCTAssertEqual(Direction.convertDirectionsIntoPathString(sut.botMoves), "DENNNDEEENDSSDDWWWWSDEEENDWNDEESSD")
        } catch {
            XCTFail("Expected initialization to succeed, got \(error) instead")
        }
    }
    
    private func makeSUT(input: String) throws -> Environment {
        let sut = try PizzaEnvironment(input: input)
        return sut
    }
    
}

private func == <T:Equatable> (tuple1:(T,T),tuple2:(T,T)) -> Bool {
    return (tuple1.0 == tuple2.0) && (tuple1.1 == tuple2.1)
}



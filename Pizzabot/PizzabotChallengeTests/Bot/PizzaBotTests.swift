//
//  PizzaBotTests.swift
//  PizzaBotTests
//
//  Created by Islom Babaev on 12/11/21.
//

import XCTest
import Pizzabot

class PizzaBotTests: XCTestCase {
    
    func test_init_doesNotExecuteActionsUponCreation() {
        let (_, map) = makeSUT()
        
        XCTAssertEqual(map.executedMoves, [])
    }
    
    func test_moveEast_deliversEastDirectionToClientOnSuccessfulMove() {
        let (sut, client) = makeSUT()
        let exp = expectation(description: "Wait for move completion")
        
        sut.move(to: .east) { _ in exp.fulfill() }
        
        client.completeMoveSuccessfully()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(client.executedMoves, [.east])
    }
    
    func test_moveEast_deliversNoErrorOnSuccessfulMove() {
        let (sut, client) = makeSUT()
        let anyValidMove : Direction = .east
        
        expect(sut, to: anyValidMove, toCompeleteWith: .success(anyValidMove), when: {
            client.completeMoveSuccessfully()
        })
    }
    
    func test_moveEast_deliversErrorOnUnsucessfulMove() {
        let (sut, client) = makeSUT()
        let anyMoveError = anyNSError()
        let anyValidMove : Direction = .east
        
        expect(sut, to: anyValidMove, toCompeleteWith: .failure(anyMoveError), when: {
            client.completeMove(with: anyMoveError)
        })
    }
    
    func test_moveEast_incrementsXPositionOnSuccessfulMove() {
        let (sut, client) = makeSUT()
        
        sut.move(to: .east) { _ in }
        
        client.completeMoveSuccessfully()
        
        XCTAssertEqual(sut.position.0, 1)
        XCTAssertEqual(sut.position.1, 0)
    }
    
    func test_moveSouth_deliversErrorOnTryingToMoveMapOutOfBounds() {
        let (sut, client) = makeSUT()
        
        sut.move(to: .south) { _ in }
        client.completeMove(with: anyNSError())
        
        XCTAssertEqual(sut.position.0, 0)
        XCTAssertEqual(sut.position.1, 0)
    }
    
    func test_doesNotDeliverErrorAfterSUTInstanceHasBeenDeallocated() {
        let client = MapSpy()
        var sut: PizzaBot? = PizzaBot(map: client)
        
        var capturedResults = [Bot.MoveResult]()
        sut?.move(to: .south) { capturedResults.append($0) }
        
        sut = nil
        
        client.completeMove(with: anyNSError())
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    private func expect(_ sut: Bot, to direction : Direction, toCompeleteWith expectedResult: Bot.MoveResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for move completion")
        
        sut.move(to: direction) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedDirection), .success(expectedDirection)):
                XCTAssertEqual(receivedDirection , expectedDirection, file: file, line: line)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError , expectedError, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead")
            }
                
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
            
    }
    
    private func makeSUT() -> (sut: Bot, client: MapSpy)  {
        let client = MapSpy()
        let sut = PizzaBot(map: client)
        
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        return (sut, client)
    }
    
    private class MapSpy : Map {
        private(set) var moveCompletions = [(Error?) -> Void]()
        private(set) var executedMoves = [Direction]()
        
        func validateMove(direction: Direction,  from position: (x: Int, y: Int) = (0,0), completion: @escaping (Error?) -> Void) {
            executedMoves.append(direction)
            moveCompletions.append(completion)
        }
        
        func completeMove(with error: Error, at index : Int = 0) {
            moveCompletions[index](error)
        }
        
        func completeMoveSuccessfully(at index: Int = 0) {
            moveCompletions[index](nil)
        }
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "any domain", code: 1)
    }
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak detected", file: file, line: line)
        }
    }

    
}

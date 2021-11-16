//
//  InputParser.swift
//  Pizzabot
//
//  Created by Islom Babaev on 16/11/21.
//

public final class InputParser {
    
    public enum ParseError : Error {
        case invalidInputString
        case invalidMapSize
        case invalidPaths
        case coordinateOutOfMapSizeBounds
    }
    
    public static func parseInputMapSize(input: String) throws -> Int {
        guard !input.isEmpty else { throw ParseError.invalidInputString }
        let substring = input.split(separator: " ")
        guard let firstSubstring = substring.first,
              firstSubstring.count == 3,
              let mapSizeCharacter = firstSubstring.first,
              let mapSize = Int(String(mapSizeCharacter)) else { throw ParseError.invalidMapSize }
        return mapSize
    }
    
    public static func parseInputPaths(input: String, mapSize: Int) throws -> [(x: Int, y: Int)] {
        //split the entire string into two parts: map size and input paths
        var substring = input.split(separator: " ")
        
        //remove map size
        substring.removeFirst()
        
        //convert characters into array of strings since direct string manipulation is cumbersome in Swift
        let arrayOfCharacters : [String] = substring.flatMap{ $0 }.map{ String($0) }
        
        //each input path consists of 5 characters (1,2) -> consists of 5 characters
        guard arrayOfCharacters.count % 5 == 0 else { throw ParseError.invalidPaths }
        
        //convert array of characters into array of numbers only
        let intValues = arrayOfCharacters
            .map{ Int($0) }
            .compactMap { $0 }
        
        guard !intValues.contains(mapSize) else { throw ParseError.coordinateOutOfMapSizeBounds }
        
        //transform the array with even number of values into an array of tuples
        //e.g., [1,2,3,4] -> [(1,2), (3,4)]
        let inputPaths = stride(from: 0, to: intValues.count, by: 2)
            .reduce(into: []) { $0.append((intValues[$1], intValues[$1 + 1])) }
        
        return inputPaths
    }
}

//
//  OutputParser.swift
//  Pizzabot
//
//  Created by Islom Babaev on 16/11/21.
//


public final class OutputParser {
    public static func convertDirectionsIntoPathString(_ directions: [Direction]) -> String {
        var path = ""
        directions.forEach { direction in
            switch direction {
            case .east:
                path += "E"
            case .west:
                path += "W"
            case .north:
                path += "N"
            case .south:
                path += "S"
            case .drop:
                path += "D"
            }
        }
        return path
    }
}

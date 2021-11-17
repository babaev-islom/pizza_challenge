//
//  Environment.swift
//  Pizzabot
//
//  Created by Islom Babaev on 16/11/21.
//

public protocol Environment {
    var botMoves : [Direction] { get }
    var mapSize : Int { get }
    var inputPaths : [(Int,Int)] { get }
    
    init(input: String) throws
    func startBot() throws
}

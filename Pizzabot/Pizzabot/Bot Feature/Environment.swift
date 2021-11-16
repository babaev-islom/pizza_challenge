//
//  Environment.swift
//  Pizzabot
//
//  Created by Islom Babaev on 16/11/21.
//

protocol Environment {
    var numberOfIterations : Int { get }
    var botMoves : [Direction] { get }
    
    init(input: String) throws
    func startBot() throws
}

//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Owi Lover on 6/24/24.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(resultOf game: GameResult)
    func getStatistic(of game: GameResult) -> String
}

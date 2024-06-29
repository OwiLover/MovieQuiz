//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Owi Lover on 6/28/24.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    
    enum Keys: String {
        case correctCount = "correctCount"
        case questionsCount = "questionsCount"
        case bestGame = "bestGame"
        case gamesCount = "gamesCount"
        case dateGuess = "dateGuess"
        case totalGuess = "totalGuess"
        case correctGuess = "correctGuess"
    }
    
    private let storage: UserDefaults = .standard
    
    private var correctAnswers: Int {
        get {
            storage.integer(forKey: Keys.correctCount.rawValue)
        }
        set (value){
            storage.set(value, forKey: Keys.correctCount.rawValue)
        }
    }
    
    private var questionsCount: Int {
        get {
            storage.integer(forKey: Keys.questionsCount.rawValue)
        }
        set (value){
            storage.set(value, forKey: Keys.questionsCount.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set (value){
            storage.set(value, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct: Int = storage.integer(forKey: Keys.correctGuess.rawValue)
            let total: Int = storage.integer(forKey: Keys.totalGuess.rawValue)
            let date: Date = storage.object(forKey: Keys.dateGuess.rawValue) as? Date ?? Date()
            
            let gameResult: GameResult = GameResult(correct: correct, total: total, date: date)
            
            return gameResult
        }
        set (gameResult){
            storage.set(gameResult.correct, forKey: Keys.correctGuess.rawValue)
            storage.set(gameResult.total, forKey: Keys.totalGuess.rawValue)
            storage.set(gameResult.date, forKey: Keys.dateGuess.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        if questionsCount == 0 {
            return -1
        }
        return (Double(correctAnswers)/Double(questionsCount))*100
    }
    
    func store(resultOf game: GameResult) {
        self.correctAnswers+=game.correct
        self.questionsCount+=game.total
        self.gamesCount+=1
        if game.isBetter(than: self.bestGame) {
            self.bestGame = game
        }
    }
    
    func getStatistic(of game: GameResult) -> String {
        return """
        Ваш результат: \(game.correct)/\(game.total)
        Количество сыгранных квизов: \(gamesCount)
        Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
        Средняя точность: \(Decimal(totalAccuracy))%
        """
        
    }
}

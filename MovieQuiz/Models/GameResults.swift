//
//  GameResults.swift
//  MovieQuiz
//
//  Created by Owi Lover on 6/24/24.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetter(than model: GameResult) -> Bool {
        return self.correct>model.correct
    }
    
    init(correct: Int, total: Int) {
        self.correct = correct
        self.total = total
        self.date = Date()
    }
    
    init(correct: Int, total: Int, date: Date) {
        self.correct = correct
        self.total = total
        self.date = date
    }
}

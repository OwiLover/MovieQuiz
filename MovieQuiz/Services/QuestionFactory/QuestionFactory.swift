//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Owi Lover on 6/21/24.
//

import Foundation


final class QuestionFactory: QuestionFactoryProtocol {
    
    private var movies: [MostPopularMovie] = []
    
    private weak var delegate: QuestionFactoryDelegate?
    
    private var moviesLoader: MoviesLoadingProtocol?
    
    func loadData() {
        guard let moviesLoader else { return }
        
        moviesLoader.loadMovies { [weak self]
            data in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch data {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.moviesArray
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadDataFromServer(error: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async {
            [weak self] in
            guard let self = self else { return }
            
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData: Data = Data()
            
            do {
                imageData = try Data(contentsOf: movie.imageURL)
            }
            catch {
                DispatchQueue.main.async {
                    [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didFailToLoadDataFromServer(error: error)
                }
            }
            let rating = movie.rating
            
            let questionRating = (6..<10).randomElement() ?? 0
            
            let text = "Рейтинг этого фильма больше чем \(questionRating)?"
            
            let correctAnswer = rating > Float(questionRating)
            
            let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
            DispatchQueue.main.async {
                [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }

    }
    
    func setup(moviesLoader: MoviesLoadingProtocol, delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }
}

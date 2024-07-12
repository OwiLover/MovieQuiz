//
//  MoviesLoadingProtocol.swift
//  MovieQuiz
//
//  Created by Owi Lover on 7/12/24.
//

import Foundation

protocol MoviesLoadingProtocol {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

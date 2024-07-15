//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Owi Lover on 7/12/24.
//

import Foundation

struct MoviesLoader: MoviesLoadingProtocol {
    private let networkClient = NetworkClient()
    var mostPopularMoviesURL: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
            }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesURL) { data in
            switch data {
                case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                }
                catch {
                    handler(.failure(error))
                }
                case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}

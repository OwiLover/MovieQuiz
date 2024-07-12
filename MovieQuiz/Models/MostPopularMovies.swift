//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Owi Lover on 7/11/24.
//

import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String
    let moviesArray: [MostPopularMovie]
    
    enum CodingKeys: String, CodingKey {
        case moviesArray = "items"
        case errorMessage
    }
}

struct MostPopularMovie: Codable {
    let title: String
    let imageURL: URL
    let rating: Float
    
    enum Errors: Error {
        case initFailure
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case imageURL = "image"
        case rating = "imDbRating"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try container.decode(String.self, forKey: .title)
        self.imageURL = try {
            let url = try container.decode(URL.self, forKey: .imageURL)
            let urlString = url.absoluteString
            let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
            
            guard let newURL = URL(string: imageUrlString) else {
                return url
            }
            return newURL
        }()
        
        
        let ratingString = try container.decode(String.self, forKey: .rating)
        
        guard let rating = Float(ratingString) else {
            throw Errors.initFailure
        }
        self.rating = rating
    }
}

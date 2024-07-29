//
//  NetworkRoutingProtocol.swift
//  MovieQuiz
//
//  Created by Owi Lover on 7/18/24.
//

import Foundation

protocol NetworkRoutingProtocol {
    func fetch(url: URL, handler: @escaping (Result<Data,Error>) -> Void)
}

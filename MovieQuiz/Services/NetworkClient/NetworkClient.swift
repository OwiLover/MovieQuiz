//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Owi Lover on 7/11/24.
//

import Foundation

/// Отвечает за загрузку данных по URL
struct NetworkClient {

    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверяем, пришла ли ошибка
            if let error = error {
//                print("well, here we go again")
                handler(.failure(error))
                return
            }
            
            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
//                print("bad response!")
                return
            }
            
            // Возвращаем данные
//            print("Data Loaded!")
            guard let data = data else { return }
            
            handler(.success(data))
        }
        
        task.resume()
    }
}

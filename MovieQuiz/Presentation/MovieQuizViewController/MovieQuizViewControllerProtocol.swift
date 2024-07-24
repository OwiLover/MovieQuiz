//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Owi Lover on 7/24/24.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func showImageBorder(isCorrectAnswer: Bool)
    func hideImageBorder()
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}

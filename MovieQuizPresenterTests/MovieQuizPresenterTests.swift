//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Owi Lover on 7/24/24.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
        
    }
    
    func show(quiz result: MovieQuiz.QuizResultsViewModel) {
        
    }
    
    func showImageBorder(isCorrectAnswer: Bool) {
        
    }
    
    func hideImageBorder() {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func showNetworkError(message: String) {
        
    }
}

final class MovieQuizPresenterTests: XCTestCase {

    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let presenter = MovieQuizPresenter(viewController: viewControllerMock, statisticService: StatisticService())
        
        let data = Data()

        let question = QuizQuestion(image: data, text: "Some text", correctAnswer: true)
        let convertedModel = presenter.convert(model: question)
        
        XCTAssertNotNil(convertedModel.image)
        XCTAssertEqual(convertedModel.question, "Some text")
        XCTAssertEqual(convertedModel.questionNumber, "1/10")
    }
}

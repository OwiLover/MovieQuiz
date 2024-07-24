//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Owi Lover on 7/24/24.
//

import UIKit

final class MovieQuizPresenter {
    
    let questionsAmount: Int = 10
    
    private var currentQuestionIndex: Int = 0
 
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let quizStepViewModel = QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return quizStepViewModel
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount-1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func nextQuestionIndex() {
        currentQuestionIndex += 1
    }
}



//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Owi Lover on 6/23/24.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}

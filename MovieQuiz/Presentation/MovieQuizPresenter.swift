//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Owi Lover on 7/24/24.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    let questionsAmount: Int = 10
    
    private var currentQuestionIndex: Int = 0
    
    private var correctAnswers: Int = 0
    
    private var currentQuestion: QuizQuestion?
    
    private var questionFactory: QuestionFactoryProtocol?
    
    private var statisticService: StatisticServiceProtocol?
    
    weak var viewController: MovieQuizViewController?
    
    init(statisticService: StatisticServiceProtocol) {
        self.statisticService = statisticService
        self.questionFactory = QuestionFactory()
        self.questionFactory?.setup(moviesLoader: MoviesLoader(), delegate: self)
    }
 
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let quizStepViewModel = QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return quizStepViewModel
    }
    
    func showNextQuestionOrResults() {
        if isLastQuestion() {
            guard let statisticService else { return }
            let gameResult: GameResult = GameResult(correct: correctAnswers, total: questionsAmount)
            statisticService.store(resultOf: gameResult)
            
            let title = "Раунд окончен!"
            let text = statisticService.getStatistic(of: gameResult)
            let results = QuizResultsViewModel(title: title, text: text, buttonText: "Сыграть ещё раз")
            
            viewController?.show(quiz: results)
        } else {
            nextQuestionIndex()
            requestNextQuestion()
        }
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount-1
    }
    
    private func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    private func nextQuestionIndex() {
        currentQuestionIndex += 1
    }
    
    private func setCurrentQuestion(question: QuizQuestion) {
        currentQuestion = question
    }
    
    private func resetCorrectAnswers() {
        correctAnswers = 0
    }
    
    func checkCorrectAnswer(isCorrect: Bool) {
        correctAnswers += isCorrect ? 1 : 0
    }
    
    private func resetIndexAndCorrectAnswers() {
        resetQuestionIndex()
        resetCorrectAnswers()
    }
    
    func noButtonTouchUpInside() {
        didAnswer(answer: false)
    }
    
    func yesButtonTouchUpInside() {
        didAnswer(answer: true)
    }
    
    private func didAnswer(answer: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        viewController?.showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        setCurrentQuestion(question: question)
        
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.hideLoadingIndicator()
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadDataFromServer(error: any Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func restartGame() {
        resetIndexAndCorrectAnswers()
        requestNextQuestion()
    }
    
    func resetGame() {
        resetIndexAndCorrectAnswers()
        loadData()
    }
    
    func loadData() {
        questionFactory?.loadData()
    }
    
    func requestNextQuestion() {
        viewController?.showLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
}



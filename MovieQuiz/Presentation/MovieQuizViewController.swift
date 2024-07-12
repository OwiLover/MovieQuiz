import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var currentQuestionIndex = 0
    
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol?
    
    private var alertPresenter: AlertPresenterProtocol?
    
    private var currentQuestion: QuizQuestion?
    
    private var statisticService: StatisticServiceProtocol?
        
    @IBOutlet private weak var noButton: UIButton!
    
    @IBOutlet private weak var movieImageView: UIImageView!
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private weak var questionLabel: UILabel!
    
    @IBOutlet private weak var questionHeaderLabel: UILabel!
    
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showLoadingIndicator()
        
        let moviesLoader = MoviesLoader()
        
        let questionFactory = QuestionFactory()
        
        questionFactory.setup(moviesLoader: moviesLoader, delegate: self)
        
        self.questionFactory = questionFactory
        
        self.questionFactory?.loadData()
        
        self.statisticService = StatisticService()
        
        movieImageView.layer.masksToBounds = true
        movieImageView.layer.cornerRadius = 20
        
        scoreLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        questionHeaderLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        
        noButton.tintColor = .clear
        yesButton.tintColor = .clear
        
        questionFactory.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadDataFromServer(error: any Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    
    // MARK: - AlertPresenterDelegate
//     Реализация функции протокола делегата не удалена для лучшего понимания заданного вопроса,
//     который подробно расписан в AlertPresenterDelegate.swift
//
//    func didReceiveAlert(alert: UIAlertController?) {
//        guard let alert = alert else { return }
//        present(alert, animated: true, completion: nil)
//    }
//    
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertPresenter = AlertPresenter()
        
        let title: String = "Что-то пошло не так("
        let buttonText: String = "Попробовать еще раз"
        
        let alert: AlertModel = AlertModel(title: title, message: message, buttonText: buttonText) {
            [weak self] in
                guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.loadData()
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter.setup(delegate: self)
        self.alertPresenter = alertPresenter
        
        alertPresenter.presentAlert(alert: alert)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let quizStepViewModel = QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return quizStepViewModel
    }
    
    private func show(quiz step: QuizStepViewModel) {
        movieImageView.image = step.image
        questionLabel.text = step.question
        scoreLabel.text = step.questionNumber
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        
        let alertPresenter = AlertPresenter()
        
        let alert: AlertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] in
            guard let self = self else {
                return
            }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter.setup(delegate: self)
        self.alertPresenter = alertPresenter
        
        alertPresenter.presentAlert(alert: alert)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        movieImageView.layer.borderWidth = 8
        
        movieImageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        correctAnswers += isCorrect ? 1 : 0
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            
            guard let self = self else {
                return
            }
            self.showNextQuestionOrResults()
            self.movieImageView.layer.borderWidth = 0
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            
            guard let statisticService else { return }
            let gameResult: GameResult = GameResult(correct: correctAnswers, total: questionsAmount)
            statisticService.store(resultOf: gameResult)
            
            let title = "Раунд окончен!"
            let text = statisticService.getStatistic(of: gameResult)
            let results = QuizResultsViewModel(title: title, text: text, buttonText: "Сыграть ещё раз")
            
            show(quiz: results)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    @IBAction private func noButtonTouchUpInside(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonTouchUpInside(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
}

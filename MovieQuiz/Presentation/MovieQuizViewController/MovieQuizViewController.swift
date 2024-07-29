import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var alertPresenter: AlertPresenterProtocol?
    
    private var presenter: MovieQuizPresenter?
        
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
        
        presenter = MovieQuizPresenter(viewController: self, statisticService: StatisticService())
        
        presenter?.loadData()
        
        movieImageView.layer.masksToBounds = true
        movieImageView.layer.cornerRadius = 20
        
        scoreLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        questionHeaderLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        
        noButton.tintColor = .clear
        yesButton.tintColor = .clear
    }
    
    // MARK: - AlertPresenterDelegate
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertPresenter = AlertPresenter()
        
        let title: String = "Что-то пошло не так("
        let buttonText: String = "Попробовать еще раз"
        
        let alert: AlertModel = AlertModel(title: title, message: message, buttonText: buttonText) {
            [weak self] in
                guard let self = self else { return }
            presenter?.resetGame()
        }
        
        alertPresenter.setup(delegate: self)
        self.alertPresenter = alertPresenter
        
        alertPresenter.presentAlert(alert: alert)
    }
    
    func show(quiz step: QuizStepViewModel) {
        movieImageView.image = step.image
        questionLabel.text = step.question
        scoreLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let alertPresenter = AlertPresenter()
        
        let alert: AlertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] in
            guard let self = self else {
                return
            }
            presenter?.restartGame()
        }
        
        alertPresenter.setup(delegate: self)
        self.alertPresenter = alertPresenter
        
        alertPresenter.presentAlert(alert: alert)
    }
    
    func showImageBorder(isCorrectAnswer: Bool) {
        movieImageView.layer.borderWidth = 8
        
        movieImageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    func hideImageBorder() {
        movieImageView.layer.borderWidth = 0
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    @IBAction private func noButtonTouchUpInside(_ sender: Any) {
        presenter?.noButtonTouchUpInside()
    }
    
    @IBAction private func yesButtonTouchUpInside(_ sender: Any) {
        presenter?.yesButtonTouchUpInside()
    }
}

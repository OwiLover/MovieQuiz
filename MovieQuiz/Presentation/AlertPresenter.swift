//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Owi Lover on 6/23/24.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: UIViewController?
    
    func presentAlert(alert: AlertModel) {
        let alertController = UIAlertController(title: alert.title,
                                      message: alert.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: alert.buttonText, style: .default) { _ in
            alert.completion()
        }
        alertController.addAction(action)
        alertController.view.accessibilityIdentifier = "Alert"
        delegate?.present(alertController, animated: true, completion: nil)
    }
    
    func setup(delegate: UIViewController) {
        self.delegate = delegate
    }
}

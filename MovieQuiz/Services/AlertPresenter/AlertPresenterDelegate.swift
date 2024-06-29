//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Owi Lover on 6/23/24.
//

//import Foundation
//import UIKit

// Изначально была идея создать полноценный протокол Делегата,
// присвоить его MovieQuizViewController и реализовать функцию didRecieveAlert
// Однако меня смутило, что в задании говорится отдать показ уведомления AlertPresenter
// С данным подходом получается, что AlertPresenter создаёт Алёрт,
// но в итоге реализация показа всё ещё в файле MovieQuizViewController
// Мне интересно,являлся ли такой подход с протоколом верным?

//protocol AlertPresenterDelegate: AnyObject {
//    func didReceiveAlert(alert: UIAlertController?)
//}

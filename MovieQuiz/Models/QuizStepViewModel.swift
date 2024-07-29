//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by Owi Lover on 6/21/24.
//
import UIKit

struct QuizStepViewModel {
    let imageData: Data
    let question: String
    let questionNumber: String
    var image: UIImage {
        let image = UIImage(data: imageData) ?? UIImage()
        return image
    }
}

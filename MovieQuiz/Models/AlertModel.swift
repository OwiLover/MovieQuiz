//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Owi Lover on 6/23/24.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (()->Void)
}

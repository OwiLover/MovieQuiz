//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Owi Lover on 7/20/24.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        
        try super.setUpWithError()

        app = XCUIApplication()
        
        app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        
        try super.tearDownWithError()

        app.terminate()
        app = nil
    }
    
    func testYesButtonPosterChange() throws {
        
        sleep(2)
        
        var questionNumber = app.staticTexts["QuestionNumber"]
        
        var questionNumberText = questionNumber.label
        
        XCTAssertTrue(questionNumberText == "1/10")
        
        let firstPoster = app.images["Poster"]
        
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        XCTAssertTrue(firstPoster.exists)
        
        app.buttons["Yes"].tap()
        
        sleep(2)
        
        questionNumber = app.staticTexts["QuestionNumber"]
        
        questionNumberText = questionNumber.label
        
        XCTAssertTrue(questionNumberText == "2/10")
        
        let secondPoster = app.images["Poster"]
        
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertTrue(secondPoster.exists)
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        
    }
    
    func testNoButton() throws {
        
        sleep(2)
        
        var questionNumber = app.staticTexts["QuestionNumber"]
        
        var questionNumberText = questionNumber.label
        
        XCTAssertTrue(questionNumberText == "1/10")
        
        let firstPoster = app.images["Poster"]
        
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        XCTAssertTrue(firstPoster.exists)
        
        app.buttons["No"].tap()
        
        sleep(2)
        
        questionNumber = app.staticTexts["QuestionNumber"]
        
        questionNumberText = questionNumber.label
        
        XCTAssertTrue(questionNumberText == "2/10")
        
        let secondPoster = app.images["Poster"]
        
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertTrue(secondPoster.exists)
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testDidShowAlert() throws {
        (0...9).forEach() { _ in
            sleep(2)
            app.buttons["Yes"].tap()
        }
        
        sleep(2)
        
        let alert = app.alerts["Alert"]
        
        XCTAssertTrue(alert.exists)
        
        let alertLabel = alert.label
        let buttonText = alert.buttons.firstMatch.label
        
        XCTAssertEqual(alertLabel, "Раунд окончен!")
        XCTAssertEqual(buttonText, "Сыграть ещё раз")
        
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        XCTAssertFalse(alert.exists)
        
        let questionNumber = app.staticTexts["QuestionNumber"]
        XCTAssertTrue(questionNumber.label == "1/10")
    }
    
}

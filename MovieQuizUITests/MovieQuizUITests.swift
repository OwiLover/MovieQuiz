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
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        
        app.launch()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
        app = nil
    }

//    func testExample() throws {
//        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
//
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        
//    }
    
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

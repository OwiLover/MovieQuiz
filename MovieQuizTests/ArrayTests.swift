//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Owi Lover on 7/18/24.
//

import Foundation
import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testInRange() {
        let array: Array = [0,1,2,3]
        
        let element = array[safe: 0]
        
        XCTAssertNotNil(element)
        XCTAssertEqual(element, 0)
    }
    
    func testOutRange() {
        let array: Array = [0,1,2,3]
        
        let element = array[safe: 5]
        
        XCTAssertNil(element)
    }
}

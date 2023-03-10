//
//  UtilitiesTest.swift
//  WeatherAppTests
//
//  Created by Andrew Ananda on 18/01/2023.
//

import XCTest
@testable import WeatherApp

final class UtilitiesTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
	
	func testDegrees() {
		let input = "20"
		let expectedOutput = "20°"
		XCTAssertEqual(input.toDegrees(), expectedOutput)
	}
	
	func testDayReturned() {
		let input = "2023-01-19 03:00:00"
		let expectedOutput = "Thursday"
		XCTAssertEqual(getFormatedDate(dateString: input), expectedOutput)
	}
	
	func testWeatherColorChange() {
		let expectedOutput = UIColor(named: "CloudyColor")
		XCTAssertEqual(getColor(weatherType: .cloudy), expectedOutput)
	}

}

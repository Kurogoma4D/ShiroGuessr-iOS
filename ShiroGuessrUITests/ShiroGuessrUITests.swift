//
//  ShiroGuessrUITests.swift
//  ShiroGuessrUITests
//
//  Created by Kurogoma4D on 2026/01/31.
//

import Testing
import XCTest

@Suite("ShiroGuessr UI Tests")
@MainActor
struct ShiroGuessrUITests {

    @Test("Launch app example")
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use #expect and related functions to verify your tests produce the correct results.
    }

    // Note: Performance testing with Swift Testing requires different approach
    // Keeping this test commented out for now as measure(metrics:) is not available in Swift Testing
    // @Test("Launch performance")
    // func testLaunchPerformance() throws {
    //     // This measures how long it takes to launch your application.
    //     // Swift Testing doesn't have built-in performance metrics yet
    // }
}

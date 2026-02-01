//
//  ShiroGuessrUITestsLaunchTests.swift
//  ShiroGuessrUITests
//
//  Created by Kurogoma4D on 2026/01/31.
//

import Testing
import XCTest

@Suite("ShiroGuessr UI Launch Tests")
@MainActor
struct ShiroGuessrUITestsLaunchTests {

    @Test("Launch app and capture screenshot")
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        // Note: XCTAttachment is part of XCTest and may not work seamlessly with Swift Testing
        // Consider using Swift Testing's attachment APIs when available
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        // Note: The `add(attachment)` method is XCTest-specific
        // Swift Testing handles attachments differently
    }
}

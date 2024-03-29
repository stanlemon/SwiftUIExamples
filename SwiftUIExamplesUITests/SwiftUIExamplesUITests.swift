//
//  SwiftUIExamplesUITests.swift
//  SwiftUIExamplesUITests
//
//  Created by Stan Lemon on 2/20/23.
//

import XCTest

final class SwiftUIExamplesUITests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testExport() throws {
    // UI tests must launch the application that they test.
    let app = XCUIApplication()
    app.launch()

    let fileExporterTab = app.tabBars.firstMatch
    XCTAssertTrue(fileExporterTab.waitForExistence(timeout: 5))
    fileExporterTab.tap()

    let fileExportButton = app.buttons["Export Items"]
    XCTAssertTrue(fileExportButton.waitForExistence(timeout: 5))
    fileExportButton.tap()

    let moveButton = app.buttons["Move"]
    XCTAssertTrue(moveButton.waitForExistence(timeout: 5))
    moveButton.tap()
  }
}

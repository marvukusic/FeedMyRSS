//
//  FeedMyRSSUITests.swift
//  FeedMyRSSUITests
//
//  Created by Marko Vukušić on 05.11.2024..
//

import XCTest

final class FeedMyRSSUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["-UITest"]
        app.launch()
    }

    override func tearDown() {
        app = nil
        
        super.tearDown()
    }

    @MainActor
    func testAddNewRSSFeed() {
        let feedURL = "https://feeds.bbci.co.uk/news/world/rss.xml"
        
        let cells = app.collectionViews["feedList"].cells
        for _ in 0..<cells.allElementsBoundByAccessibilityElement.count {
            cells.element(boundBy: 0).swipeLeft()
            app.otherElements.buttons["Delete"].firstMatch.tap()
        }
        XCTAssertTrue(cells.count == 0, "Feed list not empty")
   
        app.buttons["Add New Feed"].tap()
        XCTAssertTrue(app.alerts["Add new RSS feed"].exists, "Add new RSS feed alert did not appear")
        
        let urlTextField = app.textFields["URL"]
        XCTAssertTrue(urlTextField.exists, "URL text field did not appear")

        urlTextField.doubleTap()
        urlTextField.typeText(feedURL)
        app.alerts["Add new RSS feed"].buttons["OK"].tap()
        
        XCTAssertTrue(app.collectionViews["feedList"].cells.element(boundBy: 0).waitForExistence(timeout: 1))
    }
}

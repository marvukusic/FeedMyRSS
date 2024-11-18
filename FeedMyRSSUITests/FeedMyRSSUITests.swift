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
    func testAddAndDeleteNewRSSFeed() {
        let feedURL = "https://feeds.bbci.co.uk/news/world/rss.xml"
        
        /// Clear existing cells, if any
        let cells = app.collectionViews["feedList"].cells
        if cells.count > 0 {
            clearFeedList(cells: cells)
        }
        
        /// Open add new feed popup
        app.buttons["Add New Feed"].tap()
        XCTAssertTrue(app.alerts["Add new RSS feed"].exists, "Add new RSS feed alert did not appear")
        
        /// Delete any text in input field, if any
        let urlTextField = app.textFields["URL"]
        XCTAssertTrue(urlTextField.exists, "URL text field did not appear")
        if let fieldValue = urlTextField.value as? String {
            let deleteString = fieldValue.map({ _ in "\u{8}" }).joined()
            urlTextField.typeText(deleteString)
        }
        
        /// Write test URL in input field
        urlTextField.typeText(feedURL)
        
        /// Accept inserted URL
        app.alerts["Add new RSS feed"].buttons["OK"].tap()
        
        /// Check if feed was added to the list
        let addedCell = cells.element(boundBy: 0)
        XCTAssertTrue(addedCell.waitForExistence(timeout: 1))
        
        /// Clear feed list
        clearFeedList(cells: cells)
    }
    
    private func clearFeedList(cells: XCUIElementQuery) {
        for _ in 0..<cells.allElementsBoundByAccessibilityElement.count {
            cells.element(boundBy: 0).swipeLeft()
            app.otherElements.buttons["Delete"].firstMatch.tap()
        }
        XCTAssertTrue(cells.count == 0, "Feed list not empty")
    }
}

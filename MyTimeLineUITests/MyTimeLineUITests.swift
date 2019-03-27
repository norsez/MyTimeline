//
//  MyTimeLineUITests.swift
//  MyTimeLineUITests
//
//  Created by norsez on 27/3/19.
//  Copyright © 2019 Bluedot. All rights reserved.
//

import XCTest

class MyTimeLineUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
        try! SeedData.shared.resetAndSeed()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try! SeedData.shared.dropDatabase()
    }

    
    let tablesQuery = XCUIApplication().tables
    func testScrollingOfTimeline() {
        
        let app = XCUIApplication()
        app.navigationBars["Timeline"].buttons["Compose"].tap()
        app.navigationBars["New Post"].otherElements["New Post"].tap()
        XCTAssertTrue(app.navigationBars["New Post"].exists)
        
        
    }

}

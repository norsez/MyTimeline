//
//  MyTimeLineUITests.swift
//  MyTimeLineUITests
//
//  Created by norsez on 28/3/19.
//  Copyright © 2019 Bluedot. All rights reserved.
//

import XCTest
class MyTimeLineUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
        
    }

    override func tearDown() {
        
    }
    //MARK - test navigation path: compose a new post
    func testNavPathComposeNewPost() {
        
        let app = XCUIApplication()
        let timelineNavigationBar = app.navigationBars["Timeline"]
        //Timeline screen
        XCTAssertTrue( app.navigationBars["Timeline"].exists, "launch screen is Timeline")
        
        //Compose (New Pose) screen
        timelineNavigationBar.buttons["Compose"].tap()
        XCTAssertTrue( app.navigationBars["New Post"].exists, "tap compose must go to New Post screen")
        
        //tap Cancel must return
        XCUIApplication().navigationBars["New Post"].buttons["Cancel"].tap()
        XCTAssertTrue( app.navigationBars["Timeline"].exists, "tap Cancel returns to Timeline screen")
        
        //test create Compose (New Pose)
        timelineNavigationBar.buttons["Compose"].tap()
        XCTAssertTrue( app.navigationBars["New Post"].exists, "tap compose must go to New Post screen")
        let NEW_POST_BODY_TEXT = "\(Date()) My New Post"
        
        //test disable of the Create button
        app.textViews["body textview"].tap()
        app.navigationBars["New Post"].buttons["Create"].tap()
        XCTAssertTrue( app.navigationBars["New Post"].exists, "tap Create with empty text should do nothing")
        
        //test add a new post
        app.textViews["body textview"].typeText(NEW_POST_BODY_TEXT)
        app.navigationBars["New Post"].buttons["Create"].tap()
        XCTAssertTrue( app.navigationBars["Timeline"].exists, "tap Create returns to Timeline screen")
        
    }
    //MARK - test navigation path: see a post
    func testNavPathSeePost() {
        
        let app = XCUIApplication()
        let timelineNavigationBar = app.navigationBars["Timeline"]
        //Timeline screen
        XCTAssertTrue( timelineNavigationBar.exists, "launch screen is Timeline")
        
        //tap a post goes to "Post" screen
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        let postImageboxElement = cell.otherElements["post imageBox"]
        postImageboxElement.tap()
        XCTAssertTrue( app.navigationBars["Post"].exists, "tap a post in timeline goes to Post screen")
        
    }
    
    //MARK - test navigation path: view an in image in full screen
    func testViewingImageFullScreen() {
        let app = XCUIApplication()
        XCTAssertTrue( app.navigationBars["Timeline"].exists, "starts in Timeline screen")
        let tablesQuery = app.tables
        let firstImageTimeline = tablesQuery.children(matching: .cell).element(boundBy: 0).otherElements["post imageBox"]
        XCTAssertTrue(firstImageTimeline.exists, "test post image exists")
        
        firstImageTimeline.tap()
        
        //post screen
        let postNavBar = app.navigationBars["Post"]
        waitForExistence(on: postNavBar)
        XCTAssertTrue( postNavBar.exists, "Tapping first image must bring in Post screen")
        let firstImagePostScreen = tablesQuery.children(matching: .cell).element(boundBy: 1).images["post image"]
        XCTAssertTrue(firstImagePostScreen.exists, "first image exists on Post screen")
        
        //full image screen
        firstImagePostScreen.tap()
        let closebuttonFullScreenView = app.buttons["btn common close wh"]
        waitForExistence(on: closebuttonFullScreenView)
        XCTAssertTrue(closebuttonFullScreenView.exists, "Full Image view's Close button exists")
        
        closebuttonFullScreenView.tap()
        XCTAssertTrue( app.navigationBars["Post"].exists, "Close full image view returns to Post screen")
    }
    
    func testSearch() {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        let searchField = app.searchFields["Search"]
        app.swipeDown()
        waitForExistence(on: searchField)
        XCTAssertTrue(searchField.exists)
        app.searchFields["Search"].tap()
        
        searchField.typeText("ideal")
        let foundCell = app.tables/*@START_MENU_TOKEN@*/.staticTexts["post body"]/*[[".cells.staticTexts[\"post body\"]",".staticTexts[\"post body\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        waitForExistence(on: foundCell)
        
    }
    
    //MARK - wait for an element to appear on screen for x seconds.
    func waitForExistence(on object: Any) {
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: object, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}



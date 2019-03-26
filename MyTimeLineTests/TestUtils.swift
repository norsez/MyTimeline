//
//  TestUtils.swift
//  MyTimeLineTests
//
//  Created by norsez on 26/3/19.
//  Copyright © 2019 Bluedot. All rights reserved.
//

import XCTest

class TestUtils: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRandomString() {
        let LENGTH = 16
        let rs1 = String.randomString(withLength: LENGTH)
        let rs2 = String.randomString(withLength: LENGTH)
        XCTAssertEqual(LENGTH, rs1.count)
        XCTAssertEqual(LENGTH, rs2.count)
        XCTAssertNotEqual(rs1, rs2, "\(rs1) \(rs2) can't be equal")
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

//
//  TestUtils.swift
//  MyTimeLineTests
//
//  Created by norsez on 26/3/19.
//  Copyright © 2019 Bluedot. All rights reserved.
//

import XCTest
@testable import Pods_MyTimeLine
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
        XCTAssertEqual(LENGTH, rs1.count, "\(rs1) must be of size \(LENGTH)")
        XCTAssertEqual(LENGTH, rs2.count, "\(rs2) must be of size \(LENGTH)")
        XCTAssertNotEqual(rs1, rs2, "\(rs1) \(rs2) can't be equal")
        
    }
    
    func testTrimmedEmpty() {
        XCTAssertTrue("".isTrimmedEmpty)
        XCTAssertTrue(" ".isTrimmedEmpty)
        XCTAssertTrue(" \n\t\r".isTrimmedEmpty)
        XCTAssertTrue(" \t\t".isTrimmedEmpty)
        XCTAssertTrue("\n\n \n\t".isTrimmedEmpty)
        XCTAssertFalse("1".isTrimmedEmpty)
        XCTAssertFalse("11".isTrimmedEmpty)
        XCTAssertFalse(" 1".isTrimmedEmpty)
        XCTAssertFalse("1 ".isTrimmedEmpty)
        XCTAssertFalse("1 \n 1".isTrimmedEmpty)
        XCTAssertFalse("\n\n1 \n\t".isTrimmedEmpty)
        XCTAssertFalse("\n1\n1\n".isTrimmedEmpty)
    }
    
    func date24hour(with hour: Int, minute: Int) -> Date {
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        return cal.date(bySettingHour: hour, minute: minute, second: 0, of: Date())!
    }
    
    func testTimelineTimeDateFormat () {
        
        var expected = "8:00 AM"
        var toTest = date24hour(with: 8, minute: 0).asTimelineTime
        XCTAssertEqual("AM", expected.suffix(2), "format a is incorrect")
        XCTAssertEqual(expected.count, toTest.count, "length of \(toTest) and \(expected) must be equal")
        
        expected = "8:00 PM"
        toTest = date24hour(with: 20, minute: 0).asTimelineTime
        XCTAssertEqual("PM", toTest.suffix(2), "format a is incorrect")
        XCTAssertEqual(expected.count, toTest.count, "length of \(toTest) and \(expected) must be equal")
        
    }
}

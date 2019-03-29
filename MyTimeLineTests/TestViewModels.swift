//
//  MyTimeLineTests.swift
//  MyTimeLineTests
//
//  Created by norsez on 26/3/19.
//  Copyright © 2019 Bluedot. All rights reserved.
//

import XCTest
@testable import MyTimeLine
import RealmSwift
class TestViewModels: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testComposeViewModel() {
        let cvm = ComposeViewModel()
        
        cvm.bodyText.value = nil
        XCTAssertEqual(false, cvm.validatePost(), "nil text fails validation.")
        
        cvm.bodyText.value = ""
        XCTAssertEqual(false, cvm.validatePost(), "empty text fails validation.")
        
        cvm.bodyText.value = "  "
        XCTAssertEqual(false, cvm.validatePost(), "trimmed empty text fails validation.")
        
        cvm.bodyText.value = "\n\n "
        XCTAssertEqual(false, cvm.validatePost(), "trimmed empty text fails validation.")
        
        cvm.bodyText.value = "Hello World."
        XCTAssertEqual(true, cvm.validatePost(), "Some text will pass validation")
        
    }
    
    func testModelCRUD() {
        let post = Post()
        let TEXT_BODY = "test text body at time: \(Date())"
        post.body = TEXT_BODY
        
        do {
            let realm = RealmProvider.realm()
            try realm.write {
                realm.add(post)
                
            }
            
            let searchResults = realm.objects(Post.self).filter { (p) -> Bool in
                return (p.body ?? "").contains(TEXT_BODY)
            }
            XCTAssertEqual(1, searchResults.count, "saved post must be searable by its body text")
            XCTAssertEqual(TEXT_BODY, searchResults.first!.body, "saved post must have its body text")
            
            
            
        }catch {
            XCTAssertTrue(false, "create and find Post must work. \(error) ")
        }
        
    }

}

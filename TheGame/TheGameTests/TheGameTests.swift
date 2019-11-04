//
//  TheGameTests.swift
//  TheGameTests
//
//  Created by Juergen Boiselle on 02.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import XCTest
@testable import TheGame

class TheGameTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAfterInit() {
        XCTAssert(activeSheet.current == .OffLevel, "After init == .OffLevel")
    }
    
    func testInsertDel() {
        activeSheet.next(.InLevel)
        XCTAssertEqual(activeSheet.current, .InLevel, "next .InLevel")
        activeSheet.next(.Store)
        XCTAssertEqual(activeSheet.current, .Store, "next .Store")
        activeSheet.back()
        XCTAssertEqual(activeSheet.current, .InLevel, "back -> .InLevel")
    }

    func testMaxDepth() {
        activeSheet.next(.InLevel)
        activeSheet.next(.InLevel)
        activeSheet.next(.InLevel)
        activeSheet.next(.InLevel)
        activeSheet.next(.InLevel)
        activeSheet.next(.InLevel)
        activeSheet.back()
        activeSheet.back()
        activeSheet.back()
        activeSheet.back()
        XCTAssertEqual(activeSheet.current, .OffLevel, "maxDepth reached, default to .OffLevel")
    }
    
    var x1 = 0
    var x2 = 0
    
    func testSegue() {
        let aOI = {self.x1 = 1}
        let aIO = {self.x2 = 1}
        
        activeSheet.segue(from: [.OffLevel], to: [.InLevel], action: aOI)
        activeSheet.segue(from: [.InLevel], to: [.OffLevel], action: aIO)
        
        activeSheet.next(.InLevel)
        XCTAssertEqual(x1, 1, "aOI executed")
        activeSheet.back()
        XCTAssertEqual(x2, 1, "aIO executed")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

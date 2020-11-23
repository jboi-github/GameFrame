//
//  GameFrameGCTests.swift
//  GameFrameTests
//
//  Created by Jürgen Boiselle on 21.11.20.
//  Copyright © 2020 Juergen Boiselle. All rights reserved.
//

import XCTest
import GameFrameKit
import GameKit

class GameFrameGCTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        GameFrame.createSharedInstance(
            purchasables: [String : [GFInApp.Purchasable]](),
            adUnitIdBanner: nil, adUnitIdRewarded: nil,
            adUnitIdInterstitial: nil, adNonCosumableId: nil,
            appId: "APP-ID", infos: [GFShareInformation](), greeting: nil,
            doNotAskFirstBefore: 0, doNotAskAgainBefore: 0,
            keyUserDefaultDisabled: "", keyUserDefaultRuns: "", keyUserDefaultLastAsk: "")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGCLoggedIn() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let e = XCTestExpectation(description: "Just to run into timeout while waiting")
        e.isInverted = true
        print("A")
        wait(for: [e], timeout: 5)
        print("B")

        XCTAssertTrue(GKLocalPlayer.local.isAuthenticated, "Should be logged in")
        XCTAssertTrue(GameFrame.gameCenter.enabled, "Should be enabled")
    }
}

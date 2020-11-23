//
//  GameFrameTests.swift
//  GameFrameTests
//
//  Created by Jürgen Boiselle on 18.11.20.
//  Copyright © 2020 Juergen Boiselle. All rights reserved.
//

import XCTest
import GameFrameKit

class GameFrameReviewTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        UserDefaults.standard.removeObject(forKey: "A")
        UserDefaults.standard.removeObject(forKey: "B")
        UserDefaults.standard.removeObject(forKey: "C")
        
        GameFrame.createSharedInstance(
            purchasables: [String : [GFInApp.Purchasable]](),
            adUnitIdBanner: nil, adUnitIdRewarded: nil,
            adUnitIdInterstitial: nil, adNonCosumableId: nil,
            appId: "APP-ID", infos: [GFShareInformation](), greeting: nil,
            doNotAskFirstBefore: 2, doNotAskAgainBefore: 3,
            keyUserDefaultDisabled: "A", keyUserDefaultRuns: "B", keyUserDefaultLastAsk: "C")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        GameFrame.review.dismiss(playersReviewResponse: .DontTryAgain)
    }

    private func runSome(_ i: Int) {
        var request = true
        for j in 0..<i {
            GameFrame.instance.leaveLevel(requestReview: request, showInterstitial: false)
            XCTAssertFalse(GameFrame.review.shown, "Should stay false after \(j)")
            request.toggle()
        }
    }

    func testReviewFirst() throws {
        XCTAssertFalse(GameFrame.review.shown, "Should start with false")
        runSome(2)
        GameFrame.instance.leaveLevel(requestReview: true, showInterstitial: false)
        XCTAssertTrue(GameFrame.review.shown, "Should be shown now")
    }

    
    func testReviewTryAgain() throws {
        runSome(2)
        GameFrame.instance.leaveLevel(requestReview: true, showInterstitial: false)
        XCTAssertTrue(GameFrame.review.shown, "Should be shown now")
        
        GameFrame.review.dismiss(playersReviewResponse: .TryAgain)
        XCTAssertFalse(GameFrame.review.shown, "Should be gone")
        
        runSome(3)
        GameFrame.instance.leaveLevel(requestReview: true, showInterstitial: false)
        XCTAssertTrue(GameFrame.review.shown, "Should be shown again")
    }

    func testReviewDontTryAgain() throws {
        runSome(2)
        GameFrame.instance.leaveLevel(requestReview: true, showInterstitial: false)
        XCTAssertTrue(GameFrame.review.shown, "Should be shown now")
        
        GameFrame.review.dismiss(playersReviewResponse: .DontTryAgain)
        XCTAssertFalse(GameFrame.review.shown, "Should be gone")
        
        runSome(30) // Should not come back in any way
    }

    func testReviewWantReview() throws {
        runSome(2)
        GameFrame.instance.leaveLevel(requestReview: true, showInterstitial: false)
        XCTAssertTrue(GameFrame.review.shown, "Should be shown now")
        
        GameFrame.review.dismiss(playersReviewResponse: .WantReview)
        XCTAssertFalse(GameFrame.review.shown, "Should be gone")
        
        runSome(30) // Should not come back in any way
    }
}

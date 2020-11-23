//
//  GFReview.swift
//  GameFrameKit
//
//  Created by Jürgen Boiselle on 20.11.20.
//  Copyright © 2020 Juergen Boiselle. All rights reserved.
//

import Foundation

/**
 Handling reviews by ommitting overcontacting. A published flag indicates, if the review dialog should be shown.
 - Omit calls for the first n runs
 - Omit calls after asking the user with answer "try again later" for a number of runs
 - Omit calls forever, if player answered to not being contacted any more
 */
public class GFReview: ObservableObject {
    // MARK: - Initializaton
    internal init(appId: String,
                  doNotAskFirstBefore: Int, doNotAskAgainBefore: Int,
                  keyUserDefaultDisabled: String, keyUserDefaultRuns: String, keyUserDefaultLastAsk: String) {
        self.appId = appId
        self.doNotAskFirstBefore = doNotAskFirstBefore
        self.doNotAskAgainBefore = doNotAskAgainBefore
        self.keyUserDefaultDisabled = keyUserDefaultDisabled
        self.keyUserDefaultRuns = keyUserDefaultRuns
        self.keyUserDefaultLastAsk = keyUserDefaultLastAsk
    }
    
    // MARK: - Public functions and properties
    /// If `true` the review UI can be shown. If `false` it should not be visible.
    @Published public private(set) var shown: Bool = false
    
    /// Possible repsonses of the player when asked for review. See @dismiss for effects of each response.
    public enum PlayersReviewResponse {
        case TryAgain, DontTryAgain, WantReview
    }
    
    /// Call this when dismissing the review question to player. The answer given is stored and influences future calls for reviews. It also unsets the `shown` parameter such that a SwiftUI Gui can use this flag to appear or disappear.
    /// - Parameter playersReviewResponse: Is one of
    ///   - `DontTryAgain`: Info is stored on device and future calls for review will be ignored.
    ///   - `TryAgain`: The player will be asked earliest in `doNotAskAgainBefore` config parameter times
    ///   - `WantReview`: This opens the Apple-Stores Review-Page for your App, as given by `appId`. The user is not asked for review again.
    public func dismiss(playersReviewResponse: PlayersReviewResponse) {
        log(playersReviewResponse)
        
        switch playersReviewResponse {
        case .DontTryAgain:
            UserDefaults.standard.set(true, forKey: keyUserDefaultDisabled)
        case .TryAgain:
            UserDefaults.standard.set(
                UserDefaults.standard.integer(forKey: keyUserDefaultRuns),
                forKey: keyUserDefaultLastAsk)
        case .WantReview:
            UserDefaults.standard.set(true, forKey: keyUserDefaultDisabled)
            getUrlAction(getReviewUrl(appId: appId))()
        }
        shown.unset()
    }
    
    // MARK: - Internal handling
    private let appId: String
    private let doNotAskFirstBefore: Int
    private let doNotAskAgainBefore: Int
    private let keyUserDefaultDisabled: String
    private let keyUserDefaultRuns: String
    private let keyUserDefaultLastAsk: String
    
    /// Called when level is left for whatever reason and regardless if a request should be shown or not.
    /// Note, that the question for review is only shown, if:
    /// - The player did not give a review before
    /// - The player did not say to not ask again
    /// - The parameter `requestReview`is `true`
    /// - The number of runs is more then `doNotAskFirstBefore`
    /// - The number of runs since the user gave a `.TryAgain` is more then `doNotAskAgainBefore`
    /// - Parameter requestReview: `true` if the programmer would like to show question for review,
    /// e.g. because it is expected that the player is in good mood. `false` to not show a question for review.
    func leaveLevel(requestReview: Bool) {
        log(requestReview)

        // If not enabled, get out
        let enabled = !UserDefaults.standard.bool(forKey: keyUserDefaultDisabled)
        guard enabled else {return}

        // Increment runs
        let runs = UserDefaults.standard.integer(forKey: keyUserDefaultRuns) + 1
        UserDefaults.standard.set(runs, forKey: keyUserDefaultRuns)
        
        // Should review be shown this time?
        guard requestReview else {return}
        
        guard runs > doNotAskFirstBefore else {return}
        
        let lastAsk = UserDefaults.standard.integer(forKey: keyUserDefaultLastAsk)
        guard lastAsk == 0 || runs > lastAsk + doNotAskAgainBefore else {return}
        
        shown.set()
    }
}

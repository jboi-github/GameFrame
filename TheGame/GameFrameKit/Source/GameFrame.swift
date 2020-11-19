//
//  GameFrame.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 28.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import StoreKit
import Combine

#warning ("TODO: Test with sandbox user")
#warning ("TODO: Purchase Simple purchase")
#warning ("TODO: Purchase Deferred purchase")
#warning ("TODO: Purchase Failed, simple purchase")
#warning ("TODO: Purchase Restore: Calls purchaed again?")
#warning ("TODO: Automated Test Cases - Unit tests -> 3 Tage")
#warning ("TODO: Automated Test Cases - UI Tests -> 3 Tage")
#warning ("TODO: Design Game -> LONG")
#warning ("TODO: define products, Ads, leaderboards, achievements -> 2 Tag")
#warning ("TODO: Setup Views for Store, Settings, Offers, Main (without GameZone), Launchscreen -> 5 Tage")
#warning ("TODO: Create external links to community of Instagram, Twitter, Facebook -> 3 Tag")
#warning ("TODO: What about Data Privacy Statement??? -> 2 Tage")
#warning ("TODO: Build Game Engine in GameZone -> LONG")

/**
 GameFrame is the central object to work with the GameFrame-Framework.
 - To initialize it, replace some code in the `SceneDelegate.swift`
 - For details, features and usage, see the `ReadMe` file in Github.
 
 The class does extensive logging. Any log message is lead by a "GF" to mark it as GameFrame logging.
*/
public class GameFrame: NSObject {
    // MARK: - Initializaton
    public private(set) static var instance: GameFrame!
    public static var coreData: GFCoreDataCloudKit {GameFrame.instance.coreDataImpl}
    public static var gameCenter: GFGameCenter {GameFrame.instance.gameCenterImpl}
    public static var inApp: GFInApp {GameFrame.instance.inAppImpl}
    public static var adMob: GFAdMob {GameFrame.instance.adMobImpl}
    public static var share: GFShare {GameFrame.instance.shareImpl}
    public static var audio: GFAudio {GameFrame.instance.audioImpl}

    internal private(set) var coreDataImpl: GFCoreDataCloudKit!
    internal private(set) var gameCenterImpl: GFGameCenter!
    internal private(set) var inAppImpl: GFInApp!
    internal private(set) var adMobImpl: GFAdMob!
    internal private(set) var shareImpl: GFShare!
    internal private(set) var audioImpl: GFAudio!

    /**
     Create the shared instance of GameFrame and does the setup of a scene for `SceneDelegate`
     Replace the content of `func scene` in `SceneDelegate.swift` with a call to this function.
      - Parameter scene:            The `scene` parameter, given in the scene call in SceneDelegate
      - Parameter consumablesConfig: Associates consumables with products in store. Check GFInAppImpl for explanation and examples.
      - Parameter makeContentView:  A closure that builds the main view. It can already make use of `GameFrame`, e.g. to get Achievements, Scores, Consumables or NonConsumables and apss them to the view.
     */
    public class func createSharedInstance(
        purchasables: [String: [GFInApp.Purchasable]],
        adUnitIdBanner: String?,
        adUnitIdRewarded: String?,
        adUnitIdInterstitial: String?,
        adNonCosumableId: String?,
        appId: Int,
        infos: [GFShareInformation],
        greeting: String?)
    {
        instance = GameFrame(
            purchasables: purchasables,
            adUnitIdBanner: adUnitIdBanner,
            adUnitIdRewarded: adUnitIdRewarded,
            adUnitIdInterstitial: adUnitIdInterstitial,
            adNonCosumableId: adNonCosumableId,
            appId: appId,
            infos: infos,
            greeting: greeting)

        // Connect changes in nonConsumable for non-ads-purchases to GFAdMob
        waitForCoreData = coreData.$hasFetchedLocally.first().sink(receiveCompletion: {_ in
            log()
        }) { hasFetchedLocally in
            log(hasFetchedLocally)
            guard hasFetchedLocally else {return}
            
            if let adNonCosumableId = adNonCosumableId {
                adAssignements = coreData.getNonConsumable(adNonCosumableId).$isOpened.assign(to: \.wasBought, on: adMob)
            }
        }
        log()
    }
    
    /// Singelton init
    private init(
        purchasables: [String: [GFInApp.Purchasable]],
        adUnitIdBanner: String?,
        adUnitIdRewarded: String?,
        adUnitIdInterstitial: String?,
        adNonCosumableId: String?,
        appId: Int,
        infos: [GFShareInformation],
        greeting: String?)
    {
        log()
        super.init()
        self.coreDataImpl = GFCoreDataCloudKit()
        self.gameCenterImpl = GFGameCenter()
        self.inAppImpl = GFInApp(purchasables)
        self.adMobImpl = GFAdMob(
            adUnitIdBanner: adUnitIdBanner,
            adUnitIdRewarded: adUnitIdRewarded,
            adUnitIdInterstitial: adUnitIdInterstitial)
        self.shareImpl = GFShare(appId: appId, infos: infos, greeting: greeting)
        self.audioImpl = GFAudio()
}

    // MARK: - Public functions
    /**
     Make sure scores are resetted. Call, when entering a new game or level.
     */
    public func enterLevel() {
        log()
        scores.forEach {
            (key: String, value: GFScore) in
            value.startOver()
        }
    }

    /**
     Saves current status and reports to GameCenter.
     
     Call this when level or game has ended.
     - Parameter requestReview: Set to true to indicate, that the player should be asked for a review by Apples system view. Should be set, if the player has somewhat experience with the game and just had a good, sucessful level played, e.g. reached a new high score. If set to true, it is up to apple's logic to actually show the dialog. During development, that dialog is always shown. In production, Apple ensures, that the dialog is shown at max 3-4 times in 12 months. If both parameters are set to `true` and an interstitial is available, it is only tried to show the interstitial.
     - Parameter showInterstitial: If set to true and an Interstial is available from Googles admob, it is shown to the user. Interstials are percieved as annoying by the community, but are still a way to earn money. Use this flag wisely. If both parameters are set to `true`and an interstitial is available, it is only tried to show the interstitial.
     */
    public func leaveLevel(requestReview: Bool, showInterstitial: Bool) {
        log(requestReview, showInterstitial)
        
        // For whatever reason, you cannot show both. Interstitial has prio if available
        let showInterstitial = showInterstitial && (adMobImpl.interstitial?.isReady ?? false)
        if requestReview && !showInterstitial {SKStoreReviewController.requestReview()}
        if showInterstitial {adMobImpl.showInterstitial()}
    }
    
    /**
     Call, when game pauses, e.g. is put into background or overlayed by an offer. Should be called before `leaveLevel()`
     */
    public func pause() {
        log()
        coreDataImpl.save()
        gameCenterImpl.report()
    }
    
    /**
     Call, when game is resumed from pause. Should be called after `enterLevel`
     */
    public func resume() {}
    
    // MARK: - Internal handling
    private static var adAssignements: AnyCancellable? = nil
    private static var waitForCoreData: AnyCancellable? = nil
}

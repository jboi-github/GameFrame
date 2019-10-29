//
//  GameFrame.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 28.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import StoreKit

// TODO: Test with sandbox user
// TODO: Purchase Simple purchase
// TODO: Purchase Deferred purchase
// TODO: Purchase Failed, simple purchase
// TODO: Purchase Restore: Calls purchaed again?
// DONE: Logging -> 0.5 Tage
// TODO: Automated Test Cases - Unit tests -> 3 Tage
// TODO: Automated Test Cases - UI Tests -> 3 Tage
// DONE: Separate Game Template as Game Frame as Framework from Game itself. Create protocols to publish interface -> 1 Tag
// TODO: Is their a lint for Swift? -> 1 Tag
// -> End Nov done
// TODO: Design Game -> LONG
// TODO: define products, Ads, leaderboards, achievements -> 2 Tag
// TODO: Setup Views for Store, Settings, Offers, Main (without GameZone), Launchscreen -> 5 Tage
// TODO: Create external links to community of Instagram, Twitter, Facebook -> 3 Tag
// TODO: What about Data Privacy Statement??? -> 2 Tage
// TODO: Build Game Engine in GameZone -> LONG

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

    internal private(set) var coreDataImpl: GFCoreDataCloudKit!
    internal private(set) var gameCenterImpl: GFGameCenter!
    internal private(set) var inAppImpl: GFInApp!
    internal private(set) var adMobImpl: GFAdMob!

    /**
     Create the shared instance of GameFrame and does the setup of a scene for `SceneDelegate`
     Replace the content of `func scene` in `SceneDelegate.swift` with a call to this function.
      - Parameter scene:            The `scene` parameter, given in the scene call in SceneDelegate
     - Parameter consumablesConfig: Associates consumables with products in store. Check GFInAppImpl for explanation and examples.
      - Parameter makeContentView:  A closure that builds the main view. It can already make use of `GameFrame`, e.g. to get Achievements, Scores, Consumables or NonConsumables and apss them to the view.
     */
    public class func createSharedInstance<Label : View>(_ scene: UIScene, consumablesConfig: [String : (String, Int)], adUnitIdBanner: String?, adUnitIdRewarded: String?, adUnitIdInterstitial: String?, makeContentView: () -> Label) {
        
        // Use a UIHostingController as window root view controller.
        guard let windowScene = scene as? UIWindowScene else {return}
        let window = UIWindow(windowScene: windowScene)
        
        instance = GameFrame(window: window, consumablesConfig: consumablesConfig, adUnitIdBanner: adUnitIdBanner, adUnitIdRewarded: adUnitIdRewarded, adUnitIdInterstitial: adUnitIdInterstitial)
        
        window.rootViewController = UIHostingController(rootView: makeContentView())
        window.makeKeyAndVisible()
        log()
    }
    
    /**
     Simplified version to create a `GameFrame` instance for previews. It has limited functionality and can not show system views like GameCenter or others. Also all apple and xcode limitations to previews apply.
     - Parameter consumablesConfig: Associates consumables with products in store. Check GFInAppImpl for explanation and examples.
     */
    public class func createSharedInstanceForPreview(consumablesConfig: [String : (String, Int)], adUnitIdBanner: String?, adUnitIdRewarded: String?, adUnitIdInterstitial: String?) {
        instance = GameFrame(window: nil, consumablesConfig: consumablesConfig, adUnitIdBanner: adUnitIdBanner, adUnitIdRewarded: adUnitIdRewarded, adUnitIdInterstitial: adUnitIdInterstitial)
        log()
    }
    
    /// Singelton init
    private init(window: UIWindow?, consumablesConfig: [String : (String, Int)], adUnitIdBanner: String?, adUnitIdRewarded: String?, adUnitIdInterstitial: String?) {
        log()
        super.init()
        coreDataImpl = GFCoreDataCloudKit()
        gameCenterImpl = GFGameCenter(window)
        inAppImpl = GFInApp(consumablesConfig)
        adMobImpl = GFAdMob(window, adUnitIdBanner: adUnitIdBanner, adUnitIdRewarded: adUnitIdRewarded, adUnitIdInterstitial: adUnitIdInterstitial)
        
        // Make sure, data is saved at the right moment
        NotificationCenter.default
            .addObserver(self, selector: #selector(onDidEnterBackgroundNotification(_ :)), name: UIScene.didEnterBackgroundNotification, object: nil)
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
     Starts all tasks when leaving a level. Call this when level or game has ended.
     - Parameter requestReview: Set to true to indicate, that the player should be asked for a review by apples system view. Should be set, if the player has somewhat experience with the game and just had a good, suceesful level played, e.g. reached a new high score. If set to true, it is up to apple's logic to actually show the dialog. During development, that dialog is always shown. In production, Apple ensures, that the dialog is shown at max 3-4 times in 12 months. If both parameters are set to `true`, it is only tried to show the interstitial.
     - Parameter showInterstitial: If set to true and an Interstial is available from Googles admob, it is shown to the user. Interstials are percieved as annoying by the community, but are still a way to earn money. Use this flag wisely. If both parameters are set to `true`, it is only tried to show the interstitial.
     */
    public func leaveLevel(requestReview: Bool, showInterstitial: Bool) {
        log()
        coreDataImpl.save()
        gameCenterImpl.report()
        
        // For whatever reason, you cannot show both. Interstitial has prio if available
        let showInterstitial = showInterstitial && (adMobImpl.interstitial?.isReady ?? false)
        if requestReview && !showInterstitial {SKStoreReviewController.requestReview()}
        if showInterstitial {adMobImpl.showInterstitial()}
    }
    
    // MARK: - Internal handling
    
    /// Get notified, when it's time to save
    @objc func onDidEnterBackgroundNotification(_ notification:Notification) {
        log()
        coreDataImpl.save()
        gameCenterImpl.report()
    }
}

//
//  GameController.swift
//  GameUIKit
//
//  Created by Juergen Boiselle on 15.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation
import SwiftUI
import GameFrameKit

/**
 The main class to control and work with games.
 
 An instance of this class can be created with `GameUI.createSharedInstance` which ensures, that only one
 instance of this class exists. To access this class use the `GameUI.instance` attribute. The game indicates, that the player
 should get an offer or that the game has ended here.
 */
public class GameUI: NSObject, ObservableObject  {
    // MARK: Model wide available
    
    /**
     Shared instance of GameUI.
     
     Initialized by call to `GameUI.createSharedInstance()`
     */
    public private(set) static var instance: GameUI!
    
    /**
     First time creation of the instance of `GameUI`.
     
     Call this function in `SceneDelegate.swift`. An example can be found in `TheGame` project.
     After this function the instances of `GameUI` and `GameFrame` are available.
     
     - parameters:
        - scene: pass through given `scene` parameter in `SceneDelegate.swift`
        - gameConfig: Configuration for your game, defining which navigation items and information items are shown in the different screens.
        - gameDelegate: Minimal game logic, that is necessary by `GameFrame` to run User Experience.
        - gameSkin: Define the skin, colors and formatting of your game.
        - startsOffLevel: Defines, if game starts with an off-level screen or directly jumps into the game. Games that use timing, likae Arcade games, should set this to `true`. Games like chess set this to `false` to ease User Experience.
     
     - warning: `startsOffLevel` currently only supports `true`. Behaviour with `false` is undefined.
     */
    public static func createSharedInstance<C, S>(
        scene: UIScene, gameConfig: C, gameDelegate: GameDelegate, gameSkin: S, startsOffLevel: Bool)
        where C: GameConfig, S: Skin
    {
        if instance != nil {return}
        
        instance = GameUI(gameDelegate: gameDelegate)
        
        GameFrame.createSharedInstance(
            scene, purchasables: gameConfig.purchasables,
            adUnitIdBanner: gameConfig.adUnitIdBanner,
            adUnitIdRewarded: gameConfig.adUnitIdRewarded,
            adUnitIdInterstitial: gameConfig.adUnitIdInterstitial,
            adNonCosumableId: gameConfig.adNonCosumableId,
            appId: gameConfig.sharedAppId,
            infos: gameConfig.sharedInformations,
            greeting: gameConfig.sharedGreeting) {
            
                return MainView<C,S>()
                    .environmentObject(gameSkin)
                    .environmentObject(gameConfig)
        }
    }

    /**
     Called by your game to let `InLevel` show an offer to the player.
     
     This will first pause the game by calling `pause()` in the `TheGameDelegate`,
     then show the offering. When offering dissappears, `resume()` is called and the consumables might reflect the new values - if the player decided to take the offer.
     If player decided to not take the offer, the consumables and therefore conditions to show the offer, might still be in place.
     
     - Parameters:
         - quantity: Number of consumables to be earned when a rewarded video is played. Has no effect to in-app purchases.
         - consumableId: Id of the consumable to offer to the player. All products, related to the consumable, are offered with a quantity of 1 item.
     */
    public func makeOffer(consumableId: String, quantity: Int) -> Bool {
        log(consumableId, quantity)
        guard gameDelegate.keepOffer() else {return false}
        if GameFrame.inApp.getProducts(consumableIds: [consumableId], nonConsumableIds: [String]()).isEmpty &&  !GameFrame.adMob.rewardAvailable {
            
            return false
        }
        
        offer = (consumableId: consumableId, quantity: quantity)
        return true
    }

    /**
     Call to end level or game.
     
     This starts the sequence of players level ends and gets back to OffLevel.
     */
    public func gameOver() {
        isInLevelShadow = false
        log(presentationMode)
        presentationMode?.wrappedValue.dismiss()
    }
    
    @Published private(set) var offer: (consumableId: String, quantity: Int)? = nil
    @Published private(set) var isInLevel: Bool = false
    @Published private(set) var isResumed: Bool = false
    
    var presentationMode: Binding<PresentationMode>?

    // MARK: Initialization
    private init(gameDelegate: GameDelegate) {
        self.gameDelegate = gameDelegate
        
        super.init()
        
        // Make sure, data is saved at the right moment
        NotificationCenter.default
            .addObserver(self, selector: #selector(onDidActivate(_ :)), name: UIScene.didActivateNotification, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(onDidEnterBackground(_ :)),
                         name: UIScene.didEnterBackgroundNotification, object: nil)
    }

    // MARK: Internals
    let gameDelegate: GameDelegate

    /// reading a published variable triggers changes!
    var isInLevelShadow: Bool = false {
        didSet(prev) {
            guard prev != isInLevelShadow else {return}
            isInLevel = isInLevelShadow
        }
    }
    var isResumedShadow: Bool = false {
        didSet(prev) {
            guard prev != isResumedShadow else {return}
            isResumed = isResumedShadow
        }
    }

    /**
     Called internally to clear offer and let it dissappear.
     */
    func clearOffer() {
        log(offer)
        offer = nil
    }
    
    /**
     Called during game, when the game should pause. During pause, delegates `isAlive` is called and if it returns `false` the sequence to
     end the level is started. therefroe, a call to `pause()` combined with `isAlive()` can result in a Game Over sequence.
     */
    func pause() {
        log(isResumedShadow, isInLevelShadow)
        guard isResumedShadow else {return}
        
        isResumedShadow = false
        gameDelegate.pause()
        GameFrame.instance.pause()
        
        if !isInLevelShadow {
            let leave = gameDelegate.leaveLevel()
            GameFrame.instance.leaveLevel(requestReview: leave.requestReview, showInterstitial: leave.showInterstitial)
        }
    }
    
    /**
     Called during game, when the game resumes from a previous pause.
     */
    func resume() {
        log(isResumedShadow, isInLevelShadow)
        guard !isResumedShadow else {return}
        
        if isInLevelShadow {
            // Resumed from some pause
            isResumedShadow = true
            gameDelegate.resume()

            // Still in game?
            if !gameDelegate.isAlive() {
                gameOver() // Game was over between pause and resume
            }
        } else {
            // Resumed from OffLevel
            isInLevelShadow = true
            GameFrame.instance.enterLevel()
            gameDelegate.enterLevel()

            isResumedShadow = true
            GameFrame.instance.resume()
            gameDelegate.resume()
        }
    }
    
    /// Get notified, when it's time to save
    @objc func onDidEnterBackground(_ notification:Notification) {
        log(isResumedShadow, isInLevelShadow)
        guard isInLevelShadow else {return}
        
        if isResumedShadow {
            pause()
        } else {
            GameFrame.instance.pause()
        }
    }
    
    /// Get notified, when it's time to save
    @objc func onDidActivate(_ notification: Notification) {
        log(isResumedShadow, isInLevelShadow)
        guard isInLevelShadow else {return}
        
        if !isResumedShadow {
            resume()
        } else {
            GameFrame.instance.resume()
        }
    }
}


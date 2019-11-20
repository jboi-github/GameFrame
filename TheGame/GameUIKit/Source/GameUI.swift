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

public class GameUI: NSObject, ObservableObject  {
    // MARK: Model wide available
    public private(set) static var instance: GameUI!
    
    public static func createSharedInstance<C, S>(
        scene: UIScene, gameConfig: C, gameDelegate: GameDelegate, gameSkin: S, startsOffLevel: Bool)
        where C: GameConfig, S: GameSkin
    {
        if instance != nil {return}
        
        instance = GameUI(gameDelegate: gameDelegate, navigator: Navigator(startsOffLevel: startsOffLevel))
        
        GameFrame.createSharedInstance(
            scene, consumablesConfig: gameConfig.productsToConsumables,
            adUnitIdBanner: gameConfig.adUnitIdBanner,
            adUnitIdRewarded: gameConfig.adUnitIdRewarded,
            adUnitIdInterstitial: gameConfig.adUnitIdInterstitial) {
            
                return MainView<C, S>()
                    .environmentObject(gameSkin)
                    .environmentObject(gameConfig)
                    .environmentObject(GameFrame.inApp)
        }
    }

    /**
     Called by your game to let `InLevel` show an offer to the player.
     
     This will first pause the game by calling `pause()` in the `TheGameDelegate`,
     then show the offering. When offering dissappears, `resume()` is called and the consumables might reflect the new values - if the player decided to take the offer.
     If player decided to not take the offer, the consumables and therefore conditions to show the offer, might still be in place.
     
     - Parameters:
         - quantity: Numer of consumables to be earned when a rewarded video is played. Has no effect to in-app purchaes.
         - consumableId: Id of the consumable to offer to the player. alle products, related to the consumable are offered with a qunatity of 1 item.
     */
    public func makeOffer(consumableId: String, quantity: Int) {
        log(consumableId, quantity)
        offer = (consumableId: consumableId, quantity: quantity)
    }
    
    /**
     Call to end level or game.
     
     This starts the sequence of players level ends and gets back to OffLevel.
     */
    public func gameOver() {
        isInLevelShadow = false
        navigator.pop()
    }
    
    @Published private(set) var offer: (consumableId: String, quantity: Int)? = nil
    @Published private(set) var isInLevel: Bool = false
    @Published private(set) var isResumed: Bool = false
    fileprivate(set) var geometryProxy: GeometryProxy? = nil

    // MARK: Initialization
    private init(gameDelegate: GameDelegate, navigator: Navigator) {
        self.gameDelegate = gameDelegate
        self.navigator = navigator
    }

    // MARK: Internals
    private let gameDelegate: GameDelegate
    let navigator: Navigator

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
     Called during game, when the game should pause. During pause, delegates `stayInLevel` is called and if it returns `false` the sequence to
     end the level is started. therefroe, a call to `pause()` combined with `stayInLevel()` can result in a Game Over sequence.
     */
    func pause() {
        log(isResumedShadow, isInLevelShadow)
        guard isResumedShadow else {return}
        
        isResumedShadow = false
        gameDelegate.pause()
        
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
            if !gameDelegate.stayInLevel() {
                gameOver() // Game was over between pause and resume
            }
        } else {
            // Resumed from OffLevel
            isInLevelShadow = true
            GameFrame.instance.enterLevel()
            gameDelegate.enterLevel()

            isResumedShadow = true
            gameDelegate.resume()
        }
    }
}

/// Internal work around to NavigationLink and NavigationView. A simple stack providing state possibility to go back in view hierarchy.
enum NavigatorItem{
    case OffLevel
    case InLevel
    case Store(consumableIds: [String], nonConsumableIds: [String])
    
    private typealias Unpacked<C, S> = (offLevel: OffLevelView<C, S>?, inLevel: InLevelView<C, S>?, store: StoreView<S>?)
        where C: GameConfig, S: GameSkin
    
    private func unpack<C, S>() -> Unpacked<C, S> {
        switch self {
        case .OffLevel:
            return (offLevel: OffLevelView<C, S>(), inLevel: nil, store: nil)
        case .InLevel:
            return (offLevel: nil, inLevel: InLevelView<C, S>(), store: nil)
        case let .Store(consumableIds: consumableIds, nonConsumableIds: nonConsumableIds):
            return (
                offLevel: nil, inLevel: nil,
                store: StoreView(consumableIds: consumableIds, nonConsumableIds: nonConsumableIds))
        }
    }
    
    func asView<C, S>(gameConfig: C, gameSkin: S, geometryProxy: GeometryProxy) -> some View where C: GameConfig, S: GameSkin {
        let item: Unpacked<C, S> = unpack()
        GameUI.instance.geometryProxy = geometryProxy
        
        return VStack {
            if item.offLevel != nil {
                item.offLevel!
            } else if item.inLevel != nil {
                item.inLevel!
            } else if item.store != nil {
                item.store!
            }
        }
    }
}

class Navigator: NSObject, ObservableObject {
    // MARK: Model wide available
    @Published private(set) var current: NavigatorItem
    
    func push(_ item: NavigatorItem) {
        stack.append(item)
        current = stack.last!
    }
    
    func pop() {
        _ = stack.popLast()
        current = stack.last!
    }
    
    // MARK: Initialize
    fileprivate init(startsOffLevel: Bool) {
        current = startsOffLevel ? .OffLevel : .OffLevel // TODO: !!
        super.init()
        stack.append(current)
    }
    
    // MARK: Implementation
    private var stack = [NavigatorItem]()
}

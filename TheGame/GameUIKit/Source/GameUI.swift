//
//  GameController.swift
//  GameUIKit
//
//  Created by Juergen Boiselle on 15.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation
import UIKit
import GameFrameKit

public class GameUI: NSObject, ObservableObject {
    // MARK: Publicly available
    public private(set) static var instance: GameUI?
    
    public static func createSharedInstance<S>(scene: UIScene, gameDelegate: GameDelegate, skin: S)  where S: Skin {
        if instance != nil {return}
        
        instance = GameUI()
        instance!.setDelegate(delegate: gameDelegate)
        
         GameFrame.createSharedInstance(
            scene, consumablesConfig: [
                "bulletsS": ("Bullets", 200),
                "bulletsM": ("Bullets", 1000),
                "bulletsL": ("Bullets", 2000),
                "Lives": ("Lives", 1),
            ],
            adUnitIdBanner: "ca-app-pub-3940256099942544/2934735716",
            adUnitIdRewarded: "ca-app-pub-3940256099942544/1712485313",
            adUnitIdInterstitial: "ca-app-pub-3940256099942544/4411468910") {
            
                return MainView(skin: skin, startsOffLevel: true)
        }
    }

    /**
     Called by your game to let `InLevel`show an offer to the player. This will first pause the game by calling `pause()` in the `TheGameDelegate`, then show the offering. When offering dissappears, `resume()` is called and the consumables might reflect the new values - if the player decided to take the offer. If player decided to not
     take the offer, the consumables and therefore conditions to show the offer, might still be in place.
     */
    public func makeOffer(consumableId: String, quantity: Int) {
        log(delegate != nil, consumableId, quantity)
        offer = (consumableId: consumableId, quantity: quantity)
    }

    // MARK: Initialization
    fileprivate override init(){}

    // MARK: Internals
    private var delegate: GameDelegate? = nil
    func setDelegate(delegate: GameDelegate) {self.delegate = delegate}
    
    @Published private(set) var offer: (consumableId: String, quantity: Int)? = nil
    @Published private(set) var isInLevel: Bool = false
    @Published private(set) var isResumed: Bool = false
    
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
    
    func pause() {
        log(isResumedShadow, isInLevelShadow)
        if isResumedShadow {
            isResumedShadow = false
            delegate?.pause()
            
            isInLevelShadow = (delegate?.stayInLevel() ?? isInLevelShadow) || offer != nil
            if !isInLevelShadow {
                if let leave = delegate?.leaveLevel() {
                    GameFrame.instance.leaveLevel(requestReview: leave.requestReview, showInterstitial: leave.showInterstitial)
                } else {
                    GameFrame.instance.leaveLevel(requestReview: false, showInterstitial: false)
                }
            }
        }
    }
    
    func resume() -> Bool {
        log(isResumedShadow, isInLevelShadow)
        if !isResumedShadow {
            if !isInLevelShadow {
                isInLevelShadow = true
                GameFrame.instance.enterLevel()
                delegate?.enterLevel()
            }
            isResumedShadow = true
            delegate?.resume()
            
        }
        // Came back from offer, but did not take it
        isInLevelShadow = delegate?.stayInLevel() ?? isInLevelShadow
        return isInLevelShadow
    }
}

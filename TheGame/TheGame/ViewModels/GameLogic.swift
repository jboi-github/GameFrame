//
//  GameLogic.swift
//  TheGame
//
//  Created by Juergen Boiselle on 02.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation
import GameFrameKit
import StoreKit

let gameLogic = GameLogic()

class GameLogic {
    fileprivate init() {}
}

// All logic is stateless
extension GameLogic {
    /**
     Called, when View, associated with the game disappears
     */
    func afterGamePaused() {log()}
    
    /**
     Called, when View, associated with the game appears
     */
    func beforeGameResumed() {log()}

    /**
     Individual logic when entering a new level. Must at least call GameFrame.enterLevel()
     */
    func beforeEnteringLevel() {
        log()
        let bullets = GameFrame.coreData.getConsumable("Bullets")
        let lives = GameFrame.coreData.getConsumable("Lives")

        if bullets.available < 100 {bullets.earn(100 - bullets.available)}
        if lives.available < 1 {lives.earn(1 - lives.available)}
        GameFrame.instance.enterLevel()
    }

    /**
     Individual logic when leaving a level. Must at least call GameFrame.leveLevel(). Is called after a final offer was made.
     */
    func afterLeavingLevel() {
        log()
        let points = GameFrame.coreData.getScore("Points")
        
        let goodLevel = points.current == points.highest
        let timeForInterstitial = (Double.random(in: 0..<1) < 0.5) && !goodLevel // 50% and prio on review
        GameFrame.instance.leaveLevel(requestReview: goodLevel, showInterstitial: timeForInterstitial)
    }

    /**
     Check is player is dead
     */
    func isDead() -> Bool {
        log()
        let bullets = GameFrame.coreData.getConsumable("Bullets")
        let lives = GameFrame.coreData.getConsumable("Lives")
        
        return lives.available <= 0 || bullets.available <= 0
    }

    /**
    Decide if player gets a last chance offer and which offer it will be.
     - returns: - (1) The reward-part contains the consumable to offer and the quantity that should be rewarded. If set, it is guaranteed, that a rewarded video is available.
                - (2) purchase-part contains the consumable product as returned by inApp.getConsumables. If no products available in store, this arra is empty.
                - (3) if reward is nil and products is empty, do not show the offer-dialog.
    */
    func makeOffer() -> (reward: (consumable: GFConsumable, quantity: Int)?, purchase: [GFInApp.ConsumableProduct])? {
        log()
        // Offer only, if close to high-score and not a new high-score reached
        let points = GameFrame.coreData.getScore("Points")
        let range = (0.8 * Double(points.highest))..<Double(points.highest)
        guard range.contains(Double(points.current)) else {return nil}

        // Offer for lives or for bullets. Not both
        let lives = GameFrame.coreData.getConsumable("Lives")
        let bullets = GameFrame.coreData.getConsumable("Bullets")
        
        if lives.available <= 0 && bullets.available <= 0 {
            return nil
        } else if lives.available <= 0 {
            return makeOffer(consumable: lives, name: "Lives", quantity: 1)
        } else if bullets.available <= 0 {
            return makeOffer(consumable: bullets, name: "Bullets", quantity: 100)
        } else {
            return nil
        }
    }

    private func makeOffer(consumable: GFConsumable, name: String, quantity: Int)
        -> (reward: (consumable: GFConsumable, quantity: Int)?, purchase: [GFInApp.ConsumableProduct])? {
        
        let reward = GameFrame.adMob.rewardAvailable ? (consumable: consumable, quantity: quantity) : nil
        let purchase = GameFrame.inApp.getConsumables(ids: [name])
        guard reward != nil || !purchase.isEmpty else {return nil}
        
        return (reward: reward, purchase: purchase)
    }
}

func XgetNonConsumables(ids: [String]) -> [GFNonConsumable] {
    GameFrame.inApp.getNonConsumables(ids: ids)
}

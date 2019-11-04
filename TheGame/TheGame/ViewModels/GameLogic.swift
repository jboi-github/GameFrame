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

func enterLevel() {
    let bullets = GameFrame.coreData.getConsumable("Bullets")
    let lives = GameFrame.coreData.getConsumable("Lives")

    if bullets.available < 100 {bullets.earn(100 - bullets.available)}
    if lives.available < 1 {lives.earn(1 - lives.available)}
    GameFrame.instance.enterLevel()
}

func leaveLevel() {
    let points = GameFrame.coreData.getScore("Points")
    
    let goodLevel = points.current == points.highest
    let timeForInterstitial = (Double.random(in: 0..<1) < 0.5) && !goodLevel // 50% and prio on review
    GameFrame.instance.leaveLevel(requestReview: goodLevel, showInterstitial: timeForInterstitial)
}

/**
 Check is player is dead and decide, if he gets an offer for a very last chance.
 Set directly activeSheet to continue with offer or end of level.
 */
func checkDeath() {
    let bullets = GameFrame.coreData.getConsumable("Bullets")
    let lives = GameFrame.coreData.getConsumable("Lives")
    
    // If not dead, do nothing
    if lives.available > 0 && bullets.available > 0 {return}

    // Offer only, if close to high-score and not a new high-score reached
    let points = GameFrame.coreData.getScore("Points")
    let range = (0.8 * Double(points.highest))..<Double(points.highest)
    let pointsInRange = range.contains(Double(points.current))
    
    // Check if offer is available
    let offer = makeOffer()
    
    activeSheet.next(pointsInRange && (offer.reward != nil || offer.purchase != nil) ? .Offer : .OffLevel)
}

/**
Decide which offer to make.
 - returns: Which consumable to offer and which quantity should be rewarded.
*/
func makeOffer() -> (reward: (consumable: GFConsumable, quantity: Int)?, purchase: [GFInApp.ConsumableProduct]?) {
    let bullets = GameFrame.coreData.getConsumable("Bullets")
    let lives = GameFrame.coreData.getConsumable("Lives")

    guard let emptyConsumableId = lives.available == 0 ? "Lives" : (bullets.available == 0 ? "Bullets" : nil) else {
        return (reward: nil, purchase: nil)
    }

    // Set reward if available
    let reward = GameFrame.adMob.rewardAvailable ? (
        consumable: GameFrame.coreData.getConsumable(emptyConsumableId),
        quantity: lives.available == 0 ? 1 : (bullets.available == 0 ? 100 : 0)) : nil

    // Offer if product available in store
    let purchase = GameFrame.inApp.getConsumables(ids: [emptyConsumableId])
    
    return (reward: reward, purchase: purchase)
}


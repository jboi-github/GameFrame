//
//  TheGameDelegate.swift
//  TheGame
//
//  Created by Juergen Boiselle on 11.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import GameFrameKit
import GameUIKit

/// Created and initialized in `SceneDelegate`
class TheGameDelegate: GameDelegate {
    func pause() {log()}
    
    func resume() {log()}
    
    func isAlive() -> Bool {
        log()
        
        // Is dead? Then end the level
        let bullets = GameFrame.coreData.getConsumable("Bullets")
        let lives = GameFrame.coreData.getConsumable("Lives")
        return bullets.available > 0 && lives.available > 0
    }
    
    func enterLevel() {
        log()
        let bullets = GameFrame.coreData.getConsumable("Bullets")
        let lives = GameFrame.coreData.getConsumable("Lives")

        if bullets.available < 100 {bullets.earn(100 - bullets.available)}
        if lives.available < 1 {lives.earn(1 - lives.available)}
    }
    
    func leaveLevel() -> (requestReview: Bool, showInterstitial: Bool) {
        log()
        let points = GameFrame.coreData.getScore("Points")
        
        let goodLevel = points.current == points.highest
        let timeForInterstitial = (Double.random(in: 0..<1) < 0.5) && !goodLevel // 50% and prio on review
        return (requestReview: goodLevel, showInterstitial: timeForInterstitial)
    }
    
    func keepOffer() -> Bool {
        log()
        return !isAlive()
    }
}

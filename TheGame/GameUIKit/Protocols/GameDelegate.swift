//
//  GameZoneDelegate.swift
//  TheGame
//
//  Created by Juergen Boiselle on 11.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation

// MARK: - GameDelegate to implement individual game logic
/**
 Game logic around external events to the game. All functions are called by The Game implementation.
 */
public protocol GameDelegate {
    /**
     Called when the game goes off screen and player has no longer attention to it.
     */
    func pause()
    
    /**
     Called when the game comes back to players attention. This function is also called, when the player returns
     from an offer. Therefore check here for game over conditions.
     */
    func resume()
    
    /**
     Game enters a level and player can start playing without any more interaction.
     */
    func enterLevel()
    
    /**
     Called when game leaves the screen.
     - returns: true, if game should only pause and continue. False, if level should end, e.g. player ran out of lives.
     */
    func isAlive() -> Bool
    
    /**
     Game or level is over. Game returns to OffLevel.
     - returns: if a review micht be requested and/or an interstitial should be shown.
     */
    func leaveLevel() -> (requestReview: Bool, showInterstitial: Bool)
    
    /**
     Check, if conditions to make offer are fulfilled.
     
     This is called multiple times during offering, initiated by a call to `makeOffer()`, to ensure good User Experience.
     - returns:
        - true, if conditions for an offer are (still) fullfilled.
        - false, if no offer should be made or existing offer should disappear.
     */
    func keepOffer() -> Bool
}

// MARK: - GameDelegate implementation for PreView
import GameFrameKit

class PreViewDelegate: GameDelegate {
    func pause() {log()}
    
    func resume() {log()}
    
    func enterLevel() {log()}
    
    func isAlive() -> Bool {
        log()
        return true
    }
    
    func leaveLevel() -> (requestReview: Bool, showInterstitial: Bool) {
        log()
        return (requestReview: false, showInterstitial: false)
    }
    
    func keepOffer() -> Bool {
        log()
        return true
    }
}

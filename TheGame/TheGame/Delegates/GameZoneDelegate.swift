//
//  GameZoneDelegate.swift
//  TheGame
//
//  Created by Juergen Boiselle on 11.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation

/**
 Game logic around external events to the game. All functions are called by The Game implementation.
 */
protocol GameZoneDelegate {
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
     Game or level is over. Game returns to OffLevel.
     - returns: if a review micht be requested and/or an interstitial should be shown.
     */
    func leaveLevel() -> (requestReview: Bool, showInterstitial: Bool)
}

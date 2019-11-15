//
//  GameZoneDelegate.swift
//  TheGame
//
//  Created by Juergen Boiselle on 11.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation

/**
 Use the variable `gameController` to call the funcitons in here, mainly `makeOffer` anywhere in your game to offer the player some consumables
 as in-app purchase and the possibility to earn the specific consumable via rewarded videos.
 */
protocol GameController {
    func setDelegate(delegate: GameDelegate)
    
    /**
     Called by your game to let `InLevel`show an offer to the player. This will first pause the game by calling `pause()` in the `TheGameDelegate`, then show the offering. When offering dissappears, `resume()` is called and the consumables might reflect the new values - if the player decided to take the offer. If player decided to not
     take the offer, the consumables and therefore conditions to show the offer, might still be in place.
     */
    func makeOffer(consumableId: String, quantity: Int)
}

/**
 Game logic around external events to the game. All functions are called by The Game implementation.
 */
protocol GameDelegate {
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
    func stayInLevel() -> Bool
    
    /**
     Game or level is over. Game returns to OffLevel.
     - returns: if a review micht be requested and/or an interstitial should be shown.
     */
    func leaveLevel() -> (requestReview: Bool, showInterstitial: Bool)
}

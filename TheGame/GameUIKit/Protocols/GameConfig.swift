//
//  GameConfig.swift
//  GameUIKit
//
//  Created by Juergen Boiselle on 18.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation
import SwiftUI

/**
 Give configuration to `GameUI` and `GameFrame`.
 
 Implement this protocol to define how to navigate through your app and what information to show where and when.
 */
public protocol GameConfig: ObservableObject {
    /**
     Set information items to be shown while the player is off level.
     
     The two dimensional array is layed out to rows and columns. Each row can have different number of columns.
     */
    var offLevelInformation: [[InformationItem]] {get}
    
    /**
     Set navigation items to be shown while the player is off level.
     
     The two dimensional array is layed out to rows and columns. Each row can have different number of columns.
     */
    var offLevelNavigation: [[NavigationItem]] {get}
    
    /**
     Set information items to be shown while the player is in level. The information is shown as overlay to your game view.
     
     The two dimensional array is layed out to rows and columns. Each row can have different number of columns.
     */
    var inLevelInformation: [[InformationItem]] {get}
    
    /**
     Set navigation items to be shown while the player is in level. The navigation is shown as overlay to your game view.
     
     The two dimensional array is layed out to rows and columns. Each row can have different number of columns.
     */
    var inLevelNavigation: [[NavigationItem]] {get}
    
    /**
     Define which products affect which consumable after a purchase.
     
     This dictionary uses product-identifier as defined when setup products for in-app store as key.
     The value is the `Consumable` or `NonConsumable` that is affected and the amount, that is bought with each purchase.
     
     **Example**: You have a product for in-app purchases of `Get1000Bullets` and a consumable `Bullets`. With this, you define by
     
        `["Get1000Bullets": .Consumable(id: "Bullets", quantity: 1000)]`
     
     to add 1000 bullets when the corrsponding product was bought one time.
     */
    var purchasables: [String: [GFInApp.Purchasable]] {get}
    
    /**
     Ad Unit ID for banner as given by Google AdMob
     */
    var adUnitIdBanner: String {get}
    
    /**
     Ad Unit ID for rewarded videos as given by Google AdMob
     */
    var adUnitIdRewarded: String {get}
    
    /**
     Ad Unit ID for interstitials as given by Google AdMob
     */
    var adUnitIdInterstitial: String {get}
}

// MARK: - GameConfig implementation for PreView

import GameFrameKit

class PreViewConfig: GameConfig {
    let offLevelInformation = [[InformationItem]]()
    let offLevelNavigation = [[NavigationItem]]()
    let inLevelInformation = [[InformationItem]]()
    let inLevelNavigation = [[NavigationItem]]()

    let purchasables = [String: [GFInApp.Purchasable]]()
    let adUnitIdBanner = ""
    let adUnitIdRewarded = ""
    let adUnitIdInterstitial = ""
}

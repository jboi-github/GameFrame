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
    var offLevelInformation: [[Information]] {get}
    
    /**
     Set navigation items to be shown while the player is off level.
     
     The two dimensional array is layed out to rows and columns. Each row can have different number of columns.
     */
    var offLevelNavigation: [[Navigation]] {get}
    
    /**
     Set information items to be shown while the player is in level. The information is shown as overlay to your game view.
     
     The two dimensional array is layed out to rows and columns. Each row can have different number of columns.
     */
    var inLevelInformation: [[Information]] {get}
    
    /**
     Set navigation items to be shown while the player is in level. The navigation is shown as overlay to your game view.
     
     The two dimensional array is layed out to rows and columns. Each row can have different number of columns.
     */
    var inLevelNavigation: [[Navigation]] {get}

    /**
     Set information items to be shown while the player is in settings.
     
     The two dimensional array is layed out to rows and columns. Each row can have different number of columns.
     */
    var settingsInformation: [[Information]] {get}
    
    /**
     Set navigation items to be shown while the player is in settings.
     
     The two dimensional array is layed out to rows and columns. Each row can have different number of columns.
     */
    var settingsNavigation: [[Navigation]] {get}
    
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
    var adUnitIdBanner: String? {get}
    
    /**
     Ad Unit ID for rewarded videos as given by Google AdMob
     */
    var adUnitIdRewarded: String? {get}
    
    /**
     Ad Unit ID for interstitials as given by Google AdMob
     */
    var adUnitIdInterstitial: String? {get}
    
    /**
     Id for a non-consumable to stop advertisements.
     
     If player earned or bought this, no more advertiesements (banner and interstitials) are shown. Rewarded videos are still available.
     You can setuop a corresponding product in the app-store for the user and let him buy it in the store. In order to achieve this, you also need to map
     the product as `purchasable`
     */
    var adNonCosumableId: String? {get}
    
    var sharedAppId: Int {get}
    var sharedGreeting: String {get}
    var sharedInformations: [GFShareInformation] {get}
}

// MARK: - GameConfig implementation for PreView

import GameFrameKit

class PreviewConfig: GameConfig {
    let offLevelInformation = [[Information]]()
    let offLevelNavigation = [[Navigation]]()
    let inLevelInformation = [[Information]]()
    let inLevelNavigation = [[Navigation]]()
    let settingsInformation = [[Information]]()
    let settingsNavigation = [[Navigation]]()

    let purchasables = [String: [GFInApp.Purchasable]]()
    let adUnitIdBanner: String? = nil
    let adUnitIdRewarded: String? = nil
    let adUnitIdInterstitial: String? = nil
    let adNonCosumableId: String? = nil

    let sharedAppId: Int = 0
    let sharedGreeting: String = ""
    let sharedInformations = [GFShareInformation]()
}

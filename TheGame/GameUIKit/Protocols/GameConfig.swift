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
     Set to true, to start Game in Off-Level. The player has to press the play-button to start the game. This is useful for arcade games and whenever timing
     is important. If no timing is necessary like in chess, sudoku etc., then this set this to false for easiest player experience.
     */
    var startsOffLevel: Bool {get}
    /**
     Set information items to be shown while the player is off level.
     
     The two dimensional array is layed out to rows and columns. Each row can have different number of columns.
     */
    func offLevelInformation(frame: CGRect) -> [[Information]]
    
    /**
     Set navigation items to be shown while the player is off level.
     
     The two dimensional array is layed out to rows and columns. Each row can have different number of columns.
     */
    func offLevelNavigation(frame: CGRect) -> [[Navigation]]
    
    /**
     Set information items to be shown while the player is in level. The information is shown as overlay to your game view.
     
     The two dimensional array is layed out to rows and columns. Each row can have different number of columns.
     */
    func inLevelInformation(frame: CGRect) -> [[Information]]
    
    /**
     Set navigation items to be shown while the player is in level. The navigation is shown as overlay to your game view.
     
     The two dimensional array is layed out to rows and columns. Each row can have different number of columns.
     */
    func inLevelNavigation(frame: CGRect) -> [[Navigation]]

    /**
     Set information items to be shown while the player is in settings.
     
     The two dimensional array is layed out to rows and columns. Each row can have different number of columns.
     */
    func settingsInformation(frame: CGRect) -> [[Information]]
    
    /**
     Set navigation items to be shown while the player is in settings.
     
     The two dimensional array is layed out to rows and columns. Each row can have different number of columns.
     */
    func settingsNavigation(frame: CGRect) -> [[Navigation]]
    
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
    
    /**
     Add navigation item to navigation bar (trailing) in OffLevel.
     
     If your skin hides the navigationbar, ensure that the navigation item is available anywhere on the display.
     
     - warning: As of XCode 11.2.1, iOS 13.2 and Swift 5.2, putting a link to the navigation bar causes the app to crash.
     */
    var offLevelNavigationBar: Navigation? {get}
    
    /**
     Add navigation item to navigation bar (trailing) in InLevel.
     
     If your skin hides the navigationbar, ensure that the navigation item is available anywhere on the display.
     
     - warning: As of XCode 11.2.1, iOS 13.2 and Swift 5.2, putting a link to the navigation bar causes the app to crash.
     */
    var inLevelNavigationBar: Navigation? {get}
    
    /**
     Add navigation item to navigation bar (trailing) in store.
     
     If your skin hides the navigationbar, ensure that the navigation item is available anywhere on the display.
     
     - warning: As of XCode 11.2.1, iOS 13.2 and Swift 5.2, putting a link to the navigation bar causes the app to crash.
     */
    var storeNavigationBar: Navigation? {get}
    
    /**
     Add navigation item to navigation bar (trailing) in settings.
     
     If your skin hides the navigationbar, ensure that the navigation item is available anywhere on the display.
     
     - warning: As of XCode 11.2.1, iOS 13.2 and Swift 5.2, putting a link to the navigation bar causes the app to crash.
     */
    var settingsNavigationBar: Navigation? {get}
}

// MARK: - GameConfig implementation for PreView

import GameFrameKit

class PreviewConfig: GameConfig {
    let startsOffLevel: Bool = true
    
    func offLevelInformation(frame: CGRect) -> [[Information]] {return [[Information]]()}
    func offLevelNavigation(frame: CGRect) -> [[Navigation]] {return [[Navigation]]()}
    func inLevelInformation(frame: CGRect) -> [[Information]] {return [[Information]]()}
    func inLevelNavigation(frame: CGRect) -> [[Navigation]] {return [[Navigation]]()}
    func settingsInformation(frame: CGRect) -> [[Information]] {return [[Information]]()}
    func settingsNavigation(frame: CGRect) -> [[Navigation]] {return [[Navigation]]()}

    let purchasables = [String: [GFInApp.Purchasable]]()
    let adUnitIdBanner: String? = nil
    let adUnitIdRewarded: String? = nil
    let adUnitIdInterstitial: String? = nil
    let adNonCosumableId: String? = nil

    let sharedAppId: Int = 0
    let sharedGreeting: String = ""
    let sharedInformations = [GFShareInformation]()
    
    let offLevelNavigationBar: Navigation? = .Generics(.Url("https://www.apple.com"))
    let inLevelNavigationBar: Navigation? = .Generics(.Url("https://www.apple.com"))
    let storeNavigationBar: Navigation? = .Generics(.Url("https://www.apple.com"))
    let settingsNavigationBar: Navigation? = .Generics(.Url("https://www.apple.com"))
}

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
    // MARK: Game Views-Configuration
    associatedtype GameZoneType: View
    associatedtype SettingsZoneType: View
    associatedtype NoBannerZoneType: View
    /**
     Here you're. Place here your view that contains the game itself.
     
     Usually, this is a SCNView or SKView, wrapped in a UIRepresantive.
     */
    var gameZone: GameZoneType {get}
    
    /**
     Place here your view that contains settings for the game.
     
     Usually, this is a SCNView or SKView, wrapped in a UIRepresantive. Use this views, e.g. to let the player choose an avatar or weapons etc.
     */
    var settingsZone: SettingsZoneType {get}
    
    /**
     Place here your view that shows up, when no advertisement banner is available.
     
     Usually, this is a text or graphik. It is shown, when AdMob has no banner available or the player bought an advertisement-free version.
     */
    var noBannerZone: NoBannerZoneType {get}

    // MARK: OffLevel-Configuration
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
     Title of the navigation bar.
     
     For the sake of flexibility, both navigation panes are alwas built. To hide the navigation bar use the corresponding skin modifier.
     Nevertheless, games should have only one navigation available.
     Usually games, that have a minimalistic approach for the skin should let the player navigate by navigation bar.
     Games, that make heavy changes of the skin and build there own UX, probably want to use the navigation layer.
     */
    var offLevelNavigationBarTitle: String {get}
    
    /**
     First of two possible buttons in the navigation bar. If nil it's not shown.
     
     If only one of the two buttons is shown, it's shown as almost trailing, regardless which one was set.
     */
    var offLevelNavigationBarButton1: Navigation? {get}
    
    /**
     Second of two possible buttons in the navigation bar. If nil it's not shown.
     
     If only one of the two buttons is shown, it's shown as almost trailing, regardless which one was set.
     */
    var offLevelNavigationBarButton2: Navigation? {get}

    /**
     Set navigation items to be shown while the player is off level.
     
     The two dimensional array is layed out to rows and columns. Each row can have different number of columns.
     */
    func offLevelNavigation(frame: CGRect) -> [[Navigation]]

    /// Define if, how and where the Game Center Access Point should be displayed while off level.
    var offLevelGameCenter: (mode: GameCenterMode, location: GKAccessPoint.Location) {get}

    // MARK: InLevel-Configuration
    /**
     Set information items to be shown while the player is in level. The information is shown as overlay to your game view.
     
     The two dimensional array is layed out to rows and columns. Each row can have different number of columns.
     */
    func inLevelInformation(frame: CGRect) -> [[Information]]
    
    /**
     Title of the navigation bar.
     
     For the sake of flexibility, both navigation panes are alwas built. To hide the navigation bar use the corresponding skin modifier.
     Nevertheless, games should have only one navigation available.
     Usually games, that have a minimalistic approach for the skin should let the player navigate by navigation bar.
     Games, that make heavy changes of the skin and build there own UX, probably want to use the navigation layer.
     */
    var inLevelNavigationBarTitle: String {get}
    
    /**
     First of two possible buttons in the navigation bar. If nil it's not shown.
     
     If only one of the two buttons is shown, it's shown as almost trailing, regardless which one was set.
     */
    var inLevelNavigationBarButton1: Navigation? {get}
    
    /**
     Second of two possible buttons in the navigation bar. If nil it's not shown.
     
     If only one of the two buttons is shown, it's shown as almost trailing, regardless which one was set.
     */
    var inLevelNavigationBarButton2: Navigation? {get}

    /**
     Set navigation items to be shown while the player is in level. The navigation is shown as overlay to your game view.
     
     The two dimensional array is layed out to rows and columns. Each row can have different number of columns.
     */
    func inLevelNavigation(frame: CGRect) -> [[Navigation]]

    /// Define if, how and where the Game Center Access Point should be displayed while in level.
    var inLevelGameCenter: (mode: GameCenterMode, location: GKAccessPoint.Location) {get}

    // MARK: Settings-Configuration
    /**
     Set information items to be shown while the player is in settings.
     
     The two dimensional array is layed out to rows and columns. Each row can have different number of columns.
     */
    func settingsInformation(frame: CGRect) -> [[Information]]
    
    /**
     Title of the navigation bar.
     
     For the sake of flexibility, both navigation panes are alwas built. To hide the navigation bar use the corresponding skin modifier.
     Nevertheless, games should have only one navigation available.
     Usually games, that have a minimalistic approach for the skin should let the player navigate by navigation bar.
     Games, that make heavy changes of the skin and build there own UX, probably want to use the navigation layer.
     */
    var settingsNavigationBarTitle: String {get}
    
    /**
     First of two possible buttons in the navigation bar. If nil it's not shown.
     
     If only one of the two buttons is shown, it's shown as almost trailing, regardless which one was set.
     */
    var settingsNavigationBarButton1: Navigation? {get}
    
    /**
     Second of two possible buttons in the navigation bar. If nil it's not shown.
     
     If only one of the two buttons is shown, it's shown as almost trailing, regardless which one was set.
     */
    var settingsNavigationBarButton2: Navigation? {get}

    /**
     Set navigation items to be shown while the player is in settings.
     
     The two dimensional array is layed out to rows and columns. Each row can have different number of columns.
     */
    func settingsNavigation(frame: CGRect) -> [[Navigation]]
    
    // MARK: Store and Offer-Configuration
    /**
     Define which products affect which consumable after a purchase.
     
     This dictionary uses product-identifier as defined when setup products for in-app store as key.
     The value is the `Consumable` or `NonConsumable` that is affected and the amount, that is bought with each purchase.
     
     - **Example 1**: You have a product for in-app purchases of `Get1000Bullets` and a consumable `Bullets`. With this, you define by
     
        `["Get1000Bullets": [.Consumable(id: "Bullets", quantity: 1000)]]`
     
        to add 1000 bullets when the corrsponding product was bought one time.
     - **Example 2**: You have a product for in-app purchases of `GetWeaponBundle`, non-consumable `bigWeapon` and a consumable `Bullets`.
        With this, you define by
     
        `["GetWeaponBundle": [.NonConsumable(id: "bigWeapon"), .Consumable(id: "Bullets", quantity: 1000)]]`
     
        to unlock the `bigWeapon` and add 1000 bullets when the corrsponding product was bought one time.
     */
    var purchasables: [String: [GFInApp.Purchasable]] {get}
    
    /**
     Consumables and non-consumables to be shown in store.
     
     The store will only show products, that are listed here and have a configured product
     via `purchasables`and are currently vailable by Apple in the local store of the player.
     */
    var storePurchasables: [GFInApp.Purchasable] {get}

    /**
     Title of the navigation bar.
     
     For the sake of flexibility, both navigation panes are alwas built. To hide the navigation bar use the corresponding skin modifier.
     Nevertheless, games should have only one navigation available.
     Usually games, that have a minimalistic approach for the skin should let the player navigate by navigation bar.
     Games, that make heavy changes of the skin and build there own UX, probably want to use the navigation layer.
     */
    var storeNavigationBarTitle: String {get}
    
    /**
     Consumable to be earned, when the player watches a rewarded video in store.
     
     If nil, the button for rewarded videos is not shown in store.
     */
    var storeRewardConsumableId: String? {get}
    
    /**
     Quantity of the consumable to be earned, when the player watches a rewarded video in store.
     
     Ignored, when `storeRewardConsumableId` is nil.
     */
    var storeRewardQuantity: Int {get}
    
    // MARK: Advertisement-Configuration
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
     
     If player earned or bought this, no more advertisements (banner and interstitials) are shown. Rewarded videos are still available.
     You can setuop a corresponding product in the app-store for the user and let him buy it in the store. In order to achieve this, you also need to map
     the product as `purchasable`
     */
    var adNonCosumableId: String? {get}
    
    // MARK: Share-Configuration
    /**
     AppId as given in the App-Store and iTunesConnect
     */
    var sharedAppId: String {get}
    
    /**
     Greeting to be used when sharing.
     
     When sharing via email, the greeting is used as subject. In the Share-Metadata it is used as subline.
     */
    var sharedGreeting: String {get}
    
    /**
     Information like Achievements, Scores, Consumables and non-consumables to be shared.
     */
    var sharedInformations: [GFShareInformation] {get}
    
    // MARK: Audio-Configuration
    /**
     List of all sounds and their keys. the keys are used throughout the game to play sounds either when navigation butons are pressed or
     anywhere in the skin. Use `View.gameSkinPlay(key)` to play a sound together with animations.
     - resource is the name of the resource file containing the sound
     - type is the file extension. Defaults to "mp3"
     - subdirectory is a directory in which the sounds are placed. Defaults to "Sounds"
     */
    var sounds: [String: (resource: String, type: String?)] {get}

    // MARK: Review-Configuration
    /// Times the level must run before the first review is asked. Include any leaning period here.
    var reviewDoNotAskFirstBefore: Int {get}
    /// Times levels must run before the player is asked again and the player ahs choosen to try again when asked the last time.
    var reviewDoNotAskAgainBefore: Int {get}
    /// Key to `UserDefaults` to store if review-questions are disabled.
    var reviewKeyDisabled: String {get}
    /// Key to `UserDefaults` to store number of levels already ran.
    var reviewKeyRuns: String {get}
    /// Key to `UserDefaults` to store number of levels at the moment the user has choosen to try again.
    var reviewKeyLastAsk: String {get}
}

public enum NavigationLocation {
    case Bar, Layer
}

public enum GameCenterMode {
    case None, Compact, Full
}

// MARK: - GameConfig implementation for PreView
import GameFrameKit
import GameKit

class PreviewConfig: GameConfig {
    let gameZone: some View = EmptyView()
    let settingsZone: some View = EmptyView()
    let noBannerZone: some View = EmptyView()

    let startsOffLevel: Bool = true
    
    func offLevelInformation(frame: CGRect) -> [[Information]] {return [[Information]]()}
    var offLevelNavigationBarTitle: String = ""
    var offLevelNavigationBarButton1: Navigation? = nil
    var offLevelNavigationBarButton2: Navigation? = nil
    func offLevelNavigation(frame: CGRect) -> [[Navigation]] {return [[Navigation]]()}
    var offLevelGameCenter: (mode: GameCenterMode, location: GKAccessPoint.Location) = (.None, .topLeading)

    func inLevelInformation(frame: CGRect) -> [[Information]] {return [[Information]]()}
    var inLevelNavigationBarTitle: String = ""
    var inLevelNavigationBarButton1: Navigation? = nil
    var inLevelNavigationBarButton2: Navigation? = nil
    func inLevelNavigation(frame: CGRect) -> [[Navigation]] {return [[Navigation]]()}
    var inLevelGameCenter: (mode: GameCenterMode, location: GKAccessPoint.Location) = (.None, .topLeading)

    func settingsInformation(frame: CGRect) -> [[Information]] {return [[Information]]()}
    var settingsNavigationBarTitle: String = ""
    var settingsNavigationBarButton1: Navigation? = nil
    var settingsNavigationBarButton2: Navigation? = nil
    func settingsNavigation(frame: CGRect) -> [[Navigation]] {return [[Navigation]]()}

    let purchasables = [String: [GFInApp.Purchasable]]()
    var storePurchasables = [GFInApp.Purchasable]()
    var storeNavigationBarTitle: String = ""
    var storeRewardConsumableId: String? = nil
    var storeRewardQuantity: Int = 0

    let adUnitIdBanner: String? = nil
    let adUnitIdRewarded: String? = nil
    let adUnitIdInterstitial: String? = nil
    let adNonCosumableId: String? = nil

    let sharedAppId: String = ""
    let sharedGreeting: String = ""
    let sharedInformations = [GFShareInformation]()
    
    let sounds = [String: (resource: String, type: String?)]()
    
    let reviewDoNotAskFirstBefore: Int = 0
    let reviewDoNotAskAgainBefore: Int = 0
    let reviewKeyDisabled: String = ""
    let reviewKeyRuns: String = ""
    let reviewKeyLastAsk: String = ""
}

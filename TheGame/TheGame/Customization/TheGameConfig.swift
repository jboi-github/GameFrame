//
//  TheGameConfig.swift
//  TheGame
//
//  Created by Juergen Boiselle on 18.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation
import GameUIKit
import GameFrameKit
import SwiftUI

class TheGameConfig: GameConfig {
    lazy var gameZone: some View = TheGameView()
    lazy var settingsZone: some View = TheGameSettingsView()
    lazy var noBannerZone: some View = Text("Thank you for playing The Game")

    let startsOffLevel: Bool = false
    
    func offLevelInformation(frame: CGRect) -> [[Information]] {
        if frame.width < frame.height {
            return [[
                .Achievement(id: "Medals", format: "%.1f"),
                .NonConsumable(id: "weaponB", opened: Image(systemName: "location"), closed: Image(systemName: "location.slash")),
                .NonConsumable(id: "weaponC", opened: Image(systemName: "location.fill"), closed: nil)
            ], [
                .Score(id: "Points"),
                .Consumable(id: "Bullets")
            ]]
        } else {
            return [[
                .Achievement(id: "Medals", format: "%.1f"),
                .Score(id: "Points"),
                .Consumable(id: "Bullets"),
                .NonConsumable(id: "weaponB", opened: Image(systemName: "location"), closed: Image(systemName: "location.slash")),
                .NonConsumable(id: "weaponC", opened: Image(systemName: "location.fill"), closed: nil)
            ]]
        }
    }
    
    // Just title
    var offLevelNavigationBarTitle: String = "The Game"
    var offLevelNavigationBarButton1: Navigation? = nil
    var offLevelNavigationBarButton2: Navigation? = nil

    func offLevelNavigation(frame: CGRect) -> [[Navigation]] {
        if frame.width < frame.height {
            return [[
                .Links(.Store()),
                .Buttons(.Reward(consumableId: "Bullets", quantity: 100))
            ], [
                .Buttons(.GameCenter()),
                .Buttons(.Share()),
                .Buttons(.Like(appId: 1293516048)) // TODO: Replace with real value from AppStore
            ], [
                .Generics(.Url("https://www.apple.com")),
                .Links(.Settings())
            ], [
                .Links(.Play())
            ]]
        } else {
            return [[
                .Links(.Store()),
                .Buttons(.Reward(consumableId: "Bullets", quantity: 100)),
                .Buttons(.GameCenter()),
                .Buttons(.Share()),
                .Buttons(.Like(appId: 1293516048)), // TODO: Replace with real value from AppStore
                .Generics(.Url("https://www.apple.com")),
                .Links(.Settings())
            ], [
                .Links(.Play())
            ]]
        }
    }
    
    func inLevelInformation(frame: CGRect) -> [[Information]] {
        [[
            .Score(id: "Points")
        ], [
            .Achievement(id: "Medals", format: "%.1f"),
            .Consumable(id: "Bullets")
        ]]
    }
    
    // Entirely hidden
    var inLevelNavigationBarTitle: String = ""
    var inLevelNavigationBarButton1: Navigation? = nil
    var inLevelNavigationBarButton2: Navigation? = nil

    func inLevelNavigation(frame: CGRect) -> [[Navigation]] {
        if frame.width < frame.height {
            return [
                [
                    .Links(.Back()),
                    .Buttons(.Reward(consumableId: "Bullets", quantity: 100))
                ], [
                    .Buttons(.Share()),
                    .Links(.Store())
                ]
            ]
        } else {
            return [
                [
                    .Links(.Back()),
                    .Links(.Store()),
                    .Buttons(.Reward(consumableId: "Bullets", quantity: 100)),
                    .Buttons(.Share())
                ]
            ]
        }
    }
    
    func settingsInformation(frame: CGRect) -> [[Information]] {
        [[
            .Achievement(id: "Medals", format: "%.1f"),
            .Consumable(id: "Bullets")
        ]]
    }
    
    // Only Navigation Bar
    var settingsNavigationBarTitle: String = "Settings"
    var settingsNavigationBarButton1: Navigation? = .Buttons(.SystemSettings())
    var settingsNavigationBarButton2: Navigation? = .Links(.Store())
    func settingsNavigation(frame: CGRect) -> [[Navigation]] {return [[Navigation]]()}

    let purchasables: [String: [GFInApp.Purchasable]] = [
        "bulletsS": [.Consumable(id: "Bullets", quantity: 200, canPrebook: true)],
        "bulletsM": [.Consumable(id: "Bullets", quantity: 1000, canPrebook: true)],
        "bulletsL": [.Consumable(id: "Bullets", quantity: 2000, canPrebook: false)],
        "Lives": [.Consumable(id: "Lives", quantity: 1, canPrebook: false)],
        "weaponB": [.NonConsumable(id: "weaponB", canPrebook: true)],
        "weaponC": [.NonConsumable(id: "weaponC", canPrebook: true)]]
    var storePurchasables: [GFInApp.Purchasable] = [
        .Consumable(id: "Bullets", quantity: 200),
        .Consumable(id: "Bullets", quantity: 1000),
        .Consumable(id: "Bullets", quantity: 2000),
        .NonConsumable(id: "weaponB"),
        .NonConsumable(id: "weaponC")
    ]
    var storeNavigationBarTitle: String = "Store"
    var storeRewardConsumableId: String? = "Bullets"
    var storeRewardQuantity: Int = 100

    let adUnitIdBanner: String? = "ca-app-pub-3940256099942544/2934735716" // TODO: Replace with id from Google AdMob
    let adUnitIdRewarded: String? = "ca-app-pub-3940256099942544/1712485313" // TODO: Replace with id from AppStore
    let adUnitIdInterstitial: String? = "ca-app-pub-3940256099942544/4411468910" // TODO: Replace with id from AppStore
    
    let adNonCosumableId: String? = "no-ads4"

    let sharedAppId: Int = 1293516048
    let sharedGreeting: String = "Hi! I'm playing The Game"
    let sharedInformations: [GFShareInformation] = [
        .Score("Points") {"My best: \($0.highest)"},
        .NonConsumable("weaponC") {$0.isOpened ? "Got the coolest weapon!" : "Struggeling to get weaponC. Can you help?"}
    ]
    
    let sounds: [String: (resource: String, type: String?)] = [
        "GrandOpening": (resource: "Bell", type: nil)
    ]
}

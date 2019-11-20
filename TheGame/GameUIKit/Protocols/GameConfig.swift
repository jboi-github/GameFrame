//
//  GameConfig.swift
//  GameUIKit
//
//  Created by Juergen Boiselle on 18.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation
import SwiftUI

public protocol GameConfig: ObservableObject {
    var offLevelInformation: [[InformationItem]] {get}
    var offLevelNavigation: [[NavigationItem]] {get}
    var inLevelInformation: [[InformationItem]] {get}
    var inLevelNavigation: [[NavigationItem]] {get}
    
    var productsToConsumables: [String: (consumable: String, quantity: Int)] {get}
    
    var adUnitIdBanner: String {get}
    var adUnitIdRewarded: String {get}
    var adUnitIdInterstitial: String {get}
}

// MARK: - GameConfig implementation for PreView

import GameFrameKit

class PreViewConfig: GameConfig {
    let offLevelInformation = [[InformationItem]]()
    let offLevelNavigation = [[NavigationItem]]()
    let inLevelInformation = [[InformationItem]]()
    let inLevelNavigation = [[NavigationItem]]()

    let productsToConsumables = [String: (consumable: String, quantity: Int)]()
    let adUnitIdBanner = ""
    let adUnitIdRewarded = ""
    let adUnitIdInterstitial = ""
}

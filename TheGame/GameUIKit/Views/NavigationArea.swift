//
//  NavigationArea.swift
//  TheGame
//
//  Created by Juergen Boiselle on 09.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

/**
 Navigation items to be used in configuration of the game. Each reflects a button with a certain behaviour and a default image.
 */
public enum NavigationItem {
    /// Start game or level.
    case PlayLink(image: Image = Image(systemName: "play"))
    /// Open store with given consumables and non-consumables.
    case StoreLink(image: Image = Image(systemName: "cart"), consumableIds: [String], nonConsumableIds: [String])
    /// Open Settings page for this game.
    case SettingsLink(image: Image = Image(systemName: "gear"))
    /// Go back one level in store or in-level
    case BackLink(image: Image = Image(systemName: "xmark"))

    /// Open external GameCenter
    case GameCenterLink(image: Image = Image(systemName: "rosette"))
    /// Open system dialog to share with other applications
    case ShareLink(image: Image = Image(systemName: "square.and.arrow.up"), greeting: String, format: String)
    /// Start rewarded video
    case RewardLink(image: Image = Image(systemName: "film"), consumableId: String, quantity: Int)
    /// Inform app store tp restore any existing purchases
    case RestoreLink(image: Image = Image(systemName: "arrow.uturn.right"))

    /// Open review page of given app id
    case LikeLink(image: Image = Image(systemName: "hand.thumbsup"), appId: String)
    /// Open system preferences for this app
    case SystemSettingsLink(image: Image = Image(systemName: "slider.horizontal.3"))

    /// Return from showing an offer
    case OfferBackLink(image: Image = Image(systemName: "xmark"))
    /// Return from error message
    case ErrorBackLink(image: Image = Image(systemName: "xmark"))

    /// Open any external URL
    case UrlLink(image: Image = Image(systemName: "link"), urlString: String)
    
    fileprivate struct AsView<C, S> where C: GameConfig, S: GameSkin {
        let item: NavigationItem
        
        /// config and skin are needed as of "Cannot explicitly specialize a generic function"
        fileprivate func asView(presentationMode: Binding<PresentationMode>) -> some View {
            switch item {
            case let .UrlLink(image: image, urlString: urlString):
                return AnyView(Button(action: getUrlAction(urlString)) {image})
                
            case let .GameCenterLink(image: image):
                return AnyView(Button(action: {GameFrame.gameCenter.show()}) {image})
            case let .ShareLink(image: image, greeting: greeting, format: format):
                return AnyView(Button(action: {GameFrame.instance!.showShare(greeting: greeting, format: format)}) {image})
            case let .RewardLink(image: image, consumableId: consumableId, quantity: quantity):
                return AnyView(Button(action: {
                    let consumable = GameFrame.coreData.getConsumable(consumableId)
                    GameFrame.adMob.showReward(consumable: consumable, quantity: quantity)
                }) {image})
            case let .RestoreLink(image: image):
                return AnyView(Button(action: {GameFrame.inApp.restore()}) {image})

            case let .LikeLink(image: image, appId: appId):
                return AnyView(Button(action: getUrlAction("https://itunes.apple.com/app/id\(appId)?action=write-review")) {image})
            case let .SystemSettingsLink(image: image):
                return AnyView(Button(action: getUrlAction(UIApplication.openSettingsURLString)) {image})

            case let .PlayLink(image: image):
                return AnyView(NavigationLink(destination: InLevelView<C, S>()) {image})
            case let .SettingsLink(image: image):
                return AnyView(NavigationLink(destination: SettingsView<C, S>()) {image})
            case let .StoreLink(image: image, consumableIds: consumableIds, nonConsumableIds: nonConsumableIds):
                return AnyView(NavigationLink(destination:
                    StoreView<C, S>(consumableIds: consumableIds, nonConsumableIds: nonConsumableIds)) {image})
                
            case let .BackLink(image: image):
                return AnyView(Button(action: {presentationMode.wrappedValue.dismiss()}) {image})
            case let .OfferBackLink(image: image):
                return AnyView(Button(action: {GameUI.instance.clearOffer()}) {image})
            case let .ErrorBackLink(image: image):
                return AnyView(Button(action: {GameFrame.inApp.clearError()}) {image})
            }
        }
    }
}

struct NavigationArea<C, S>: View where C: GameConfig, S: GameSkin {
    let parent: String
    let items: [[NavigationItem]]
    let isOverlayed: Bool
    @EnvironmentObject private var skin: S
    
    init(parent: String, items: [[NavigationItem]], isOverlayed: Bool = false) {
        self.parent = parent
        self.items = items
        self.isOverlayed = isOverlayed
    }
        
    private struct Item: View {
        let parent: String
        let row: Int
        let col: Int
        let item: NavigationItem
        let isOverlayed: Bool
        @ObservedObject private var inApp = GameFrame.inApp
        @ObservedObject private var adMob = GameFrame.adMob
        @ObservedObject private var gameCenter = GameFrame.gameCenter
        @EnvironmentObject private var skin: S
        @Environment(\.presentationMode) var presentationMode
        
        var body: some View {
            var disabled = isOverlayed
            
            if !disabled {
                switch item {
                case .GameCenterLink:
                    disabled = !gameCenter.enabled
                case .RewardLink:
                    disabled = !adMob.rewardAvailable
                case .RestoreLink:
                    disabled =  !inApp.available
                case .StoreLink:
                    disabled = !inApp.available
                default:
                    break
                }
            }
            
            return NavigationItem.AsView<C, S>(item: item).asView(presentationMode: presentationMode)
                .disabled(disabled)
                .buttonStyle(skin.getNavigationItemModifier(parent: parent, isDisabled: disabled, row: row, col: col))
        }
    }
    
    var body: some View {
        VStack {
            ForEach(0..<items.count, id: \.self) {
                row in
                
                HStack {
                    ForEach(0..<self.items[row].count, id: \.self) {
                        col in
                        
                        Item(
                            parent: self.parent, row: row, col: col,
                            item: self.items[row][col],
                            isOverlayed: self.isOverlayed)
                    }
                }
                .modifier(self.skin.getNavigationRowModifier(parent: self.parent, row: row))
            }
        }
    }
}

struct NavigationArea_Previews: PreviewProvider {
    static var previews: some View {
        NavigationArea<PreviewConfig, PreviewSkin>(
            parent: "Preview",
            items: [[
                .UrlLink(image: Image(systemName: "rosette"), urlString: "https://www.apple.com"),
                .UrlLink(image: Image(systemName: "gear"), urlString: "https://www.google.com")
            ], [
                .UrlLink(image: Image(systemName: "link"), urlString: "https://www.bing.com")
            ]])
        .environmentObject(PreviewSkin())
    }
}

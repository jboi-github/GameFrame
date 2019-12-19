//
//  NavigationItem.swift
//  GameUIKit
//
//  Created by Juergen Boiselle on 11.12.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

struct NavigationItem<C, S>: View where C: GameConfig, S: Skin {
    let parent: String
    let item: Navigation
    let isOverlayed: Bool
    let bounds: CGRect?
    let gameFrameId: String
    @State private var inAppAvailable = GameFrame.inApp.available
    @State private var rewardAvailable = GameFrame.adMob.rewardAvailable
    @State private var gameCenterEnabled = GameFrame.gameCenter.enabled
    @EnvironmentObject private var config: C
    @EnvironmentObject private var skin: S

    var body: some View {
        asView(item, bounds: bounds)
            .disabled(isDisabled(item))
            .buttonStyle(SkinButtonStyle(
                skin: skin, frameId: gameFrameId,
                item: .NavigationItem(parent: parent, isDisabled: isDisabled(item), item: item)))
            .storeFrame(gameFrameId)
            .onReceive(GameFrame.inApp.$available) {self.inAppAvailable = $0}
            .onReceive(GameFrame.adMob.$rewardAvailable) {self.rewardAvailable = $0}
            .onReceive(GameFrame.gameCenter.$enabled) {self.gameCenterEnabled = $0}
    }

    private func asView(_ item: Navigation, bounds: CGRect?) -> some View {
        switch item {
        case let .Generics(generic: generic):
            switch generic {
            case let .Action(action, image: image):
                return Button(action: action) {image}.anyView()
            case let .Url(urlString, image: image):
                return Button(action: getUrlAction(urlString)) {image}.anyView()
            }
        case let .Buttons(button: button):
            switch button {
            case let .ErrorBack(image: image):
                return Button(action: {GameFrame.inApp.clearError()}) {image}.anyView()
            case let .OfferBack(image: image):
                return Button(action: {GameUI.instance.clearOffer()}) {image}.anyView()
            case let .SystemSettings(image: image):
                return Button(action: getUrlAction(UIApplication.openSettingsURLString)) {image}.anyView()
            case let .Like(image: image, appId: appId):
                return Button(
                    action: getUrlAction("https://itunes.apple.com/app/id\(appId)?action=write-review")) {image}.anyView()
            case let .Restore(image: image):
                return Button(action: {GameFrame.inApp.restore()}) {image}.anyView()
            case let .Reward(image: image, consumableId: consumableId, quantity: quantity):
                return Button(action: {
                        let consumable = GameFrame.coreData.getConsumable(consumableId)
                        GameFrame.adMob.showReward(consumable: consumable, quantity: quantity)
                    }) {image}.anyView()
            case let .Share(image: image):
                return Button(action: {GameFrame.share.show(bounds: bounds)}) {image}.anyView()
            case let .GameCenter(image: image):
                return Button(action: {GameFrame.gameCenter.show()}) {image}.anyView()
        }
        case let .Links(link: link):
            switch link {
            case let .Play(image: image):
                return Button(action: {
                    GameUI.instance.navigator.push(.InLevel(title: self.config.inLevelNavigationBarTitle))
                }) {image}
                .anyView()
            case let .Store(image: image):
                return Button(action: {
                    GameUI.instance.navigator.push(.Store(title: self.config.storeNavigationBarTitle))
                }) {image}
                .anyView()
            case let .Settings(image: image):
                return Button(action: {
                    GameUI.instance.navigator.push(.Settings(title: self.config.settingsNavigationBarTitle))
                }) {image}
                .anyView()
            case let .Back(image: image, prevTitle: prevTitle):
                return Button(action: {GameUI.instance.navigator.pop()}) {
                    HStack {
                        image
                        Text(prevTitle)
                    }
                }.anyView()
            }
        }
    }

    private func isDisabled(_ item: Navigation) -> Bool {
        switch item {
        case .Generics:
            return false
        case let .Buttons(button: button):
            switch button {
            case .Restore:
                return !inAppAvailable
            case .Reward:
                return !rewardAvailable
            case .GameCenter:
                return !gameCenterEnabled
            case let .Like(image: _, appId: appId):
                return !canUrlAction("https://itunes.apple.com/app/id\(appId)?action=write-review")
            default: return false
        }
        case let .Links(link: link):
            switch link {
            case .Store:
                return !inAppAvailable
            default: return false
            }
        }
    }
}

struct NavigationItem_Previews: PreviewProvider {
    static var previews: some View {
        NavigationItem<PreviewConfig, PreviewSkin>(
            parent: "Preview", item: .Generics(.Url("https://www.apple.com")),
            isOverlayed: false, bounds: .zero,
            gameFrameId: "X-1")
            .environmentObject(PreviewSkin())
            .environmentObject(PreviewConfig())
    }
}

//
//  NavigationItem.swift
//  GameUIKit
//
//  Created by Juergen Boiselle on 11.12.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

struct NavigationItem<S>: View where S: Skin {
    let parent: String
    let item: Navigation
    let isOverlayed: Bool
    let bounds: CGRect?
    @ObservedObject private var inApp = GameFrame.inApp
    @ObservedObject private var adMob = GameFrame.adMob
    @ObservedObject private var gameCenter = GameFrame.gameCenter
    @EnvironmentObject private var skin: S

    var body: some View {
        asView(item, bounds: bounds)
            .disabled(isDisabled(item))
            .buttonStyle(SkinButtonStyle(
                skin: skin, item: .NavigationItem(parent: parent, isDisabled: isDisabled(item), item: item)))
    }

    private func asView(_ item: Navigation, bounds: CGRect?) -> some View {
        switch item {
        case let .Generics(generic: generic):
            switch generic {
            case let .Action(action, image: image):
                return AnyView(Button(action: action) {image})
            case let .Url(urlString, image: image):
                return AnyView(Button(action: getUrlAction(urlString)) {image})
            }
        case let .Buttons(button: button):
            switch button {
            case let .ErrorBack(image: image):
                return AnyView(Button(action: {GameFrame.inApp.clearError()}) {image})
            case let .OfferBack(image: image):
                return AnyView(Button(action: {GameUI.instance.clearOffer()}) {image})
            case let .SystemSettings(image: image):
                return AnyView(Button(action: getUrlAction(UIApplication.openSettingsURLString)) {image})
            case let .Like(image: image, appId: appId):
                return AnyView(Button(
                    action: getUrlAction("https://itunes.apple.com/app/id\(appId)?action=write-review")) {image})
            case let .Restore(image: image):
                return AnyView(Button(action: {GameFrame.inApp.restore()}) {image})
            case let .Reward(image: image, consumableId: consumableId, quantity: quantity):
                return AnyView(Button(action: {
                        let consumable = GameFrame.coreData.getConsumable(consumableId)
                        GameFrame.adMob.showReward(consumable: consumable, quantity: quantity)
                    }) {image})
            case let .Share(image: image):
                return AnyView(Button(action: {GameFrame.share.show(bounds: bounds)}) {image})
            case let .GameCenter(image: image):
                return AnyView(Button(action: {GameFrame.gameCenter.show()}) {image})
        }
        case let .Links(link: link):
            switch link {
            case let .Play(image: image):
                return AnyView(Button(action: {GameUI.instance.navigator.push(.InLevel)}) {image})
            case let .Store(image: image):
                return AnyView(Button(action: {GameUI.instance.navigator.push(.Store)}) {image})
            case let .Settings(image: image):
                return AnyView(Button(action: {GameUI.instance.navigator.push(.Settings)}) {image})
            case let .Back(image: image):
                return AnyView(Button(action: {GameUI.instance.navigator.pop()}) {image})
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
                return !inApp.available
            case .Reward:
                return !adMob.rewardAvailable
            case .GameCenter:
                return !gameCenter.enabled
            case let .Like(image: _, appId: appId):
                return !canUrlAction("https://itunes.apple.com/app/id\(appId)?action=write-review")
            default: return false
        }
        case let .Links(link: link):
            switch link {
            case .Store:
                return !inApp.available
            default: return false
            }
        }
    }
}

struct NavigationItem_Previews: PreviewProvider {
    static var previews: some View {
        NavigationItem<PreviewSkin>(
            parent: "Preview", item: .Generics(.Url("https://www.apple.com")), isOverlayed: false, bounds: .zero)
            .environmentObject(PreviewSkin())
            .environmentObject(PreviewConfig())
    }
}

//
//  NavigationArea.swift
//  TheGame
//
//  Created by Juergen Boiselle on 09.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

struct NavigationLayer<C, S>: View where C: GameConfig, S: Skin {
    let parent: String
    let items: [[Navigation]]
    let navbarItem: Navigation?
    let isOverlayed: Bool
    let bounds: CGRect?
    @EnvironmentObject private var skin: S
    
    init(parent: String,
         items: [[Navigation]],
         navbarItem: Navigation? = nil,
         bounds: CGRect? = nil,
         isOverlayed: Bool = false)
    {
        self.parent = parent
        self.items = items
        self.navbarItem = navbarItem
        self.bounds = bounds
        self.isOverlayed = isOverlayed
    }
    
    var body: some View {
        VStack {
            ForEach(0..<items.count, id: \.self) {
                row in
                
                HStack {
                    ForEach(0..<self.items[row].count, id: \.self) {
                        col in
                        
                        Item(
                            parent: self.parent,
                            item: self.items[row][col],
                            isOverlayed: self.isOverlayed,
                            bounds: self.bounds)
                    }
                }
                .build(self.skin, .Commons(.NavigationRow(parent: self.parent, row: row)))
            }
        }
        .navigationBarItems(
            trailing: navbarItem != nil ?
                AnyView(Item(parent: parent,
                    item: navbarItem!,
                    isOverlayed: isOverlayed,
                    bounds: bounds)) :
                AnyView(EmptyView()))
    }
    
    private struct Item: View {
        let parent: String
        let item: Navigation
        let isOverlayed: Bool
        let bounds: CGRect?
        @ObservedObject private var inApp = GameFrame.inApp
        @ObservedObject private var adMob = GameFrame.adMob
        @ObservedObject private var gameCenter = GameFrame.gameCenter
        @EnvironmentObject private var skin: S
        @Environment(\.presentationMode) private var presentationMode

        var body: some View {
            asView(item, bounds: bounds)
                .disabled(isDisabled(item))
                .buttonStyle(SkinButtonStyle(skin: skin, item: .NavigationItem(parent: parent, isDisabled: isDisabled(item), item: item)))
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
                    return AnyView(NavigationLink(destination: InLevelView<C, S>()) {image})
                case let .Store(image: image, consumableIds: consumableIds, nonConsumableIds: nonConsumableIds):
                    return AnyView(NavigationLink(destination: StoreView<C, S>(
                        consumableIds: consumableIds, nonConsumableIds: nonConsumableIds)) {image})
                case let .Settings(image: image):
                    return AnyView(NavigationLink(destination: SettingsView<C, S>()) {image})
                case let .Back(image: image):
                    return AnyView(Button(action: {self.presentationMode.wrappedValue.dismiss()}) {image})
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
}

struct NavigationLayer_Previews: PreviewProvider {
    static var previews: some View {
        NavigationLayer<PreviewConfig, PreviewSkin>(
            parent: "Preview",
            items: [[
                .Generics(.Url("https://www.apple.com")),
                .Generics(.Url("https://www.google.com")),
                .Generics(.Url("https://www.bing.com"))
            ]])
            .environmentObject(PreviewSkin())
            .environmentObject(PreviewConfig())
    }
}

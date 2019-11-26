//
//  NavigationArea.swift
//  TheGame
//
//  Created by Juergen Boiselle on 09.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit


struct NavigationArea<C, S>: View where C: GameConfig, S: GameSkin {
    let parent: String
    let items: [[Navigation]]
    let isOverlayed: Bool
    @EnvironmentObject private var skin: S
    
    init(parent: String, items: [[Navigation]], isOverlayed: Bool = false) {
        self.parent = parent
        self.items = items
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
                            row: row, col: col,
                            item: self.items[row][col],
                            isOverlayed: self.isOverlayed)
                    }
                }
                .modifier(self.skin.getNavigationRowModifier(parent: self.parent, row: row))
            }
        }
    }
    
    private struct Item: View {
        let parent: String
        let row: Int
        let col: Int
        let item: Navigation
        let isOverlayed: Bool
        @ObservedObject private var inApp = GameFrame.inApp
        @ObservedObject private var adMob = GameFrame.adMob
        @ObservedObject private var gameCenter = GameFrame.gameCenter
        @EnvironmentObject private var skin: S
        @Environment(\.presentationMode) private var presentationMode

        var body: some View {
            asView(item)
                .disabled(isDisabled(item))
                .buttonStyle(skin.getNavigationItemModifier(parent: parent, isDisabled: isDisabled(item), row: row, col: col))
        }

        private func asView(_ item: Navigation) -> some View {
            switch item {
            case let .Generics(generic: generic):
                switch generic {
                case let .Action(action: action, image: image):
                    return AnyView(Button(action: action) {image})
                case let .Url(urlString: urlString, image: image):
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
                case let .Share(image: image, greeting: greeting, format: format):
                    return AnyView(Button(action: {GameFrame.instance.showShare(greeting: greeting, format: format)}) {image})
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

struct NavigationArea_Previews: PreviewProvider {
    static var previews: some View {
        NavigationArea<PreviewConfig, PreviewSkin>(
            parent: "Preview",
            items: [[
                .Generics(generic: .Url(urlString: "https://www.apple.com")),
                .Generics(generic: .Url(urlString: "https://www.google.com")),
                .Generics(generic: .Url(urlString: "https://www.bing.com"))
            ]])
            .environmentObject(PreviewSkin())
            .environmentObject(PreviewConfig())
    }
}

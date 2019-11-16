//
//  OffLevel.swift
//  TheGame
//
//  Created by Juergen Boiselle on 01.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

struct OffLevelView<S>: View where S: Skin {
    var skin: S
    var geometryProxy: GeometryProxy
    @ObservedObject private var adMob = GameFrame.adMob
    @ObservedObject private var gameCenter = GameFrame.gameCenter
    @ObservedObject private var inApp = GameFrame.inApp
    
    var body: some View {
        VStack {
            InformationArea<S>(
                skin: skin, geometryProxy: geometryProxy,
                parent: "OffLevel",
                scoreIds: ["Points"], // TODO: Bring to some Game Configuration
                achievements: [(id:"Medals", format: "%.1f")],
                consumableIds: ["Bullets"],
                nonConsumables: [
                    (id: "weaponB", opened: Image(systemName: "location"), closed: Image(systemName: "location.slash")),
                    (id: "weaponC", opened: Image(systemName: "location.fill"), closed: nil)]
                    as [(id: String, opened: Image?, closed: Image?)])
                .modifier(skin.getOffLevelInformationModifier(geometryProxy: self.geometryProxy))
            Spacer()
            
            NavigationLink(destination: InLevelView(skin: skin, geometryProxy: geometryProxy)) {
                Image(systemName: "play")
            }
            .buttonStyle(skin.getOffLevelPlayButtonModifier(geometryProxy: self.geometryProxy, isDisabled: false))
            
            Spacer()
            // TODO: Bring to some Game Configuration
            NavigationArea<S>(
                skin: skin, geometryProxy: geometryProxy, parent: "OffLevel",
                navigatables: [
                    .ToStore(
                        image: Image(systemName: "cart"),
                        consumableIds: ["Bullets"],
                        nonConsumableIds: ["weaponB", "weaponC"],
                        disabled: false),// !inApp.available),
                    .Action(action: {
                        GameFrame.adMob.showReward(consumable: GameFrame.coreData.getConsumable("Bullets"), quantity: 100)
                     },
                     image: Image(systemName: "film"),
                     disabled: !adMob.rewardAvailable),
                    .Action(action: {GameFrame.gameCenter.show()},
                     image: Image(systemName: "rosette"),
                     disabled: !gameCenter.enabled),
                    .Action(action: {GameFrame.instance!.showShare(greeting: "Hi! I'm playing The Game", format: "%.1f")},
                     image: Image(systemName: "square.and.arrow.up"),
                     disabled: nil),
                    .Action(action: getUrlAction("https://itunes.apple.com/app/idX?action=write-review"),
                     image: Image(systemName: "hand.thumbsup"),
                     disabled: nil),
                    .Action(action: getUrlAction("https://www.apple.com"),
                     image: Image(systemName: "link"),
                     disabled: nil),
                    .Action(action: getUrlAction(UIApplication.openSettingsURLString),
                     image: Image(systemName: "gear"),
                     disabled: nil)])
            .modifier(skin.getOffLevelNavigationModifier(geometryProxy: self.geometryProxy))
        }
        .modifier(skin.getOffLevelModifier(geometryProxy: self.geometryProxy))
    }
}

struct OffLevel_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {
            OffLevelView(skin: PreviewSkin(), geometryProxy: $0)
        }
    }
}

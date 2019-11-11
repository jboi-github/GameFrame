//
//  OffLevel.swift
//  TheGame
//
//  Created by Juergen Boiselle on 01.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

struct OffLevel: View {
    @ObservedObject private var adMob = GameFrame.adMob
    @ObservedObject private var gameCenter = GameFrame.gameCenter
    @ObservedObject private var inApp = GameFrame.inApp
    @State private var showStore = false
    @State private var showInLevel = false
    
    var body: some View {
        VStack {
            // Remote controlled navigation as logic to enter level must be called
            NavigationLink(destination: StoreView(
                    consumableIds: ["Bullets"],
                    nonConsumableIds: ["weaponB", "weaponC"]),
                isActive: $showStore) {EmptyView()}
            NavigationLink(destination: InLevel(), isActive: $showInLevel) {EmptyView()}

            InformationArea(
                scoreIds: ["Points"],
                achievements: [(id:"Medals", format: "%.1f")],
                consumableIds: ["Bullets"],
                nonConsumables: [
                    (id: "weaponB", opened: Image(systemName: "location"), closed: Image(systemName: "location.slash")),
                    (id: "weaponC", opened: Image(systemName: "location.fill"), closed: nil)])
            Spacer()
            Button(action: {
                gameZoneController.enterLevel()
                self.showInLevel.set()
            }) {
                Image(systemName: "play.circle")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.5)
            }
            Spacer()
            NavigationArea(navigatables: [
                (action: {self.showStore.set()},
                 image: Image(systemName: "cart"),
                 disabled: !inApp.available),
                (action: {GameFrame.adMob.showReward(consumable: GameFrame.coreData.getConsumable("Bullets"), quantity: 100)},
                 image: Image(systemName: "film"),
                 disabled: !adMob.rewardAvailable),
                (action: {GameFrame.gameCenter.show()},
                 image: Image(systemName: "rosette"),
                 disabled: !gameCenter.enabled),
                (action: {GameFrame.instance!.showShare(greeting: "Hi! I'm playing The Game", format: "%.1f")},
                 image: Image(systemName: "square.and.arrow.up"),
                 disabled: nil),
                (action: getUrlAction("https://itunes.apple.com/app/idX?action=write-review"),
                 image: Image(systemName: "hand.thumbsup"),
                 disabled: nil),
                (action: getUrlAction("https://www.apple.com"),
                 image: Image(systemName: "link"),
                 disabled: nil),
                (action: getUrlAction(UIApplication.openSettingsURLString),
                 image: Image(systemName: "gear"),
                 disabled: nil)])
        }
        .modifier(NavigatableViewModifier())
    }
}

struct OffLevel_Previews: PreviewProvider {
    static var previews: some View {
        OffLevel()
    }
}

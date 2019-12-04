//
//  Settings.swift
//  GameUIKit
//
//  Created by Juergen Boiselle on 23.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI

struct SettingsView<C, S>: View where C: GameConfig, S: GameSkin {
    @State private var gameFrame: CGRect = .zero
    @State private var informationFrame: CGRect = .zero
    @State private var navigationFrame: CGRect = .zero
    @EnvironmentObject private var config: C
    @EnvironmentObject private var skin: S

    var body: some View {
        ZStack {
            // Spread to available display
            VStack{Spacer(); HStack{Spacer()}}
            EmptyView()
                .modifier(skin.getSettingsSpaceModifier(
                    gameFrame,
                    informationFrame: informationFrame,
                    navigationFrame: navigationFrame))
            NavigationLayer<C, S>(
                parent: "Settings",
                items: config.settingsNavigation(frame: gameFrame),
                navbarItem: config.settingsNavigationBar)
                .modifier(skin.getSettingsNavigationModifier())
                .getFrame($navigationFrame)
            InformationLayer<S>(
                parent: "Settings",
                items: config.settingsInformation(frame: gameFrame))
                .modifier(skin.getSettingsInformationModifier())
                .getFrame($informationFrame)
        }
        .modifier(skin.getSettingsModifier())
        .getFrame($gameFrame)
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView<PreviewConfig, PreviewSkin>()
        .environmentObject(PreviewConfig())
        .environmentObject(PreviewSkin())
    }
}

//
//  Settings.swift
//  GameUIKit
//
//  Created by Juergen Boiselle on 23.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI

struct SettingsView<C, S>: View where C: GameConfig, S: Skin {
    @State private var gameFrame: CGRect = .zero
    @State private var informationFrame: CGRect = .zero
    @State private var navigationFrame: CGRect = .zero
    @EnvironmentObject private var config: C
    @EnvironmentObject private var skin: S

    var body: some View {
        VStack {
            NavigationBar<S>(
                parent: "Settings",
                title: config.settingsNavigationBarTitle,
                item1: config.settingsNavigationBarButton1,
                item2: config.settingsNavigationBarButton2,
                bounds: gameFrame)
            ZStack {
                // Spread to available display
                VStack{Spacer(); HStack{Spacer()}}
                config.settingsZone
                    .build(skin, .Settings(.Space(
                        gameFrame,
                        informationFrame: informationFrame,
                        navigationFrame: navigationFrame)))
                InformationLayer<S>(
                    parent: "Settings",
                    items: config.settingsInformation(frame: gameFrame))
                    .getFrame($informationFrame)
                NavigationLayer<C, S>(
                    parent: "Settings",
                    items: config.settingsNavigation(frame: gameFrame))
                    .getFrame($navigationFrame)
            }
        }
        .build(skin, .Settings(.Main))
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

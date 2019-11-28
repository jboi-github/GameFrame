//
//  Settings.swift
//  GameUIKit
//
//  Created by Juergen Boiselle on 23.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI

struct SettingsView<C, S>: View where C: GameConfig, S: GameSkin {
    @State private var informationFrame: CGRect = .zero
    @State private var navigationFrame: CGRect = .zero
    @EnvironmentObject private var config: C
    @EnvironmentObject private var skin: S

    var body: some View {
        ZStack {
            GeometryReader {
                proxy in
                
                EmptyView()
                    .modifier(self.skin.getSettingsSpaceModifier(
                        proxy.frame(in: .named("SettingsView")),
                        informationFrame: self.informationFrame,
                        navigationFrame: self.navigationFrame))
            }
            VStack {
                NavigationArea<C, S>(
                    parent: "Settings",
                    items: config.settingsNavigation)
                    .modifier(skin.getSettingsNavigationModifier())
                    .framePreference("SettingsView", frame: $navigationFrame)
                InformationArea<S>(parent: "Settings", items: config.settingsInformation)
                    .modifier(skin.getSettingsInformationModifier())
                    .framePreference("SettingsView", frame: $informationFrame)
                Spacer()
            }
        }
        .modifier(skin.getSettingsModifier())
        .coordinateSpace(name: "SettingsView")
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView<PreviewConfig, PreviewSkin>()
        .environmentObject(PreviewConfig())
        .environmentObject(PreviewSkin())
    }
}

//
//  Settings.swift
//  GameUIKit
//
//  Created by Juergen Boiselle on 23.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI

struct SettingsView<C, S>: View where C: GameConfig, S: GameSkin {
    @EnvironmentObject private var config: C
    @EnvironmentObject private var skin: S
    
    var body: some View {
        VStack {
            InformationArea<S>(parent: "Settings", items: config.settingsInformation)
                .modifier(skin.getSettingsInformationModifier())
            
            Spacer().modifier(skin.getSettingsSpaceModifier())
            
            NavigationArea<S>(parent: "Settings", items: config.settingsNavigation)
                .modifier(skin.getSettingsNavigationModifier())
        }
        .modifier(skin.getSettingsModifier())
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView<PreViewConfig, PreviewSkin>()
        .environmentObject(PreViewConfig())
        .environmentObject(PreviewSkin())
    }
}

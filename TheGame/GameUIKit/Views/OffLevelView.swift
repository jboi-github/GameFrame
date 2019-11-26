//
//  OffLevel.swift
//  TheGame
//
//  Created by Juergen Boiselle on 01.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI

struct OffLevelView<C, S>: View where C: GameConfig, S: GameSkin {
    @EnvironmentObject private var config: C
    @EnvironmentObject private var skin: S
    
    var body: some View {
        VStack {
            NavigationArea<C, S>(parent: "OffLevel", items: config.offLevelNavigation)
                .modifier(skin.getOffLevelNavigationModifier())
             InformationArea<S>(parent: "OffLevel", items: config.offLevelInformation)
                .modifier(skin.getOffLevelInformationModifier())
            Spacer()
        }
        .modifier(skin.getOffLevelModifier())
    }
}

struct OffLevel_Previews: PreviewProvider {
    static var previews: some View {
        OffLevelView<PreviewConfig, PreviewSkin>()
        .environmentObject(PreviewConfig())
        .environmentObject(PreviewSkin())
    }
}

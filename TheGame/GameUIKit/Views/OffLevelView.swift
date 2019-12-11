//
//  OffLevel.swift
//  TheGame
//
//  Created by Juergen Boiselle on 01.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI

struct OffLevelView<C, S>: View where C: GameConfig, S: Skin {
    @State private var gameFrame: CGRect = .zero
    @EnvironmentObject private var config: C
    @EnvironmentObject private var skin: S
    
    var body: some View {
        VStack {
            NavigationBar<S>(
                parent: "OffLevel",
                title: config.offLevelNavigationBarTitle,
                item1: config.offLevelNavigationBarButton1,
                item2: config.offLevelNavigationBarButton2,
                bounds: gameFrame)
            ZStack {
                InformationLayer<S>(
                    parent: "OffLevel",
                    items: config.offLevelInformation(frame: gameFrame))
                NavigationLayer<C, S>(
                    parent: "OffLevel",
                    items: config.offLevelNavigation(frame: gameFrame))
            }
        }
        .build(skin, .OffLevel(.Main))
        .getFrame($gameFrame)
    }
}

struct OffLevel_Previews: PreviewProvider {
    static var previews: some View {
        OffLevelView<PreviewConfig, PreviewSkin>()
        .environmentObject(PreviewConfig())
        .environmentObject(PreviewSkin())
    }
}

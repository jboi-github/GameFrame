//
//  MainView.swift
//  TheGame
//
//  Created by Juergen Boiselle on 31.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

struct MainView<C, S>: View where C: GameConfig, S: Skin {
    @ObservedObject private var navigator = GameUI.instance.navigator
    @EnvironmentObject private var config: C
    @EnvironmentObject private var skin: S
    
    private struct Banner: View {
        @ObservedObject private var adMob = GameFrame.adMob
        @EnvironmentObject private var config: C
        @EnvironmentObject private var skin: S
        
        var body: some View {
            ZStack {
                GFBannerView() // Must be shown, otherwise AdMob doe not start to load anything
                if !adMob.bannerAvailable {config.noBannerZone}
            }
            .frame(width: adMob.bannerSize.width, height: adMob.bannerSize.height)
            .build(skin, .Main(.Banner(
                width: adMob.bannerSize.width,
                height: adMob.bannerSize.height,
                available: adMob.bannerAvailable)))
        }
    }
    
    var body: some View {
        VStack {
            asView(navigator.current)
            Banner()
        }
        .build(skin, .Main(.Main))
    }
    
    private func asView(_ item: GameNavigationModel.GameNavigation) -> some View {
        switch item {
        case .OffLevel:
            return OffLevelView<C, S>().anyView()
        case .InLevel:
            return InLevelView<C, S>().anyView()
        case .Settings:
            return SettingsView<C, S>().anyView()
        case .Store:
            return StoreView<C, S>().anyView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView<PreviewConfig, PreviewSkin>()
            .environmentObject(PreviewSkin())
            .environmentObject(PreviewConfig())
    }
}

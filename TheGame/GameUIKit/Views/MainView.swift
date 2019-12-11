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
            if navigator.current == .OffLevel {
                OffLevelView<C, S>()
            } else if navigator.current == .InLevel {
                InLevelView<C, S>()
            } else if navigator.current == .Settings {
                SettingsView<C, S>()
            } else if navigator.current == .Store {
                StoreView<C, S>()
            }
            Banner()
        }
        .build(skin, .Main(.Main))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView<PreviewConfig, PreviewSkin>()
            .environmentObject(PreviewSkin())
            .environmentObject(PreviewConfig())
    }
}

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
    @State private var startsInLevel: Bool = false
    @EnvironmentObject private var config: C
    @EnvironmentObject private var skin: S
    
    private struct Banner: View {
        @ObservedObject private var adMob = GameFrame.adMob
        @EnvironmentObject private var skin: S
        
        var body: some View {
            GFBannerView() // Must be shown, otherwise AdMob doe not start to load anything
                .frame(width: adMob.bannerSize.width, height: adMob.bannerSize.height)
                .build(skin, .Main(.Banner(
                    width: adMob.bannerSize.width,
                    height: adMob.bannerSize.height,
                    available: adMob.bannerAvailable)))
        }
    }
    
    var body: some View {
        VStack {
            NavigationView {
                OffLevelView<C, S>(startsInLevel: !config.startsOffLevel)
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

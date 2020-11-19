//
//  MainView.swift
//  TheGame
//
//  Created by Juergen Boiselle on 31.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

let mainFrameId = "mainFrameId"

private struct Banner<C, S>: View where C: GameConfig, S: Skin {
    @State private var bannerAvailable = GameFrame.adMob.bannerAvailable
    @State private var bannerSize = GameFrame.adMob.bannerSize
    @EnvironmentObject private var config: C
    @EnvironmentObject private var skin: S
    
    var body: some View {
        ZStack {
            GFBannerView() // Must be shown, otherwise AdMob doe not start to load anything
            if !bannerAvailable {config.noBannerZone}
        }
        .frame(width: bannerSize.width, height: bannerSize.height)
        .build(skin, .Main(.Banner(
            width: bannerSize.width,
            height: bannerSize.height)))
            .onReceive(GameFrame.adMob.$bannerSize) {self.bannerSize = $0}
            .onReceive(GameFrame.adMob.$bannerAvailable) {self.bannerAvailable = $0}
    }
}

public struct MainView<C, S>: View where C: GameConfig, S: Skin {
    @State private var current = -1
    @EnvironmentObject private var config: C
    @EnvironmentObject private var skin: S
    
    public init() {}
    
    public var body: some View {
        VStack {
            if current == 0 {
                OffLevelView<C, S>()
            } else if current == 1 {
                InLevelView<C, S>()
            } else if current == 2 {
                SettingsView<C, S>()
            } else if current == 3 {
                StoreView<C, S>()
            } else {
                Spacer()
                HStack{Spacer()}
            }
            Banner<C, S>()
        }
        .build(skin, .Main(.Main(current: current)))
        .storeFrame(mainFrameId)
        .onReceive(GameUI.instance.navigator.$current) {
            switch $0 {
            case .OffLevel:
                self.current = 0
            case .InLevel:
                self.current = 1
            case .Settings:
                self.current = 2
            case .Store:
                self.current = 3
            }
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

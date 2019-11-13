//
//  MainView.swift
//  TheGame
//
//  Created by Juergen Boiselle on 31.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

struct MainView<S>: View where S: Skin {
    var startsOffLevel: Bool
    var skin: S
    
    init(gameZoneDelegate: GameZoneDelegate, skin: S, startsOffLevel: Bool) {
        log()
        self.startsOffLevel = startsOffLevel
        self.skin = skin
        gameZoneController.setDelegate(delegate: gameZoneDelegate)
    }
    
    private struct Banner<S>: View where S: Skin {
        var skin: S
        @ObservedObject private var adMob = GameFrame.adMob
        
        var body: some View {
            ZStack {
                GFBannerView() // Must be called to get initial height & width
                if !adMob.bannerAvailable {
                    EmptyView()
                        .modifier(skin.getMainBannerEmptyModifier())
                }
            }
            .frame(width: adMob.bannerWidth, height: adMob.bannerHeight)
            .modifier(skin.getMainBannerModifier(width: adMob.bannerWidth, height: adMob.bannerHeight))
        }
    }
    
    var body: some View {
        VStack {
            GeometryReader {
                geometryProxy in
                
                NavigationView {
                    if self.startsOffLevel {
                        OffLevelView(skin: self.skin, geometryProxy: geometryProxy)
                    } else {
                        InLevelView(skin: self.skin, geometryProxy: geometryProxy)
                    }
                }
                .modifier(self.skin.getMainModifier(geometryProxy: geometryProxy))
            }
            Banner(skin: skin)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        GameFrame.createSharedInstanceForPreview(
            consumablesConfig: [:],
            adUnitIdBanner: nil,
            adUnitIdRewarded: nil,
            adUnitIdInterstitial: nil)
        
        return MainView(gameZoneDelegate: TheGameDelegate(), skin: SkinImpl(), startsOffLevel: true)
    }
}

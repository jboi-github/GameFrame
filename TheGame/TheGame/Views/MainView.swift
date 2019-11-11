//
//  MainView.swift
//  TheGame
//
//  Created by Juergen Boiselle on 31.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

struct MainView<V>: View where V: View {
    var bannerAlternative: V
    var startsOffLevel: Bool
    
    init(gameZoneDelegate: GameZoneDelegate, bannerAlternative: V, startsOffLevel: Bool) {
        log()
        self.bannerAlternative = bannerAlternative
        self.startsOffLevel = startsOffLevel
        
        gameZoneController.setDelegate(delegate: gameZoneDelegate)
    }
    
    private struct Banner<V>: View where V: View {
        var bannerAlternative: V
        @ObservedObject private var adMob = GameFrame.adMob
        
        var body: some View {
            ZStack {
                GFBannerView() // Must be called to get initial height & width
                if !adMob.bannerAvailable {bannerAlternative}
            }
            .frame(width: adMob.bannerWidth, height: adMob.bannerHeight)
        }
    }
    
    var body: some View {
        VStack {
            NavigationView {
                if startsOffLevel {
                    OffLevel()
                } else {
                    InLevel()
                }
            }
            Banner(bannerAlternative: bannerAlternative)
        }
        .modifier(BaseViewModifier())
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        GameFrame.createSharedInstanceForPreview(
            consumablesConfig: [:],
            adUnitIdBanner: nil,
            adUnitIdRewarded: nil,
            adUnitIdInterstitial: nil)
        
        return MainView(
            gameZoneDelegate: TheGameDelegate(),
            bannerAlternative: Text("Thank you for playing The Game"),
            startsOffLevel: true)
    }
}

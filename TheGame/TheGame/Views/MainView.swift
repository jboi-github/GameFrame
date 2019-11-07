//
//  MainView.swift
//  TheGame
//
//  Created by Juergen Boiselle on 31.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

struct MainView: View {
    private struct Banner: View {
        @ObservedObject private var adMob = GameFrame.adMob
        
        var body: some View {
            ZStack {
                GFBannerView() // Must be called to get initial height & width
                if !adMob.bannerAvailable {Text("Thank you for playing The Game")}
            }
            .frame(width: adMob.bannerWidth, height: adMob.bannerHeight)
        }
    }
    
    var body: some View {
        VStack {
            NavigationView {
                OffLevel()
            }
            Banner()
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
        
        return MainView()
    }
}

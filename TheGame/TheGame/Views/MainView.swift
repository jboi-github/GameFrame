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
    @ObservedObject var sheets = activeSheet
    @ObservedObject var inApp = GameFrame.inApp
    
    private struct Banner: View {
        @ObservedObject var adMob = GameFrame.adMob
        
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
            if inApp.purchasing {
                WaitView()
            } else if inApp.error != nil {
                ErrorView(error: inApp.error!)
            } else if sheets.current == .OffLevel {
                OffLevel()
            } else if sheets.current == .InLevel {
                InLevel()
            } else if sheets.current == .Store {
                StoreView()
            } else if sheets.current == .Offer {
                AdHocOfferView()
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

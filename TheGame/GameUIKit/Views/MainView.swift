//
//  MainView.swift
//  TheGame
//
//  Created by Juergen Boiselle on 31.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

struct MainView<C, S>: View where C: GameConfig, S: GameSkin {
    @EnvironmentObject private var config: C
    @EnvironmentObject private var skin: S
    @State private var isStarting: Bool = true

    private struct Banner: View {
        @ObservedObject private var adMob = GameFrame.adMob
        @EnvironmentObject private var skin: S
        
        var body: some View {
            ZStack {
                GFBannerView() // Must be shown, otherwise AdMob doe not start to load anything
                if !adMob.bannerAvailable {
                    EmptyView()
                        .modifier(skin.getMainBannerEmptyModifier())
                }
            }
            .frame(width: adMob.bannerSize.width, height: adMob.bannerSize.height)
            .modifier(skin.getMainBannerModifier(width: adMob.bannerSize.width, height: adMob.bannerSize.height))
        }
    }
    
    var body: some View {
        VStack {
            Text("\(isStarting ? "YES":"NO")")
            
            // TODO: Take care of startsOffLevel
            NavigationView {
                OffLevelView<C, S>()
            }
            Banner()
        }
        .onAppear {
            log("1 *********", self.isStarting)
            DispatchQueue.main.async {
                log("2 ***********", self.isStarting)
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

//
//  OffLevel.swift
//  TheGame
//
//  Created by Juergen Boiselle on 01.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI

struct OffLevelView<C, S>: View where C: GameConfig, S: Skin {
    @State var startsInLevel: Bool
    @State private var gameFrame: CGRect = .zero
    @EnvironmentObject private var config: C
    @EnvironmentObject private var skin: S
    
    var body: some View {
        VStack {
            HStack{Spacer()}
            NavigationLink(destination: InLevelView<C, S>(), isActive: $startsInLevel) {EmptyView()}
            
            if !startsInLevel {
                ZStack {
                    InformationLayer<S>(
                        parent: "OffLevel",
                        items: config.offLevelInformation(frame: gameFrame))
                        .build(skin, .OffLevel(.Information))
                    NavigationLayer<C, S>(
                        parent: "OffLevel",
                        items: config.offLevelNavigation(frame: gameFrame),
                        navbarItem: config.offLevelNavigationBar)
                        .build(skin, .OffLevel(.Navigation))
                }
            }
        }
        .build(skin, .OffLevel(.Main))
        .getFrame($gameFrame)
    }
}

struct OffLevel_Previews: PreviewProvider {
    static var previews: some View {
        OffLevelView<PreviewConfig, PreviewSkin>(startsInLevel: false)
        .environmentObject(PreviewConfig())
        .environmentObject(PreviewSkin())
    }
}

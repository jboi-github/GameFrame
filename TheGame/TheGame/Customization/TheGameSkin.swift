//
//  TheGameSkin.swift
//  TheGame
//
//  Created by Juergen Boiselle on 13.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit
import GameUIKit

// MARK: The GameZone View
struct TheGameZoneModifier: ViewModifier {
    let selfFrame: CGRect
    let informationFrame: CGRect
    let navigationFrame: CGRect

    func body(content: Content) -> some View {TheGameView().background(Color.yellow)}
}

struct TheGameSettingsSpaceModifier: ViewModifier {
    let selfFrame: CGRect
    let informationFrame: CGRect
    let navigationFrame: CGRect

    func body(content: Content) -> some View {TheGameSettingsView().background(Color.yellow)}
}

struct TheGameMainBannerEmptyModifier: ViewModifier {
    func body(content: Content) -> some View {
        Text("Thank you for playing The Game")
            .foregroundColor(.secondary)
            .background(Color.primary.colorInvert()) // Ensure opaque background
    }
}

struct TheGameNavigationItemModifier: ButtonStyle {
    var parent: String
    var isDisabled: Bool
    var row: Int
    var col: Int

    func makeBody(configuration: Self.Configuration) -> some View {
        VStack {
            // Make the play button big
            if parent == "OffLevel" && row == 3 && col == 0 {
                Image(systemName: "play.circle")
                    .resizable().scaledToFit()
                    .foregroundColor(isDisabled ? Color.secondary : Color.accentColor)
                    .padding()
            } else {
                configuration.label
                    .foregroundColor(isDisabled ? Color.secondary : Color.accentColor)
                    .padding()
            }
        }
    }
}

struct TheGameOffLevelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationBarTitle("The Game")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct TheGameSettingsModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationBarTitle("The Game")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct TheGameInLevelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationBarTitle("The Game")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

// MARK: - A Skin that delegates to standard skin implementation
class TheGameSkin: GameSkin {
    // Add The Game Gamezone
    func getInLevelGameZoneModifier(_ selfFrame: CGRect, informationFrame: CGRect, navigationFrame: CGRect)
        -> some ViewModifier
    {
        TheGameZoneModifier(selfFrame: selfFrame, informationFrame: informationFrame, navigationFrame: navigationFrame)
    }
    
    // Add The Game settings
    func getSettingsSpaceModifier(_ selfFrame: CGRect, informationFrame: CGRect, navigationFrame: CGRect)
        -> some ViewModifier
    {
        TheGameSettingsSpaceModifier(selfFrame: selfFrame, informationFrame: informationFrame, navigationFrame: navigationFrame)
    }
    
    // Add placeholder, when no banner available
    func getMainBannerEmptyModifier() -> some ViewModifier {TheGameMainBannerEmptyModifier()}

    // Get a big play-button
    func getNavigationItemModifier(parent: String, isDisabled: Bool, row: Int, col: Int) -> some ButtonStyle {
         TheGameNavigationItemModifier(parent: parent, isDisabled: isDisabled, row: row, col: col)
    }
    
    func getOffLevelModifier() -> some ViewModifier {
         TheGameOffLevelModifier()
    }
    
    func getSettingsModifier() -> some ViewModifier {
         TheGameSettingsModifier()
    }
    
    func getInLevelModifier() -> some ViewModifier {
        TheGameInLevelModifier()
    }
}

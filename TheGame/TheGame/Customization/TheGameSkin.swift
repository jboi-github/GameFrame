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
    func body(content: Content) -> some View {TheGameView().background(Color.yellow)}
}

// MARK: - A Skin that delegates to standard skin implementation
class TheGameSkin: GameSkin {
     func getInLevelGameZoneModifier() -> some ViewModifier {TheGameZoneModifier()}
}

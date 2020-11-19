//
//  TheGameStarter.swift
//  TheGame
//
//  Created by Jürgen Boiselle on 19.11.20.
//  Copyright © 2020 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameUIKit

@main
struct TheGameStarter: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            GameUI.createSharedInstance(
                gameConfig: TheGameConfig(),
                gameDelegate: TheGameDelegate(),
                gameSkin: TheGameSkin())
        }
    }
}

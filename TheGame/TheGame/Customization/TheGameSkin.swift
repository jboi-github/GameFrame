//
//  TheGameSkin.swift
//  TheGame
//
//  Created by Juergen Boiselle on 13.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameUIKit

/**
 Central Modifier for all views in The Game
 */
class TheGameSkin: SimpleSkin {
    init() {
        super.init(
            primaryColor: UIColor.lightGray,
            secondaryColor: UIColor.systemRed,
            accentColor: UIColor.systemRed,
            primaryInvertColor: UIColor.darkGray,
            secondaryInvertColor: UIColor.lightGray,
            accentInvertColor: UIColor.systemGreen,
            smoothDuration: 5.0)
    }
}

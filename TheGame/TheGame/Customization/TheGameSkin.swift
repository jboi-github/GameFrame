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

/**
 Central Modifier for all views in The Game
 */
class TheGameSkin: SimpleSkin {
    init() {
        super.init(
            offLevelTitle: "The Game",
            primaryColor: UIColor.lightGray,
            secondaryColor: UIColor.systemRed,
            accentColor: UIColor.systemRed,
            primaryInvertColor: UIColor.darkGray,
            secondaryInvertColor: UIColor.lightGray,
            accentInvertColor: UIColor.systemGreen)
    }
    
    override public func build(_ item: SkinItem.SkinItemView, view: AnyView) -> AnyView {
        switch item {
        case let .InLevel(item: inLevelItem):
            switch inLevelItem {
            case .GameZone:
                return AnyView(TheGameView().background(Color.yellow))
            default:
                return super.build(item, view: view)
            }
        case let .Settings(item: settingsItem):
            switch settingsItem {
            case .Space:
                return AnyView(TheGameSettingsView().background(Color.yellow))
            default:
                return super.build(item, view: view)
            }
        case let .Main(item: mainItem):
            switch mainItem {
            case let .Banner(width: width, height: height, available: available):
                return AnyView(
                    ZStack {
                        view
                        if !available {
                            Text("Thank you for playing The Game")
                            .frame(width: width, height: height)
                            .foregroundColor(Color(.lightGray))
                            .background(Color(.darkGray)) // Ensure opaque background
                        }
                    }
                )
            default:
                return super.build(item, view: view)
            }
        default:
            return super.build(item, view: view)
        }
    }
}

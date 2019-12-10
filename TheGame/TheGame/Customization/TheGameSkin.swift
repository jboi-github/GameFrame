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
/**
 Central Modifier for all views in The Game
 */
struct TheGameViewModifier: ViewModifier {
    let item: SkinItem.SkinItemView
    
    func body(content: Content) -> some View {
        switch item {
        case let .InLevel(item: inLevelItem):
            switch inLevelItem {
            case .GameZone:
                return AnyView(TheGameView().background(Color.yellow))
            default:
                return AnyView(content)
            }
        case let .Settings(item: settingsItem):
            switch settingsItem {
            case .Space:
                return AnyView(TheGameSettingsView().background(Color.yellow))
            default:
                return AnyView(content)
            }
        case let .Main(item: mainItem):
            switch mainItem {
            case let .Banner(width: width, height: height, available: available):
                return AnyView(
                    VStack {
                        if !available {
                            Text("Thank you for playing The Game")
                            .frame(width: width, height: height)
                            .foregroundColor(.secondary)
                            .background(Color.primary.colorInvert()) // Ensure opaque background
                        }
                    }
                )
            default:
                return AnyView(content)
            }
        default:
            return AnyView(content)
        }
    }
}

// MARK: - A Skin that delegates to standard skin implementation
class TheGameSkin: SimpleSkin {
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
                    VStack {
                        if !available {
                            Text("Thank you for playing The Game")
                            .frame(width: width, height: height)
                            .foregroundColor(.secondary)
                            .background(Color.primary.colorInvert()) // Ensure opaque background
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

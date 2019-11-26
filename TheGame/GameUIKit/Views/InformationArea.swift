//
//  InformationArea.swift
//  TheGame
//
//  Created by Juergen Boiselle on 08.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

/**
 Information items to be used in configuration of the game. Each reflects an information.
*/
struct InformationArea<S>: View where S: GameSkin {
    let parent: String
    let items: [[Information]]
    @EnvironmentObject private var skin: S

    var body: some View {
        VStack {
            ForEach(0..<items.count, id: \.self) {
                row in
                
                HStack {
                    ForEach(0..<self.items[row].count, id: \.self) {
                        col in
                        
                        Item<S>(parent: self.parent, row: row, col: col, item: self.items[row][col])
                    }
                }
                .modifier(self.skin.getInformationRowModifier(parent: self.parent, row: row))
            }
        }
    }
    
    private struct Item<S>: View where S: GameSkin {
        let parent: String
        let row: Int
        let col: Int
        let item: Information
        @EnvironmentObject private var skin: S
        
        var body: some View {
            switch item {
            case let .Achievement(id: id, format: format):
                return AnyView(AchievementView<S>(parent: parent, id: id, format: format))
            case let .Score(id: id):
                return AnyView(ScoreView<S>(parent: parent, id: id))
            case let .Consumable(id: id):
                return AnyView(ConsumableView<S>(parent: parent, id: id))
            case let .NonConsumable(id: id, opened: opened, closed: closed):
                return AnyView(NonConsumableView<S>(parent: parent, id: id, opened: opened, closed: closed))
            }
        }
        
        private struct AchievementView<S>: View where S: GameSkin {
            let parent: String
            let id: String
            let format: String
            @ObservedObject private var achievement: GFAchievement
            @EnvironmentObject private var skin: S
            
            init(parent: String, id: String, format: String) {
                self.parent = parent
                self.id = id
                self.format = format
                achievement = GameFrame.coreData.getAchievement(id)
            }
            
            var body: some View {
                Text("\(achievement.current.format(format))")
                    .modifier(skin.getInformationItemModifier(parent: parent, id: id))
            }
        }
        
        private struct ScoreView<S>: View where S: GameSkin {
            let parent: String
            let id: String
            @ObservedObject private var score: GFScore
            @EnvironmentObject private var skin: S
            
            init(parent: String, id: String) {
                self.parent = parent
                self.id = id
                score = GameFrame.coreData.getScore(id)
            }
            
            var body: some View {
                Text("\(score.current) / \(score.highest)")
                    .modifier(skin.getInformationItemModifier(parent: parent, id: id))
            }
        }
        
        private struct ConsumableView<S>: View where S: GameSkin {
            let parent: String
            let id: String
            @ObservedObject private var consumable: GFConsumable
            @EnvironmentObject private var skin: S
            
            init(parent: String, id: String) {
                self.parent = parent
                self.id = id
                consumable = GameFrame.coreData.getConsumable(id)
            }
            
            var body: some View {
                Text("\(consumable.available)")
                    .modifier(skin.getInformationItemModifier(parent: parent, id: id))
            }
        }

        private struct NonConsumableView<S>: View where S: GameSkin {
            let parent: String
            let id: String
            let opened: Image
            let closed: Image?
            @ObservedObject private var nonConsumable: GFNonConsumable
            @EnvironmentObject private var skin: S
            
            init(parent: String, id: String, opened: Image, closed: Image?) {
                self.parent = parent
                self.id = id
                self.opened = opened
                self.closed = closed
                nonConsumable = GameFrame.coreData.getNonConsumable(id)
            }
            
            var body: some View {
                HStack {
                    if nonConsumable.isOpened {
                        opened
                    } else if closed != nil {
                        closed!
                    }
                }
                .modifier(skin.getInformationNonConsumableModifier(parent: parent, id: id))
            }
        }
    }
}

struct InformationArea_Previews: PreviewProvider {
    static var previews: some View {
        InformationArea<PreviewSkin>(
            parent: "Preview",
            items: [
                [
                    .Score(id: "Points"),
                    .Consumable(id: "Bullets")
                ], [
                    .Achievement(id: "Medals", format: "%.1f"),
                    .NonConsumable(
                        id: "weaponB", opened: Image(systemName: "location"),
                        closed: Image(systemName: "location.slash")),
                    .NonConsumable(id: "weaponC", opened: Image(systemName: "location.fill"), closed: nil)
                ]
            ])
        .environmentObject(PreviewSkin())
    }
}

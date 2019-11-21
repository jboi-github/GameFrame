//
//  InformationArea.swift
//  TheGame
//
//  Created by Juergen Boiselle on 08.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

// MARK: Publicly available information items
public enum InformationItem {
    case ScoreItem(id: String)
    case AchievementItem(id: String, format: String)
    case ConsumableItem(id: String)
    case NonConsumableItem(id: String, opened: Image, closed: Image?)

    private struct InformationScore<S>: View where S: GameSkin {
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
                .modifier(skin.getInformationScoreModifier(parent: parent, id: id))
        }
    }

    private struct InformationAchievement<S>: View where S: GameSkin {
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
                .modifier(skin.getInformationAchievementModifier(parent: parent, id: id))
        }
    }

    private struct InformationConsumable<S>: View where S: GameSkin {
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
                .modifier(skin.getInformationConsumableModifier(parent: parent, id: id))
        }
    }

    private struct InformationNonConsumable<S>: View where S: GameSkin {
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

    private typealias Unpacked<S> = (
        score: InformationScore<S>?,
        achievement: InformationAchievement<S>?,
        consumable: InformationConsumable<S>?,
        nonConsumable: InformationNonConsumable<S>?)
        where S: GameSkin
    
    private func unpack<S>(parent: String) -> Unpacked<S> {
        switch self {
        case let .ScoreItem(id: id):
            return (
                score: InformationScore<S>(parent: parent, id: id),
                achievement: nil,
                consumable: nil,
                nonConsumable: nil)
        case let .AchievementItem(id: id, format: format):
            return (
                score: nil,
                achievement: InformationAchievement<S>(parent: parent, id: id, format: format),
                consumable: nil,
                nonConsumable: nil)
        case let .ConsumableItem(id: id):
            return (
                score: nil,
                achievement: nil,
                consumable: InformationConsumable<S>(parent: parent, id: id),
                nonConsumable: nil)
        case let .NonConsumableItem(id: id, opened: opened, closed: closed):
            return (
                score: nil,
                achievement: nil,
                consumable: nil,
                nonConsumable: InformationNonConsumable<S>(parent: parent, id: id, opened: opened, closed: closed))
        }
    }
    
    fileprivate func asView<S>(parent: String, gameSkin: S) -> some View where S: GameSkin {
        let item: Unpacked<S> = unpack(parent: parent)
        
        return VStack {
            if item.score != nil {
                item.score!
            } else if item.achievement != nil {
                item.achievement!
            } else if item.consumable != nil {
                item.consumable!
            } else if item.nonConsumable != nil {
                item.nonConsumable!
            }
        }
    }
}

// MARK: Information Area implementation
struct InformationArea<S>: View where S: GameSkin {
    let parent: String
    let items: [[InformationItem]]
    @EnvironmentObject private var skin: S

    var body: some View {
        VStack {
            ForEach(0..<items.count, id: \.self) {
                row in
                
                HStack {
                    ForEach(0..<self.items[row].count, id: \.self) {
                        col in
                        self.items[row][col].asView(parent: self.parent, gameSkin: self.skin)
                    }
                }
                .modifier(self.skin.getInformationRowModifier(parent: self.parent, row: row))
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
                .ScoreItem(id: "Points"),
                .ConsumableItem(id: "Bullets"),
                ], [
                .AchievementItem(id: "Medals", format: "%.1f"),
                .NonConsumableItem(id: "weaponB",
                                   opened: Image(systemName: "location"), closed: Image(systemName: "location.slash")),
                .NonConsumableItem(id: "weaponC", opened: Image(systemName: "location.fill"), closed: nil)
                ]
            ])
        .environmentObject(PreviewSkin())
    }
}

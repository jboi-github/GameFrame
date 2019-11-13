//
//  InformationArea.swift
//  TheGame
//
//  Created by Juergen Boiselle on 08.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

struct InformationArea<S>: View where S: Skin {
    var skin: S
    var geometryProxy: GeometryProxy
    var parent: String
    var scoreIds: [String]
    var achievements: [(id:String, format: String)]
    var consumableIds: [String]
    var nonConsumables: [(id: String, opened: Image?, closed: Image?)]

    private struct InformationScore<S>: View where S: Skin {
        var skin: S
        var geometryProxy: GeometryProxy
        var parent: String
        var id: String
        @ObservedObject var score: GFScore
        
        var body: some View {
            Text("\(score.current) / \(score.highest)")
                .modifier(skin.getInformationScoreModifier(geometryProxy: self.geometryProxy, id: id))
        }
    }
    
    private struct InformationAchievement<S>: View where S: Skin {
        var skin: S
        var geometryProxy: GeometryProxy
        var parent: String
        var id: String
        @ObservedObject var achievement: GFAchievement
        var format: String
        
        var body: some View {
            Text("\(achievement.current.format(format))")
                .modifier(skin.getInformationAchievementModifier(geometryProxy: self.geometryProxy, id: id))
        }
    }
    
    private struct InformationConsumable<S>: View where S: Skin {
        var skin: S
        var geometryProxy: GeometryProxy
        var parent: String
        var id: String
        @ObservedObject var consumable: GFConsumable
        
        var body: some View {
            Text("\(consumable.available)")
                .modifier(skin.getInformationConsumableModifier(geometryProxy: self.geometryProxy, id: id))
        }
    }
    
    private struct InformationNonConsumable<S>: View where S: Skin {
        var skin: S
        var geometryProxy: GeometryProxy
        var parent: String
        var id: String
        @ObservedObject var nonConsumable: GFNonConsumable
        var closed: Image?
        var opened: Image?
        
        var body: some View {
            HStack {
                if nonConsumable.isOpened {
                    if opened != nil {opened!}
                } else if closed != nil {
                    closed!
                }
            }
            .modifier(skin.getInformationNonConsumableModifier(geometryProxy: self.geometryProxy, id: id))
        }
    }

    var body: some View {
        HStack {
            ForEach(0..<achievements.count, id: \.self) {
                id in
                HStack {
                    Spacer()
                    InformationAchievement(
                        skin: self.skin, geometryProxy: self.geometryProxy,
                        parent: self.parent,
                        id: self.achievements[id].id,
                        achievement: GameFrame.coreData.getAchievement(self.achievements[id].id),
                        format: self.achievements[id].format)
                    Spacer()
                }
            }
            .modifier(skin.getInformationAchievementsModifier(geometryProxy: self.geometryProxy))
            
            ForEach(scoreIds, id: \.self) {
                id in
                HStack {
                    Spacer()
                    InformationScore(skin: self.skin, geometryProxy: self.geometryProxy, parent: self.parent, id: id, score: GameFrame.coreData.getScore(id))
                    Spacer()
                }
            }
            .modifier(skin.getInformationScoresModifier(geometryProxy: self.geometryProxy))

            ForEach(consumableIds, id: \.self) {
                id in
                HStack {
                    Spacer()
                    InformationConsumable(skin: self.skin, geometryProxy: self.geometryProxy, parent: self.parent, id: id, consumable: GameFrame.coreData.getConsumable(id))
                    Spacer()
                }
            }
            .modifier(skin.getInformationConsumablesModifier(geometryProxy: self.geometryProxy))
            
            if !nonConsumables.isEmpty {
                HStack {
                    Spacer()
                    ForEach(0..<nonConsumables.count, id: \.self) {
                        id in
                        InformationNonConsumable(
                            skin: self.skin, geometryProxy: self.geometryProxy,
                            parent: self.parent,
                            id: self.nonConsumables[id].id,
                            nonConsumable: GameFrame.coreData.getNonConsumable(self.nonConsumables[id].id),
                            closed: self.nonConsumables[id].closed,
                            opened: self.nonConsumables[id].opened)
                    }
                    .modifier(skin.getInformationNonConsumablesModifier(geometryProxy: self.geometryProxy))
                    Spacer()
                }
            }
        }
    }
}

struct InformationArea_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {
            InformationArea(
                skin: SkinImpl(),
                geometryProxy: $0,
                parent: "Preview",
                scoreIds: ["Points"],
                achievements: [(id: "Medals", format: "%.1f")],
                consumableIds: ["Bullets"],
                nonConsumables: [
                    (id: "weaponB", opened: nil, closed: Image(systemName: "location.slash")),
                    (id: "weaponC", opened: Image(systemName: "location.fill"), closed: Image(systemName: "location"))])
        }
    }
}

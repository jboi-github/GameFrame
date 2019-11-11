//
//  InformationArea.swift
//  TheGame
//
//  Created by Juergen Boiselle on 08.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

struct InformationArea: View {
    var scoreIds: [String]
    var achievements: [(id:String, format: String)]
    var consumableIds: [String]
    var nonConsumables: [(id: String, opened: Image?, closed: Image?)]

    private struct InformationScore: View {
        @ObservedObject var score: GFScore
        
        var body: some View {
            Text("\(score.current) / \(score.highest)")
        }
    }
    
    private struct InformationAchievement: View {
        @ObservedObject var achievement: GFAchievement
        var format: String
        
        var body: some View {
            Text("\(achievement.current.format(format))")
        }
    }
    
    private struct InformationConsumable: View {
        @ObservedObject var consumable: GFConsumable
        
        var body: some View {
            Text("\(consumable.available)")
        }
    }
    
    private struct InformationNonConsumable: View {
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
        }
    }

    var body: some View {
        HStack {
            ForEach(0..<achievements.count, id: \.self) {
                id in
                HStack {
                    Spacer()
                    InformationAchievement(
                        achievement: GameFrame.coreData.getAchievement(self.achievements[id].id),
                        format: self.achievements[id].format)
                    Spacer()
                }
            }
            ForEach(scoreIds, id: \.self) {
                id in
                HStack {
                    Spacer()
                    InformationScore(score: GameFrame.coreData.getScore(id))
                    Spacer()
                }
            }
            ForEach(consumableIds, id: \.self) {
                id in
                HStack {
                    Spacer()
                    InformationConsumable(consumable: GameFrame.coreData.getConsumable(id))
                    Spacer()
                }
            }
            if !nonConsumables.isEmpty {
                HStack {
                    Spacer()
                    ForEach(0..<nonConsumables.count, id: \.self) {
                        id in
                        InformationNonConsumable(
                            nonConsumable: GameFrame.coreData.getNonConsumable(self.nonConsumables[id].id),
                            closed: self.nonConsumables[id].closed,
                            opened: self.nonConsumables[id].opened)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct InformationArea_Previews: PreviewProvider {
    static var previews: some View {
        InformationArea(
            scoreIds: ["Points"],
            achievements: [(id: "Medals", format: "%.1f")],
            consumableIds: ["Bullets"],
            nonConsumables: [
                (id: "weaponB", opened: nil, closed: Image(systemName: "location.slash")),
                (id: "weaponC", opened: Image(systemName: "location.fill"), closed: Image(systemName: "location"))])
    }
}

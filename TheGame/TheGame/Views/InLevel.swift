//
//  InLevel.swift
//  TheGame
//
//  Created by Juergen Boiselle on 01.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

struct InLevel: View {
    @ObservedObject var sheets = activeSheet
    @ObservedObject private var points = GameFrame.coreData.getScore("Points")
    @ObservedObject private var bullets = GameFrame.coreData.getConsumable("Bullets")

    private struct Information: View {
        @ObservedObject private var points = GameFrame.coreData.getScore("Points")
        @ObservedObject private var medals = GameFrame.coreData.getAchievement("Medals")
        @ObservedObject private var bullets = GameFrame.coreData.getConsumable("Bullets")

        var body: some View {
            HStack {
                Text("\(medals.current.format("%.2f"))")
                Image(systemName: "star.circle.fill")
                Spacer()
                Text("\(points.current)")
                    .foregroundColor((points.current == points.highest) ? .accentColor : .primary)
                Spacer()
                Text("\(bullets.available)")
                Image(systemName: "bolt.fill")
            }
            .padding()
        }
    }
    
    private struct Navigation: View {
        @ObservedObject var sheets = activeSheet
        @ObservedObject private var adMob = GameFrame.adMob
        @ObservedObject private var inApp = GameFrame.inApp
        @ObservedObject private var bullets = GameFrame.coreData.getConsumable("Bullets")

        var body: some View {
            HStack {
                Spacer()
                Button(action: {
                    self.sheets.next(.OffLevel)
                }) {
                    Image(systemName: "xmark")
                }
                Spacer()
                Button(action: {self.sheets.next(.Store)}) {
                    Image(systemName: "cart")
                }
                .disabled(!inApp.available)
                Spacer()
                Button(action: {GameFrame.adMob.showReward(consumable: self.bullets, quantity: 100)}) {
                    Image(systemName: "film")
                }
                .disabled(!adMob.rewardAvailable)
                Spacer()
            }
            .padding()
        }
    }
    
    private struct GameZone: View {
        @ObservedObject var sheets = activeSheet
        @ObservedObject private var points = GameFrame.coreData.getScore("Points")
        @ObservedObject private var medals = GameFrame.coreData.getAchievement("Medals")
        @ObservedObject private var bullets = GameFrame.coreData.getConsumable("Bullets")
        @ObservedObject private var lives = GameFrame.coreData.getConsumable("Lives")

        var body: some View {
            VStack {
                Group {
                    Spacer()
                    Button(action: {
                        self.bullets.consume(1)
                        checkDeath()
                    }) {
                        Text("Shot")
                    }
                    Spacer()
                    Button(action: {
                        self.points.earn(10)
                    }) {
                        Text("Hit")
                    }
                }
                Group {
                    Spacer()
                    Button(action: {
                        self.medals.achieved(self.medals.current + 1)
                    }) {
                        Text("Cool Move")
                    }
                    Spacer()
                    Button(action: {
                        self.lives.consume(1)
                        checkDeath()
                    }) {
                        Text("Killed")
                    }
                    Spacer()
                }
            }
        }
    }

    var body: some View {
        ZStack {
            GameZone()
            VStack {
                Information()
                Spacer()
                Navigation()
            }
        }
    }
}

struct InLevel_Previews: PreviewProvider {
    static var previews: some View {
        InLevel()
    }
}

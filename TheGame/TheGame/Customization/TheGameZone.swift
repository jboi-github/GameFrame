//
//  GameZone.swift
//  TheGame
//
//  Created by Juergen Boiselle on 09.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

struct GameZone: View {
    @ObservedObject private var points = GameFrame.coreData.getScore("Points")
    @ObservedObject private var medals = GameFrame.coreData.getAchievement("Medals")
    @ObservedObject private var bullets = GameFrame.coreData.getConsumable("Bullets")
    @ObservedObject private var lives = GameFrame.coreData.getConsumable("Lives")

    var body: some View {
        VStack {
            HStack{Spacer()}
            Group {
                Spacer()
                Button(action: {
                    self.bullets.consume(1)
                    if self.bullets.available <= 0 {
                        if !self.makeOffer(consumableId: "Bullets", quantity: 100) {
                            gameZoneController.leaveLevel()
                        }
                    }
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
                    if self.lives.available <= 0 {
                        if !self.makeOffer(consumableId: "Lives", quantity: 1) {
                            gameZoneController.leaveLevel()
                        }
                    }
                }) {
                    Text("Killed")
                }
                Spacer()
            }
        }
    }
    
    // Make an offer to player, if points are in range
    private func makeOffer(consumableId: String, quantity: Int) -> Bool {
        let range = 0.8*Double(points.highest)..<Double(points.highest)
        if range.contains(Double(points.current)) {
            gameZoneController.makeOffer(consumableId: consumableId, quantity: quantity)
            return true
        } else {
            return false
        }
    }
}

struct GameZone_Previews: PreviewProvider {
    static var previews: some View {
        GameZone()
    }
}

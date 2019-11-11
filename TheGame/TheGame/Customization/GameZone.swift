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

/// Created and initialized in `SceneDelegate`
class TheGameDelegate: GameZoneDelegate {
    func pause() {log()}
    
    func resume() {
        log()
        
        // Is dead? Then end the level
        let bullets = GameFrame.coreData.getConsumable("Bullets")
        let lives = GameFrame.coreData.getConsumable("Lives")
        if bullets.available <= 0 || lives.available <= 0 {gameZoneController.leaveLevel()}
    }
    
    func enterLevel() {
        log()
        let bullets = GameFrame.coreData.getConsumable("Bullets")
        let lives = GameFrame.coreData.getConsumable("Lives")

        if bullets.available < 100 {bullets.earn(100 - bullets.available)}
        if lives.available < 1 {lives.earn(1 - lives.available)}
    }
    
    func leaveLevel() -> (requestReview: Bool, showInterstitial: Bool) {
        log()
        let points = GameFrame.coreData.getScore("Points")
        
        let goodLevel = points.current == points.highest
        let timeForInterstitial = (Double.random(in: 0..<1) < 0.5) && !goodLevel // 50% and prio on review
        return (requestReview: goodLevel, showInterstitial: timeForInterstitial)
    }
}

struct GameZone_Previews: PreviewProvider {
    static var previews: some View {
        GameZone()
    }
}

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
        @ObservedObject private var adMob = GameFrame.adMob
        @ObservedObject private var inApp = GameFrame.inApp

        var body: some View {
            HStack {
                Spacer()
                NavigationLink(destination: OffLevel()) {
                    Image(systemName: "xmark")
                }
                Spacer()
                NavigationLink(destination: StoreView()) {
                    Image(systemName: "cart")
                }
                .disabled(!inApp.available)
                Spacer()
                Button(action: {
                    GameFrame.adMob.showReward(consumable: GameFrame.coreData.getConsumable("Bullets"), quantity: 100)
                }) {
                    Image(systemName: "film")
                }
                .disabled(!adMob.rewardAvailable)
                Spacer()
            }
            .padding()
        }
    }
    
    private struct GameZone: View {
        @ObservedObject private var points = GameFrame.coreData.getScore("Points")
        @ObservedObject private var medals = GameFrame.coreData.getAchievement("Medals")
        @ObservedObject private var bullets = GameFrame.coreData.getConsumable("Bullets")
        @ObservedObject private var lives = GameFrame.coreData.getConsumable("Lives")
        @State private var showOffer = false
        @State private var reward: (consumable: GFConsumable, quantity: Int)? = nil
        @State private var purchases = [GFInApp.ConsumableProduct]()
        @Environment(\.presentationMode) private var presentationMode

        var body: some View {
            VStack {
                HStack{Spacer()}
                Group {
                    Spacer()
                    Button(action: {
                        self.bullets.consume(1)
                        self.deathOrOffer(showOffer: self.$showOffer, reward: self.$reward, purchase: self.$purchases)
                        if !self.showOffer {self.presentationMode.wrappedValue.dismiss()}
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
                        self.deathOrOffer(showOffer: self.$showOffer, reward: self.$reward, purchase: self.$purchases)
                        log(self.showOffer)
                        if !self.showOffer {self.presentationMode.wrappedValue.dismiss()}
                    }) {
                        Text("Killed")
                    }
                    Spacer()
                }
            }
            .overlay(VStack {
                if showOffer {
                    AdHocOfferView(showOffer: $showOffer, reward: reward, purchases: purchases)
                } else {
                    EmptyView()
                }
            })
        }
        
        // Resort from result oriented Swift to inout-parameter driven SwiftUI
        private func deathOrOffer(showOffer: Binding<Bool>, reward: Binding<(consumable: GFConsumable, quantity: Int)?>, purchase: Binding<[GFInApp.ConsumableProduct]>) {
            log()
            guard gameLogic.isDead() else {
                showOffer.wrappedValue.unset()
                return
            }
            
            if let offer = gameLogic.makeOffer() {
                reward.wrappedValue = offer.reward
                purchase.wrappedValue = offer.purchase
                showOffer.wrappedValue = (offer.reward != nil) || (!offer.purchase.isEmpty)
            } else {
                showOffer.wrappedValue.unset()
            }
            
            if !showOffer.wrappedValue {gameLogic.afterLeavingLevel()}
            return
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
        .navigationBarHidden(true)
        .navigationBarTitle(Text("Title"))
        .navigationBarBackButtonHidden(true)
    }
}

struct InLevel_Previews: PreviewProvider {
    static var previews: some View {
        InLevel()
    }
}

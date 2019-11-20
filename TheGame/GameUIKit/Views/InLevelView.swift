//
//  InLevel.swift
//  TheGame
//
//  Created by Juergen Boiselle on 01.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit
import StoreKit

struct InLevelView<C, S>: View where C: GameConfig, S: GameSkin {
    @ObservedObject var gameUI = GameUI.instance
    
    private struct GameView: View {
        let isOverlayed: Bool
        @EnvironmentObject private var config: C
        @EnvironmentObject private var skin: S
        
        var body: some View {
            ZStack {
                EmptyView()
                    // TODO: Add GeometryReader and sizes for Navigation- and Information-Area
                    .modifier(skin.getInLevelGameZoneModifier())
                VStack {
                    InformationArea<S>(parent: "InLevel", items: config.inLevelInformation)
                        .modifier(skin.getInLevelInformationModifier())
                    
                    Spacer()
                    
                    NavigationArea<S>(parent: "InLevel", items: config.inLevelNavigation, isOverlayed: isOverlayed)
                        .modifier(skin.getInLevelNavigationModifier())
                }
            }
            .modifier(skin.getInLevelModifier(isOverlayed: isOverlayed))
            .onAppear {
                if !self.isOverlayed {GameUI.instance.resume()}
            }
            .onDisappear {
                if !self.isOverlayed {GameUI.instance.pause()}
            }
        }
    }

    private struct OfferOverlay: View {
        let consumableId: String
        let rewardQuantity: Int
        @ObservedObject private var inApp = GameFrame.inApp
        
        private struct ProductsView: View {
            let consumableId: String
            let rewardQuantity: Int
            let isOverlayed: Bool
            @EnvironmentObject private var skin: S
            
            var body: some View {
                let products = GameFrame.inApp.getConsumables(ids: [consumableId])
                
                return VStack {
                    ForEach(products) {
                        product in
                        
                        Button(action: {
                            GameFrame.inApp.buy(product: product.product, quantity: 1)
                        }) {
                            HStack {
                                VStack {
                                    Text("\(product.product.localizedTitle)")
                                        .modifier(self.skin.getOfferProductTitleModifier())
                                    Text("\(product.product.localizedDescription)")
                                        .modifier(self.skin.getOfferProductDescriptionModifier())
                                }
                                Spacer()
                                VStack {
                                    Image(systemName: "cart")
                                        .modifier(self.skin.getOfferProductCartModifier())
                                    Text("\(product.product.localizedPrice(quantity: 1))")
                                        .modifier(self.skin.getOfferProductPriceModifier())
                                }
                            }
                        }
                        .disabled(self.isOverlayed)
                        .buttonStyle(self.skin.getOfferProductModifier(
                            isDisabled: self.isOverlayed,
                            id: product.product.productIdentifier))
                    }
                    .modifier(skin.getOfferProductsModifier())
                    NavigationArea<S>(parent: "Offer",
                        items: [[
                            .OfferBackLink(),
                            .RewardLink(consumableId: consumableId, quantity: rewardQuantity)
                        ]],
                        isOverlayed: isOverlayed)
                    .modifier(skin.getOfferNavigationModifier())
                }
                .modifier(skin.getOfferModifier(isOverlayed: isOverlayed))
            }
        }
        
        var body: some View {
            // TODO: Workaround as of XCode 11.2. When reading one published var of an ObservablObject multiple times, the App crashes
            ZStack {
                if inApp.purchasing {
                    ProductsView(consumableId: consumableId, rewardQuantity: rewardQuantity, isOverlayed: true)
                    WaitAlert<S>()
                } else if inApp.error != nil {
                    ProductsView(consumableId: consumableId, rewardQuantity: rewardQuantity, isOverlayed: true)
                    ErrorAlert<S>()
                } else {
                    ProductsView(consumableId: consumableId, rewardQuantity: rewardQuantity, isOverlayed: false)
                }
            }
        }
    }

    var body: some View {
        // TODO: Workaround as of XCode 11.2. When reading one published var of an ObservablObject multiple times, the App crashes
        ZStack {
            if gameUI.offer != nil {
                GameView(isOverlayed: true)
                OfferOverlay(consumableId: GameUI.instance.offer!.consumableId, rewardQuantity: GameUI.instance.offer!.quantity)
            } else {
                GameView(isOverlayed: false)
            }
        }
    }
}

struct InLevel_Previews: PreviewProvider {
    static var previews: some View {
        InLevelView<PreViewConfig, PreviewSkin>()
        .environmentObject(PreViewConfig())
        .environmentObject(PreviewSkin())
    }
}

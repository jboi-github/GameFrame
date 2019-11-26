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
    @EnvironmentObject private var skin: S

    var body: some View {
        // TODO: Workaround as of XCode 11.2. When reading one published var of an ObservablObject multiple times, the App crashes
        ZStack {
            if gameUI.offer != nil {
                GameView<C, S>(isOverlayed: true)
                OfferOverlay<C, S>(
                    consumableId: GameUI.instance!.offer!.consumableId,
                    rewardQuantity: GameUI.instance!.offer!.quantity)
            } else {
                GameView<C, S>(isOverlayed: false)
            }
        }
        .modifier(skin.getInLevelModifier())
    }
}

private struct GameView<C, S>: View where C: GameConfig, S: GameSkin {
    let isOverlayed: Bool
    @EnvironmentObject private var config: C
    @EnvironmentObject private var skin: S
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ZStack {
            EmptyView()
                // TODO: Add GeometryReader and sizes for Navigation- and Information-Area
                .modifier(skin.getInLevelGameZoneModifier())
            VStack {
                NavigationArea<C, S>(
                    parent: "InLevel",
                    items: config.inLevelNavigation,
                    isOverlayed: isOverlayed)
                    .modifier(skin.getInLevelNavigationModifier())
                InformationArea<S>(parent: "InLevel", items: config.inLevelInformation)
                    .modifier(skin.getInLevelInformationModifier())
                Spacer()
            }
        }
        .modifier(skin.getInLevelGameModifier(isOverlayed: isOverlayed))
        .onAppear {
            log(self.presentationMode)
            if !self.isOverlayed {GameUI.instance.resume()}
        }
        .onDisappear {
            if !self.isOverlayed {GameUI.instance.pause()}
        }
    }
}

private struct OfferOverlay<C, S>: View where C: GameConfig, S: GameSkin {
    let consumableId: String
    let rewardQuantity: Int
    @ObservedObject private var inApp = GameFrame.inApp
    
    private struct ProductRow: View {
        let product: SKProduct
        let isOverlayed: Bool
        @EnvironmentObject private var skin: S
        
        var body: some View {
            Button(action: {
                GameFrame.inApp.buy(product: self.product, quantity: 1)
            }) {
                HStack {
                    VStack {
                        Text("\(product.localizedTitle)")
                            .modifier(skin.getOfferProductTitleModifier(id: product.productIdentifier))
                        Text("\(product.localizedDescription)")
                            .modifier(skin.getOfferProductDescriptionModifier(id: product.productIdentifier))
                    }
                    Spacer()
                    VStack {
                        Image(systemName: "cart")
                            .modifier(skin.getOfferProductCartModifier(id: product.productIdentifier))
                        Text("\(product.localizedPrice(quantity: 1))")
                            .modifier(skin.getOfferProductPriceModifier(id: product.productIdentifier))
                    }
                }
            }
            .disabled(isOverlayed)
            .buttonStyle(skin.getOfferProductModifier(
                id: product.productIdentifier,
                isDisabled: isOverlayed))
        }
    }
    
    private struct ProductsView: View {
        let consumableId: String
        let rewardQuantity: Int
        let isOverlayed: Bool
        @EnvironmentObject private var skin: S
        
        var body: some View {
            let products = GameFrame.inApp.getProducts(consumableIds: [consumableId], nonConsumableIds: [String]())
            
            return VStack {
                ForEach(0..<products.count, id: \.self) {
                    ProductRow(product: products[$0], isOverlayed: self.isOverlayed)
                }
                .modifier(skin.getOfferProductsModifier())
                NavigationArea<C, S>(parent: "Offer",
                    items: [[
                        .Buttons(button: .OfferBack()),
                        .Buttons(button: .Reward(consumableId: consumableId, quantity: rewardQuantity))
                    ]],
                    isOverlayed: isOverlayed)
                .modifier(skin.getOfferNavigationModifier())
            }
            .modifier(skin.getOfferModifier(isOverlayed: isOverlayed))
            .onAppear {
                guard !self.isOverlayed else {return}
                
                if !GameUI.instance.gameDelegate.keepOffer() {
                    GameUI.instance.clearOffer()
                }
            }
        }
    }
    
    var body: some View {
        // TODO: Workaround as of XCode 11.2. When reading one published var of an ObservablObject multiple times, the App crashes
        ZStack {
            if inApp.purchasing {
                ProductsView(
                    consumableId: consumableId,
                    rewardQuantity: rewardQuantity,
                    isOverlayed: true)
                WaitAlert<S>()
            } else if inApp.error != nil {
                ProductsView(
                    consumableId: consumableId,
                    rewardQuantity: rewardQuantity,
                    isOverlayed: true)
                ErrorAlert<C, S>()
            } else {
                ProductsView(
                    consumableId: consumableId,
                    rewardQuantity: rewardQuantity,
                    isOverlayed: false)
            }
        }
    }
}

struct InLevel_Previews: PreviewProvider {
    static var previews: some View {
        InLevelView<PreviewConfig, PreviewSkin>()
        .environmentObject(PreviewConfig())
        .environmentObject(PreviewSkin())
    }
}

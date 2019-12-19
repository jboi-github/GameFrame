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

private let gameFrameId = UUID().uuidString
private let informationFrameId = UUID().uuidString
private let navigationFrameId = UUID().uuidString

private struct GameView<C, S>: View where C: GameConfig, S: Skin {
    let isOverlayed: Bool
    @State private var gameFrame: CGRect = .zero
    @State private var informationFrame: CGRect = .zero
    @State private var navigationFrame: CGRect = .zero
    @State private var sharedImage: UIImage?
    @EnvironmentObject private var config: C
    @EnvironmentObject private var skin: S
    
    var body: some View {
        VStack {
            NavigationBar<C, S>(
                parent: "InLevel",
                title: config.inLevelNavigationBarTitle,
                item1: config.inLevelNavigationBarButton1,
                item2: config.inLevelNavigationBarButton2,
                bounds: gameFrame,
                isOverlayed: isOverlayed)
            ZStack {
                // Spread to available display
                VStack{Spacer(); HStack{Spacer()}}
                config.gameZone
                    .build(skin, .InLevel(.GameZone(
                        gameFrame,
                        informationFrame: informationFrame,
                        navigationFrame: navigationFrame)))
                InformationLayer<S>(
                    parent: "InLevel",
                    items: config.inLevelInformation(frame: gameFrame))
                    .storeFrame(informationFrameId)
                NavigationLayer<C, S>(
                    parent: "InLevel",
                    items: config.inLevelNavigation(frame: gameFrame),
                    bounds: gameFrame,
                    isOverlayed: isOverlayed)
                    .storeFrame(navigationFrameId)
            }
        }
        .build(skin, .InLevel(.Game(isOverlayed: isOverlayed)))
        .storeFrame(gameFrameId)
        .getFrame(gameFrameId, frame: $gameFrame)
        .getFrame(informationFrameId, frame: $informationFrame)
        .getFrame(navigationFrameId, frame: $navigationFrame)
        .onAppear {
            if !self.isOverlayed {GameUI.instance.resume()}
        }
        .onDisappear {
            if !self.isOverlayed {GameUI.instance.pause()}
        }
    }
}

private struct ProductRow<C, S>: View where C: GameConfig, S: Skin {
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
                        .build(skin, .OfferProductTitle(id: product.productIdentifier))
                    Text("\(product.localizedDescription)")
                        .build(skin, .OfferProductDescription(id: product.productIdentifier))
                }
                Spacer()
                VStack {
                    Image(systemName: "cart")
                        .build(skin, .OfferProductCart(id: product.productIdentifier))
                    Text("\(product.localizedPrice(quantity: 1))")
                        .build(skin, .OfferProductPrice(id: product.productIdentifier))
                }
            }
        }
        .disabled(isOverlayed)
        .buttonStyle(SkinButtonStyle(
            skin: skin,
            frameId: "InLevel-Offer-\(product.productIdentifier)",
            item: .OfferProduct(
                id: product.productIdentifier,
                isDisabled: isOverlayed)))
        .storeFrame("InLevel-Offer-\(product.productIdentifier)")
    }
}

private struct ProductsView<C, S>: View where C: GameConfig, S: Skin {
    let consumableId: String
    let rewardQuantity: Int
    let isOverlayed: Bool
    @EnvironmentObject private var skin: S
    
    var body: some View {
        let products = GameFrame.inApp.getProducts([.Consumable(id: consumableId, quantity: 1)])
        
        return VStack {
            ForEach(0..<products.count, id: \.self) {
                ProductRow<C, S>(product: products[$0], isOverlayed: self.isOverlayed)
            }
            NavigationLayer<C, S>(parent: "Offer",
                items: [[
                    .Buttons(.OfferBack()),
                    .Buttons(.Reward(consumableId: consumableId, quantity: rewardQuantity))
                ]],
                isOverlayed: isOverlayed)
        }
        .build(skin, .Offer(.Products(isOverlayed: isOverlayed)))
        .onAppear {
            guard !self.isOverlayed else {return}
            
            if GameUI.instance.gameDelegate.keepOffer() {
                GameUI.instance.pause()
            } else {
                GameUI.instance.clearOffer()
            }
        }
        .onDisappear {
            guard !self.isOverlayed else {return}
            
            if GameUI.instance.offer == nil {
                GameUI.instance.resume()
            }
        }
    }
}

private struct OfferOverlay<C, S>: View where C: GameConfig, S: Skin {
    let consumableId: String
    let rewardQuantity: Int
    @State private var purchasing = GameFrame.inApp.purchasing
    @State private var error = GameFrame.inApp.error
    @State private var isOverlayed: Bool = false
    @EnvironmentObject private var skin: S
    
    var body: some View {
        ZStack {
            ProductsView<C, S>(
                consumableId: consumableId,
                rewardQuantity: rewardQuantity,
                isOverlayed: isOverlayed)
            if purchasing {
                WaitAlert<S>()
            } else if error != nil {
                ErrorAlert<C, S>()
            }
        }
        .build(skin, .Offer(.Main))
        .onReceive(GameFrame.inApp.$purchasing) { purchasing in
            withAnimation {
                self.purchasing = purchasing;
                self.isOverlayed = purchasing || self.error != nil
            }
        }
        .onReceive(GameFrame.inApp.$error) { error in
            withAnimation {
                self.error = error;
                self.isOverlayed = self.purchasing || error != nil
            }
        }
    }
}

struct InLevelView<C, S>: View where C: GameConfig, S: Skin {
    @State private var makeOffer: Bool = false
    @EnvironmentObject private var skin: S

    var body: some View {
        ZStack {
            GameView<C, S>(isOverlayed: makeOffer)
            if makeOffer {
                OfferOverlay<C, S>(
                    consumableId: GameUI.instance!.offer!.consumableId,
                    rewardQuantity: GameUI.instance!.offer!.quantity)
            }
        }
        .build(skin, .InLevel(.Main))
        .onReceive(GameUI.instance.$offer) {_ in
            withAnimation {
                self.makeOffer = GameUI.instance.offer != nil
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

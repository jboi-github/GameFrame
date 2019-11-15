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

struct InLevelView<S>: View where S: Skin {
    var skin: S
    var geometryProxy: GeometryProxy
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var inApp = GameFrame.inApp
    @ObservedObject private var adMob = GameFrame.adMob
    @ObservedObject private var controller = gameControllerImpl

    private struct OfferOverlay<S>: View where S: Skin {
        var skin: S
        var geometryProxy: GeometryProxy
        var consumableId: String
        var rewardQuantity: Int
        var completionHandler: () -> Void
        @Environment(\.presentationMode) var presentationMode
        @ObservedObject private var controller = gameControllerImpl
        @State private var showingReward: Bool = false
        
        var body: some View {
            let purchases = GameFrame.inApp.getConsumables(ids: [consumableId])
            
            return VStack {
                ForEach(purchases) {
                    purchase in
                    
                    Button(action: {
                        GameFrame.inApp.buy(product: purchase.product, quantity: 1)
                        // This triggers waiting/error handling which in turn trigger completionHandler
                    }) {
                        HStack {
                            VStack {
                                Text("\(purchase.product.localizedTitle)")
                                    .modifier(self.skin.getOfferProductTitleModifier(geometryProxy: self.geometryProxy))
                                Text("\(purchase.product.localizedDescription)")
                                    .modifier(self.skin.getOfferProductDescriptionModifier(geometryProxy: self.geometryProxy))
                            }
                            Spacer()
                            VStack {
                                Image(systemName: "cart")
                                    .modifier(self.skin.getOfferProductCartModifier(geometryProxy: self.geometryProxy))
                                Text("\(purchase.product.localizedPrice(quantity: 1))")
                                    .modifier(self.skin.getOfferProductPriceModifier(geometryProxy: self.geometryProxy))
                            }
                        }
                    }
                    .buttonStyle(self.skin.getOfferProductModifier(
                        geometryProxy: self.geometryProxy,
                        isDisabled: false,
                        id: purchase.product.productIdentifier))
                }
                .modifier(skin.getOfferProductsModifier(geometryProxy: self.geometryProxy))
                NavigationArea<S>(skin:skin, geometryProxy: geometryProxy, parent: "Offer",
                    navigatables: [
                        .Action(action: {
                            self.showingReward = true
                            GameFrame.adMob.showReward(
                                consumable: GameFrame.coreData.getConsumable(self.consumableId),
                                quantity: self.rewardQuantity,
                                completionHandler: {
                                    self.completionHandler()
                                    self.showingReward = false
                            })
                        },
                         image: Image(systemName: "film"),
                         disabled: !GameFrame.adMob.rewardAvailable),
                        .Action(action: self.completionHandler,
                         image: Image(systemName: "xmark"),
                         disabled: nil)])
                .modifier(skin.getOfferNavigationModifier(geometryProxy: self.geometryProxy))
            }
            .modifier(skin.getOfferModifier(geometryProxy: self.geometryProxy))
            .overlay(WaitWithErrorOverlay(
                skin: skin, geometryProxy: geometryProxy,
                completionHandler: self.completionHandler))
            .onAppear(perform: {
                if !self.showingReward {self.controller.pause()}
            })
            .onDisappear(perform: {
                if !self.showingReward {
                    if !self.controller.resume() {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            })
        }
    }

    var body: some View {
        ZStack {
            EmptyView()
                // TODO: Add GeometryReader and sizes for Navigation- and Information-Area
                .modifier(self.skin.getInLevelGameZoneModifier(geometryProxy: self.geometryProxy))
            VStack {
                // TODO: Bring to some Game Configuration
                InformationArea<S>(
                    skin: self.skin, geometryProxy: self.geometryProxy,
                    parent: "InLevel",
                    scoreIds: ["Points"],
                    achievements: [(id:"Medals", format: "%.1f")],
                    consumableIds: ["Bullets"],
                    nonConsumables: [])
                    .modifier(self.skin.getInLevelInformationModifier(geometryProxy: self.geometryProxy))
                
                Spacer()
                
                // TODO: Bring to some Game Configuration
                NavigationArea<S>(skin: self.skin, geometryProxy: self.geometryProxy, parent: "InLevel",
                    navigatables: [
                        .ToStore(image: Image(systemName: "cart"),
                                 consumableIds: ["Bullets"],
                                 nonConsumableIds: ["weaponB", "weaponC"],
                                 disabled: !self.inApp.available),
                        .Action(action: {
                            GameFrame.adMob.showReward(
                                consumable: GameFrame.coreData.getConsumable("Bullets"),
                                quantity: 100,
                                completionHandler: {})
                        },
                         image: Image(systemName: "film"),
                         disabled: !self.adMob.rewardAvailable),
                        .Action(action: {self.presentationMode.wrappedValue.dismiss()},
                         image: Image(systemName: "xmark"),
                         disabled: nil)])
                    .modifier(self.skin.getInLevelNavigationModifier(geometryProxy: self.geometryProxy))
            }
        }
        .modifier(skin.getInLevelModifier(
            geometryProxy: self.geometryProxy,
            isOverlayed: inApp.purchasing || inApp.error != nil))
        .overlay(VStack {
            if controller.offer != nil {
                OfferOverlay(
                    skin: skin, geometryProxy: geometryProxy,
                    consumableId: controller.offer!.consumableId,
                    rewardQuantity: controller.offer!.quantity,
                    completionHandler: {self.controller.clearOffer()})
            }
        })
        .onAppear(perform: {
            if !self.controller.resume() {self.presentationMode.wrappedValue.dismiss()}
        })
        .onDisappear(perform: {
            self.controller.pause()
        })
    }
}

struct InLevel_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {
            InLevelView(skin: TheGameSkin(), geometryProxy: $0)
        }
    }
}

/// Make parts of the controller available to rest of The Game
private let gameControllerImpl = GameControllerImpl()
let gameController: GameController = gameControllerImpl

private class GameControllerImpl: NSObject, GameController, ObservableObject {
    fileprivate override init(){}
    
    private var delegate: GameDelegate? = nil
    func setDelegate(delegate: GameDelegate) {self.delegate = delegate}
    
    @Published fileprivate private(set) var offer: (consumableId: String, quantity: Int)? = nil
    @Published fileprivate private(set) var isInLevel: Bool = false
    @Published fileprivate private(set) var isResumed: Bool = false
    
    /// reading a published variable triggers changes!
    var isInLevelShadow: Bool = false {
        didSet(prev) {
            guard prev != isInLevelShadow else {return}
            isInLevel = isInLevelShadow
        }
    }
    var isResumedShadow: Bool = false {
        didSet(prev) {
            guard prev != isResumedShadow else {return}
            isResumed = isResumedShadow
        }
    }

    /**
     Called by your game to let `InLevel`show an offer to the player. This will first pause the game by calling `pause()` in the `TheGameDelegate`, then show the offering. When offering dissappears, `resume()` is called and the consumables might reflect the new values - if the player decided to take the offer. If player decided to not
     take the offer, the consumables and therefore conditions to show the offer, might still be in place.
     */
    func makeOffer(consumableId: String, quantity: Int) {
        log(delegate != nil, consumableId, quantity)
        offer = (consumableId: consumableId, quantity: quantity)
    }
            
    /**
     Called internally to clear offer and let it dissappear.
     */
    fileprivate func clearOffer() {
        log(offer)
        offer = nil
    }
    
    fileprivate func pause() {
        log(isResumedShadow, isInLevelShadow)
        if isResumedShadow {
            isResumedShadow = false
            delegate?.pause()
            
            isInLevelShadow = (delegate?.stayInLevel() ?? isInLevelShadow) || offer != nil
            if !isInLevelShadow {
                if let leave = delegate?.leaveLevel() {
                    GameFrame.instance.leaveLevel(requestReview: leave.requestReview, showInterstitial: leave.showInterstitial)
                } else {
                    GameFrame.instance.leaveLevel(requestReview: false, showInterstitial: false)
                }
            }
        }
    }
    
    fileprivate func resume() -> Bool {
        log(isResumedShadow, isInLevelShadow)
        if !isResumedShadow {
            if !isInLevelShadow {
                isInLevelShadow = true
                GameFrame.instance.enterLevel()
                delegate?.enterLevel()
            }
            isResumedShadow = true
            delegate?.resume()
            
        }
        // Came back from offer, but did not take it
        isInLevelShadow = delegate?.stayInLevel() ?? isInLevelShadow
        return isInLevelShadow
    }
}

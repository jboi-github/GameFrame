//
//  AdHocOfferView.swift
//  TheGame
//
//  Created by Juergen Boiselle on 31.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit
import StoreKit

struct OfferOverlay<S>: View where S: Skin {
    var skin: S
    var geometryProxy: GeometryProxy
    var consumableId: String
    var rewardQuantity: Int
    var completionHandler: () -> Void
    
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
                .buttonStyle(self.skin.getOfferProductModifier(geometryProxy: self.geometryProxy, isDisabled: false))
            }
            .modifier(skin.getOfferProductsModifier(geometryProxy: self.geometryProxy))
            NavigationArea<S>(skin:skin, geometryProxy: geometryProxy, parent: "Offer",
                navigatables: [
                (action: {
                    GameFrame.adMob.showReward(
                        consumable: GameFrame.coreData.getConsumable(self.consumableId),
                        quantity: self.rewardQuantity,
                        completionHandler: self.completionHandler)
                },
                 image: Image(systemName: "film"),
                 disabled: !GameFrame.adMob.rewardAvailable),
                (action: self.completionHandler,
                 image: Image(systemName: "xmark"),
                 disabled: nil)])
            .modifier(skin.getOfferNavigationModifier(geometryProxy: self.geometryProxy))
        }
        .modifier(skin.getOfferModifier(geometryProxy: self.geometryProxy))
    }
}

struct OfferOverlay_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {
            OfferOverlay(skin: SkinImpl(), geometryProxy: $0, consumableId: "Lives", rewardQuantity: 1, completionHandler: {log()})
        }
    }
}

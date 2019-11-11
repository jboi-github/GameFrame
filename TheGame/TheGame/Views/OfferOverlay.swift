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

struct OfferOverlay: View {
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
                            Text("\(purchase.product.localizedDescription)")
                        }
                        Spacer()
                        VStack {
                            Image(systemName: "cart")
                            Text("\(purchase.product.localizedPrice(quantity: 1))")
                        }
                    }
                }
            }
            NavigationArea(navigatables: [
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
        }
    }
}

struct OfferOverlay_Previews: PreviewProvider {
    static var previews: some View {
        OfferOverlay(consumableId: "Lives", rewardQuantity: 1, completionHandler: {log()})
    }
}

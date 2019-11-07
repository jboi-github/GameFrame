//
//  AdHocOfferView.swift
//  TheGame
//
//  Created by Juergen Boiselle on 31.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

struct AdHocOfferView: View {
    @Binding var showOffer: Bool
    var reward: (consumable: GFConsumable, quantity: Int)?
    var purchases: [GFInApp.ConsumableProduct]

    var body: some View {
        VStack {
            Spacer()
            ForEach(purchases) {
                purchase in
                
                Button(action: {
                    GameFrame.inApp.buy(product: purchase.product, quantity: 1)
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
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    GameFrame.adMob.showReward(consumable: self.reward!.consumable, quantity: self.reward!.quantity)
                    self.showOffer.unset()
                }) {
                    Image(systemName: "film")
                }
                .disabled(reward == nil)
                Spacer()

                // When "no, thanks" -> Go back
                Button(action: {
                    self.showOffer.unset()
                }) {
                    Image(systemName: "xmark")
                }
                Spacer()
            }
        }
        .modifier(StoreViewModifier())
    }
}

struct AdHocOfferView_Previews: PreviewProvider {
    static var previews: some View {
        AdHocOfferView(showOffer: .constant(true), reward: nil, purchases: [GFInApp.ConsumableProduct]())
    }
}

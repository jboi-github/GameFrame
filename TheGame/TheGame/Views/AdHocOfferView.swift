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
    var body: some View {
        let offer = makeOffer() //

        return VStack {
            Spacer()
            if offer.purchase != nil && offer.purchase?.count ?? 0 > 0 {
                ForEach(offer.purchase!) {
                    p in
                    
                    Button(action: {
                        GameFrame.inApp.buy(product: p.product, quantity: 1)
                        activeSheet.next(.InLevel)
                    }) {
                        HStack {
                            VStack {
                                Text("\(p.product.localizedTitle)")
                                Text("\(p.product.localizedDescription)")
                            }
                            Spacer()
                            VStack {
                                Image(systemName: "cart")
                                Text("\(p.product.localizedPrice(quantity: 1))")
                            }
                        }
                    }
                }
            }
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    GameFrame.adMob.showReward(consumable: offer.reward!.consumable, quantity: offer.reward!.quantity)
                    activeSheet.next(.InLevel)
                }) {
                    Image(systemName: "film")
                }
                .disabled(offer.reward == nil)
                Spacer()

                // When "no, thanks" -> Goto .OffLevel
                Button(action: {
                    activeSheet.next(.OffLevel)
                }) {
                    Image(systemName: "xmark")
                }
                Spacer()
            }
        }
    }
}

struct AdHocOfferView_Previews: PreviewProvider {
    static var previews: some View {
        AdHocOfferView()
    }
}

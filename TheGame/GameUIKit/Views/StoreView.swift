//
//  StoreView.swift
//  TheGame
//
//  Created by Juergen Boiselle on 31.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit
import StoreKit

struct StoreView<S>: View where S: GameSkin {
    let consumableIds: [String]
    let nonConsumableIds: [String]
    @ObservedObject private var inApp = GameFrame.inApp
    
    private struct ConsumableProductRow: View {
        let consumableProduct: GFInApp.ConsumableProduct
        let isOverlayed: Bool
        @State private var quantity = 1
        @EnvironmentObject private var skin: S
        
        var body: some View {
            let proxy = GameUI.instance.geometryProxy!
            
            return HStack {
                VStack {
                    Text("\(self.consumableProduct.product.localizedTitle)")
                        .modifier(skin.getStoreConsumableTitleModifier())
                    Text("\(consumableProduct.product.localizedDescription)")
                        .modifier(skin.getStoreConsumableDescriptionModifier())
                }
                Spacer()
                if proxy.size.width > proxy.size.height {
                    Stepper(value: $quantity, in: 1...99) {
                        HStack {
                            Spacer()
                            Spacer()
                            Text("\(quantity)")
                                .modifier(skin.getStoreConsumableQuantityModifier())
                        }
                    }
                    .disabled(isOverlayed)
                    .buttonStyle(skin.getStoreConsumableStepperModifier(isDisabled: false))
                }
                Button(action: {
                    GameFrame.inApp.buy(product: self.consumableProduct.product, quantity: self.quantity)
                }) {
                    VStack {
                        Image(systemName: "cart")
                            .modifier(skin.getStoreConsumableCartModifier())
                        Text("\(consumableProduct.product.localizedPrice(quantity: quantity))")
                            .modifier(skin.getStoreConsumablePriceModifier())
                    }
                }
                .disabled(isOverlayed)
                .buttonStyle(skin.getStoreConsumableButtonModifier(
                    isDisabled: false,
                    id: consumableProduct.product.productIdentifier))
            }
            .modifier(skin.getStoreConsumableModifier(id: consumableProduct.product.productIdentifier))
        }
    }
    
    private struct NonConsumableProductRow: View {
        let nonConsumable: GFNonConsumable
        let isOverlayed: Bool
        @EnvironmentObject private var skin: S
        
        var body: some View {
            HStack {
                VStack {
                    Text("\(nonConsumable.product!.localizedTitle)")
                        .modifier(skin.getStoreNonConsumableTitleModifier())
                    Text("\(nonConsumable.product!.localizedDescription)")
                        .modifier(skin.getStoreNonConsumableDescriptionModifier())
                }
                Spacer()
                Button(action: {
                    GameFrame.inApp.buy(product: self.nonConsumable.product!, quantity: 1)
                }) {
                    Text("\(nonConsumable.product!.localizedPrice(quantity: 1))")
                        .modifier(skin.getStoreNonConsumablePriceModifier())
                    Image(systemName: "cart")
                        .modifier(skin.getStoreNonConsumableCartModifier())
                }
                .disabled(nonConsumable.isOpened || isOverlayed)
                .buttonStyle(skin.getStoreNonConsumableButtonModifier(
                    isDisabled: nonConsumable.isOpened,
                    id: nonConsumable.product!.productIdentifier))
            }
            .modifier(skin.getStoreNonConsumableModifier(id: nonConsumable.product!.productIdentifier))
        }
    }
    
    private struct ProductsView: View {
        let consumableIds: [String]
        let nonConsumableIds: [String]
        let isOverlayed: Bool
        @EnvironmentObject private var skin: S

        var body: some View {
            let consumables = GameFrame.inApp.getConsumables(ids: consumableIds)
            let nonConsumables = GameFrame.inApp.getNonConsumables(ids: nonConsumableIds)

            return VStack {
                Spacer()
                
                if consumables.isEmpty && nonConsumables.isEmpty {
                    Text("No products available or store not available")
                        .modifier(skin.getStoreEmptyModifier())
                } else {
                    ScrollView {
                        Section() {
                            ForEach(0..<consumables.count, id: \.self) {
                                ConsumableProductRow(consumableProduct: consumables[$0], isOverlayed: self.isOverlayed)
                            }
                        }
                        .modifier(skin.getStoreConsumablesModifier())
                        Section() {
                            ForEach(0..<nonConsumables.count, id: \.self) {
                                NonConsumableProductRow(nonConsumable: nonConsumables[$0], isOverlayed: self.isOverlayed)
                            }
                        }
                        .modifier(skin.getStoreNonConsumablesModifier())
                    }
                }
                
                Spacer()

                NavigationArea<S>(parent: "Store", items: [[.RestoreLink(), .BackLink()]], isOverlayed: isOverlayed)
                    .modifier(skin.getStoreNavigationModifier())
            }
            .modifier(skin.getStoreModifier(isOverlayed: isOverlayed))
        }
    }

    var body: some View {
        // TODO: Workaround as of XCode 11.2. When reading one published var of an ObservablObject multiple times, the App crashes
        ZStack {
            if inApp.purchasing {
                ProductsView(
                    consumableIds: consumableIds,
                    nonConsumableIds: nonConsumableIds,
                    isOverlayed: true)
                WaitAlert<S>()
            } else if inApp.error != nil {
                ProductsView(
                    consumableIds: consumableIds,
                    nonConsumableIds: nonConsumableIds,
                    isOverlayed: true)
                ErrorAlert<S>()
            } else {
                ProductsView(
                    consumableIds: consumableIds,
                    nonConsumableIds: nonConsumableIds,
                    isOverlayed: false)
            }
        }
    }
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView<PreviewSkin>(consumableIds: ["Bullets"], nonConsumableIds: ["weaponB", "weaponC"])
        .environmentObject(PreviewSkin())
    }
}

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

struct StoreView<C, S>: View where C: GameConfig, S: GameSkin {
    let consumableIds: [String]
    let nonConsumableIds: [String]
    @ObservedObject private var inApp = GameFrame.inApp

    private struct ProductRow: View {
        let product: SKProduct
        let isOverlayed: Bool
        let proxy: GeometryProxy
        @State private var quantity = 1
        @EnvironmentObject private var skin: S
        
        var body: some View {
            HStack {
                VStack {
                    Text("\(product.localizedTitle)")
                        .modifier(skin.getStoreProductTitleModifier(id: product.productIdentifier))
                    Text("\(product.localizedDescription)")
                        .modifier(skin.getStoreProductDescriptionModifier(id: product.productIdentifier))
                }
                Spacer()
                if proxy.size.width > proxy.size.height && product.isPurelyConsumable {
                    Stepper(value: $quantity, in: 1...99) {
                        HStack {
                            Spacer()
                            Spacer()
                            Text("\(quantity)")
                                .modifier(skin.getStoreProductQuantityModifier(id: product.productIdentifier))
                        }
                    }
                    .disabled(isOverlayed)
                    .buttonStyle(skin.getStoreProductStepperModifier(id: product.productIdentifier, isDisabled: false))
                }
                Button(action: {
                    GameFrame.inApp.buy(product: self.product, quantity: self.quantity)
                }) {
                    VStack {
                        Image(systemName: "cart")
                            .modifier(skin.getStoreProductCartModifier(id: product.productIdentifier))
                        Text("\(product.localizedPrice(quantity: 1))")
                            .modifier(skin.getStoreProductPriceModifier(id: product.productIdentifier))
                    }
                }
                .disabled(isOverlayed)
                .buttonStyle(skin.getStoreProductButtonModifier(
                    id: product.productIdentifier,
                    isDisabled: isOverlayed))
            }
            .modifier(skin.getStoreProductModifier(id: product.productIdentifier))
        }
    }
    
    private struct ProductsView: View {
        let consumableIds: [String]
        let nonConsumableIds: [String]
        let isOverlayed: Bool
        @EnvironmentObject private var skin: S

        var body: some View {
            let products = GameFrame.inApp.getProducts(consumableIds: consumableIds, nonConsumableIds: nonConsumableIds)
            
            return VStack {
                Spacer()
                
                if products.isEmpty {
                    Text("No products available or store not available")
                        .modifier(skin.getStoreEmptyModifier())
                } else {
                    GeometryReader {
                        proxy in
                        
                        ScrollView {
                            ForEach(0..<products.count, id: \.self) {
                                id in
                                
                                ProductRow(product: products[id], isOverlayed: self.isOverlayed, proxy: proxy)
                            }
                        }
                        .modifier(self.skin.getStoreProductsModifier())
                    }
                }
                
                Spacer()

                NavigationArea<C, S>(parent: "Store", items: [[.RestoreLink(), .BackLink()]], isOverlayed: isOverlayed)
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
                ErrorAlert<C, S>()
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
        StoreView<PreviewConfig, PreviewSkin>(consumableIds: ["Bullets"], nonConsumableIds: ["weaponB", "weaponC"])
        .environmentObject(PreviewSkin())
    }
}

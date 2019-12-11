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

struct StoreView<C, S>: View where C: GameConfig, S: Skin {
    @ObservedObject private var inApp = GameFrame.inApp
    @EnvironmentObject private var config: C
    @EnvironmentObject private var skin: S

    private struct ProductsView: View {
        let isOverlayed: Bool
        @EnvironmentObject private var skin: S
        @EnvironmentObject private var config: C

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
                            .build(skin, .StoreProductTitle(id: product.productIdentifier))
                        Text("\(product.localizedDescription)")
                            .build(skin, .StoreProductDescription(id: product.productIdentifier))
                    }
                    Spacer()
                    if proxy.size.width > proxy.size.height && product.isPurelyConsumable {
                        Stepper(value: $quantity, in: 1...99) {
                            HStack {
                                Spacer()
                                Spacer()
                                Text("\(quantity)")
                                    .build(skin, .StoreProductQuantity(id: product.productIdentifier))
                            }
                        }
                        .disabled(isOverlayed)
                        .buttonStyle(SkinButtonStyle(skin: skin, item: .StoreProductStepper(id: product.productIdentifier, isDisabled: false)))
                    }
                    Button(action: {
                        GameFrame.inApp.buy(product: self.product, quantity: self.quantity)
                    }) {
                        VStack {
                            Image(systemName: "cart")
                                .build(skin, .StoreProductCart(id: product.productIdentifier))
                            Text("\(product.localizedPrice(quantity: 1))")
                                .build(skin, .StoreProductPrice(id: product.productIdentifier))
                        }
                    }
                    .disabled(isOverlayed)
                    .buttonStyle(SkinButtonStyle(skin: skin, item: .StoreProductButton(
                        id: product.productIdentifier,
                        isDisabled: isOverlayed)))
                }
                .build(skin, .Store(.Product(id: product.productIdentifier)))
            }
        }

        var body: some View {
            let products = GameFrame.inApp.getProducts(config.storePurchasables)
            var items: [Navigation] = [.Buttons(.Restore()), .Links(.Back())]
            if let id = config.storeRewardConsumableId {
                items.insert(.Buttons(.Reward(consumableId: id, quantity: config.storeRewardQuantity)), at: 1)
            }
            
            return VStack {
                NavigationBar<S>(
                    parent: "Store",
                    title: config.storeNavigationBarTitle,
                    item1: items.count > 2 ? items[1] : nil,
                    item2: .Buttons(.Restore()),
                    isOverlayed: isOverlayed)
                ZStack {
                    VStack {
                        Spacer()
                        if products.isEmpty {
                            Text("No products available or store not available")
                                .build(skin, .StoreEmpty)
                        } else {
                            GeometryReader {
                                proxy in
                                
                                ScrollView {
                                    ForEach(0..<products.count, id: \.self) {
                                        ProductRow(product: products[$0], isOverlayed: self.isOverlayed, proxy: proxy)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    NavigationLayer<C, S>(
                        parent: "Store",
                        items: [items],
                        isOverlayed: isOverlayed)
                }
            }
            .build(skin, .Store(.Products(isOverlayed: isOverlayed)))
        }
    }

    var body: some View {
        // TODO: Workaround as of XCode 11.2. When reading one published var of an ObservablObject multiple times, the App crashes
        ZStack {
            if inApp.purchasing {
                ProductsView(isOverlayed: true)
                WaitAlert<S>()
            } else if inApp.error != nil {
                ProductsView(isOverlayed: true)
                ErrorAlert<C, S>()
            } else {
                ProductsView(isOverlayed: false)
            }
        }
        .build(skin, .Store(.Main))
    }
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView<PreviewConfig, PreviewSkin>()
        .environmentObject(PreviewSkin())
    }
}

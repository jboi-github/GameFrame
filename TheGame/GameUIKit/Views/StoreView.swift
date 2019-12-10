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
    let consumableIds: [String]
    let nonConsumableIds: [String]
    @ObservedObject private var inApp = GameFrame.inApp
    @EnvironmentObject private var skin: S

    private struct ProductsView: View {
        let consumableIds: [String]
        let nonConsumableIds: [String]
        let isOverlayed: Bool
        @EnvironmentObject private var skin: S

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
            let products = GameFrame.inApp.getProducts(consumableIds: consumableIds, nonConsumableIds: nonConsumableIds)
            
            return ZStack {
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
                    items: [[.Buttons(.Restore()), .Links(.Back())]],
                    navbarItem: .Buttons(.Restore()),
                    isOverlayed: isOverlayed)
                    .build(skin, .Store(.Navigation))
            }
            .build(skin, .Store(.Products(isOverlayed: isOverlayed)))
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
        .build(skin, .Store(.Main))
    }
}

struct StoreView_Previews: PreviewProvider {
    @Environment(\.presentationMode) static var presentationMode
    
    static var previews: some View {
        StoreView<PreviewConfig, PreviewSkin>(
            consumableIds: ["Bullets"],
            nonConsumableIds: ["weaponB", "weaponC"])
        .environmentObject(PreviewSkin())
    }
}

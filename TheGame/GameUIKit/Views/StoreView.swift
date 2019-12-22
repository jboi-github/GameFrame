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

private struct ProductRow<S>: View where S: Skin {
    let product: SKProduct
    let isOverlayed: Bool
    let frame: CGRect
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
            if frame.width > frame.height && product.isPurelyConsumable {
                Stepper(value: $quantity, in: 1...99) {
                    HStack {
                        Spacer()
                        Spacer()
                        Text("\(quantity)")
                            .build(skin, .StoreProductQuantity(id: product.productIdentifier))
                    }
                }
                .disabled(isOverlayed)
                .buttonStyle(SkinButtonStyle(
                    skin: skin, frameId: "Store-Stepper-\(product.productIdentifier)",
                    item: .StoreProductStepper(id: product.productIdentifier, isDisabled: false)))
                .storeFrame("Store-Stepper-\(product.productIdentifier)")
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
            .buttonStyle(SkinButtonStyle(
                skin: skin,
                frameId: "Store-Button-\(product.productIdentifier)",
                item: .StoreProductButton(
                    id: product.productIdentifier,
                    isDisabled: isOverlayed)))
            .storeFrame("Store-Button-\(product.productIdentifier)")
        }
        .build(skin, .Store(.Product(id: product.productIdentifier)))
    }
}

private struct ProductsView<C, S>: View where C: GameConfig, S: Skin {
    let isOverlayed: Bool
    @State private var productsFrame: CGRect = .zero
    @EnvironmentObject private var skin: S
    @EnvironmentObject private var config: C

    var body: some View {
        let products = GameFrame.inApp.getProducts(config.storePurchasables)
        var items: [Navigation] = [.Buttons(.Restore()), .Links(.Back())]
        if let id = config.storeRewardConsumableId {
            items.insert(.Buttons(.Reward(consumableId: id, quantity: config.storeRewardQuantity)), at: 1)
        }
        
        return VStack {
            NavigationBar<C, S>(
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
                        ScrollView {
                            ForEach(0..<products.count, id: \.self) {
                                ProductRow<S>(product: products[$0], isOverlayed: self.isOverlayed, frame: self.productsFrame)
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

struct StoreView<C, S>: View where C: GameConfig, S: Skin {
    @State private var purchasing = GameFrame.inApp.purchasing
    @State private var error = GameFrame.inApp.error
    @State private var isOverlayed: Bool = false
    @EnvironmentObject private var config: C
    @EnvironmentObject private var skin: S

    var body: some View {
        ZStack {
            ProductsView<C, S>(isOverlayed: isOverlayed)
            if purchasing {
                WaitAlert<S>()
            } else if error != nil {
                ErrorAlert<C, S>()
            }
        }
        .build(skin, .Store(.Main))
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

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView<PreviewConfig, PreviewSkin>()
        .environmentObject(PreviewSkin())
    }
}

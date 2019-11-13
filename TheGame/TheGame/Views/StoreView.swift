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

struct StoreView<S>: View where S: Skin {
    var skin: S
    var geometryProxy: GeometryProxy
    var consumableIds: [String]
    var nonConsumableIds: [String]
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var inApp = GameFrame.inApp
    
    private struct ConsumableProductRow<S>: View where S: Skin {
        var skin: S
        var geometryProxy: GeometryProxy
        var consumableProduct: GFInApp.ConsumableProduct
        @State private var quantity = 1
        
        var body: some View {
            GeometryReader {
                geometry in
                
                Button(action: {
                    GameFrame.inApp.buy(product: self.consumableProduct.product, quantity: self.quantity)
                }) {
                    HStack {
                        VStack {
                            Text("\(self.consumableProduct.product.localizedTitle)")
                                .modifier(self.skin.getStoreConsumableTitleModifier(geometryProxy: self.geometryProxy))
                            Text("\(self.consumableProduct.product.localizedDescription)")
                                .modifier(self.skin.getStoreConsumableDescriptionModifier(geometryProxy: self.geometryProxy))
                        }
                        Spacer()
                        Stepper(value: self.$quantity, in: 1...99) {
                            Text("\(self.quantity)")
                                .modifier(self.skin.getStoreConsumableQuantityModifier(geometryProxy: self.geometryProxy))
                        }
                        .frame(width: geometry.size.width * 1.0/3.0) // TODO: Put into Modifier
                            .buttonStyle(self.skin.getStoreConsumableStepperModifier(geometryProxy: self.geometryProxy, isDisabled: false))
                        VStack {
                            Image(systemName: "cart")
                                .modifier(self.skin.getStoreConsumableCartModifier(geometryProxy: self.geometryProxy))
                            Text("\(self.consumableProduct.product.localizedPrice(quantity: self.quantity))")
                                .modifier(self.skin.getStoreConsumablePriceModifier(geometryProxy: self.geometryProxy))
                        }
                        .frame(width: geometry.size.width * 1.0/4.0) // TODO: Put into Modifier
                    }
                }
                .buttonStyle(self.skin.getStoreConsumableModifier(
                    geometryProxy: self.geometryProxy,
                    isDisabled: false,
                    id: self.consumableProduct.product.productIdentifier))
            }
        }
    }
    
    private struct NonConsumableProductRow<S>: View where S: Skin {
        var skin: S
        var geometryProxy: GeometryProxy
        var nonConsumable: GFNonConsumable
        
        var body: some View {
            Button(action: {
                GameFrame.inApp.buy(product: self.nonConsumable.product!, quantity: 1)
            }) {
                HStack {
                    VStack {
                        Text("\(nonConsumable.product!.localizedTitle)")
                            .modifier(skin.getStoreNonConsumableTitleModifier(geometryProxy: self.geometryProxy))
                        Text("\(nonConsumable.product!.localizedDescription)")
                            .modifier(skin.getStoreNonConsumableDescriptionModifier(geometryProxy: self.geometryProxy))
                    }
                    Spacer()
                    Text("\(nonConsumable.product!.localizedPrice(quantity: 1))")
                        .modifier(skin.getStoreNonConsumablePriceModifier(geometryProxy: self.geometryProxy))
                    Image(systemName: "cart")
                        .modifier(skin.getStoreNonConsumableCartModifier(geometryProxy: self.geometryProxy))
                }
            }
            .disabled(nonConsumable.isOpened)
            .buttonStyle(skin.getStoreNonConsumableModifier(
                geometryProxy: self.geometryProxy,
                isDisabled: nonConsumable.isOpened,
                id: self.nonConsumable.product!.productIdentifier))
        }
    }

    var body: some View {
        let consumables = GameFrame.inApp.getConsumables(ids: consumableIds)
        let nonConsumables = GameFrame.inApp.getNonConsumables(ids: nonConsumableIds)

        return VStack {
            Group {
                Spacer()
                if consumables.isEmpty && nonConsumables.isEmpty {
                    Text("No products available or store not available")
                        .modifier(skin.getStoreEmptyModifier(geometryProxy: self.geometryProxy))
                } else {
                    List {
                        Section() {
                            ForEach(consumables) {
                                ConsumableProductRow<S>(
                                    skin: self.skin,
                                    geometryProxy: self.geometryProxy,
                                    consumableProduct: $0)
                            }
                        }
                        .modifier(skin.getStoreConsumblesModifier(geometryProxy: self.geometryProxy))
                        Section() {
                            ForEach(0..<nonConsumables.count, id: \.self) {
                                NonConsumableProductRow<S>(
                                    skin: self.skin,
                                    geometryProxy: self.geometryProxy,
                                    nonConsumable: nonConsumables[$0])
                            }
                        }
                        .modifier(skin.getStoreNonConsumblesModifier(geometryProxy: self.geometryProxy))
                    }
                }
                Spacer()
            }
            // TODO: Put in some Game Configuration
            NavigationArea<S>(skin: skin, geometryProxy: geometryProxy, parent: "Store",
                navigatables: [
                (action: {GameFrame.inApp.restore()},
                 image: Image(systemName: "arrow.uturn.right"),
                 disabled: nil),
                (action: {self.presentationMode.wrappedValue.dismiss()},
                 image: Image(systemName: "xmark"),
                 disabled: nil)])
            .modifier(skin.getStoreNavigationModifier(geometryProxy: self.geometryProxy))
        }
        .modifier(skin.getStoreModifier(
            geometryProxy: self.geometryProxy,
            isOverlayed: inApp.purchasing || inApp.error != nil))
        .overlay(WaitWithErrorOverlay(skin: skin, geometryProxy: geometryProxy))
    }
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {
            StoreView(skin: SkinImpl(), geometryProxy: $0, consumableIds: ["Bullets"], nonConsumableIds: ["weaponB", "weaponC"])
        }
    }
}

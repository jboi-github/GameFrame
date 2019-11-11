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

struct StoreView: View {
    var consumableIds: [String]
    var nonConsumableIds: [String]
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var inApp = GameFrame.inApp
    
    private struct ConsumableProductRow: View {
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
                            Text("\(self.consumableProduct.product.localizedDescription)")
                        }
                        Spacer()
                        Stepper(value: self.$quantity, in: 1...99) {
                            Text("\(self.quantity)")
                        }
                        .frame(width: geometry.size.width * 1.0/3.0)
                        VStack {
                            Image(systemName: "cart")
                            Text("\(self.consumableProduct.product.localizedPrice(quantity: self.quantity))")
                        }
                        .frame(width: geometry.size.width * 1.0/4.0)
                    }
                }
                .padding()
            }
        }
    }
    
    private struct NonConsumableProductRow: View {
        var nonConsumable: GFNonConsumable
        
        var body: some View {
            Button(action: {
                GameFrame.inApp.buy(product: self.nonConsumable.product!, quantity: 1)
            }) {
                HStack {
                    VStack {
                        Text("\(nonConsumable.product!.localizedTitle)")
                        Text("\(nonConsumable.product!.localizedDescription)")
                    }
                    Spacer()
                    Text("\(nonConsumable.product!.localizedPrice(quantity: 1))")
                    Image(systemName: "cart")
                }
            }
            .disabled(nonConsumable.isOpened)
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
                } else {
                    List {
                        Section() {
                            ForEach(consumables) {
                                ConsumableProductRow(consumableProduct: $0)
                            }
                        }
                        Section() {
                             ForEach(nonConsumables) {
                                NonConsumableProductRow(nonConsumable: $0)
                            }
                        }
                    }
                }
                Spacer()
            }
            NavigationArea(navigatables: [
                (action: {GameFrame.inApp.restore()},
                 image: Image(systemName: "arrow.uturn.right"),
                 disabled: nil),
                (action: {self.presentationMode.wrappedValue.dismiss()},
                 image: Image(systemName: "xmark"),
                 disabled: nil)])
        }
        .overlay(WaitWithErrorOverlay())
        .modifier(NavigatableViewModifier())
    }
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView(consumableIds: ["Bullets"], nonConsumableIds: ["weaponB", "weaponC"])
    }
}

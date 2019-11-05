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
    @ObservedObject var sheets = activeSheet
    private var consumables = GameFrame.inApp.getConsumables(ids: ["Lives", "Bullets"])
    private var nonConsumables = GameFrame.inApp.getNonConsumables(ids: ["weaponB", "weaponC"])
    
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
        VStack {
            if consumables.isEmpty && nonConsumables.isEmpty {
                Spacer()
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
            HStack {
                Spacer()
                Button(action: {
                    GameFrame.inApp.restore()
                }) {
                    Image(systemName: "arrow.uturn.right")
                }
                .accessibility(label: Text("Restore"))
                Spacer()
                Button(action: {
                    self.sheets.back()
                }) {
                    Image(systemName: "xmark")
                }
                Spacer()
            }
        }
    }
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView()
    }
}

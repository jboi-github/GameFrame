//
//  StoreViewModifier.swift
//  TheGame
//
//  Created by Juergen Boiselle on 07.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

/// Handle waiting and errors occuring while in the buying process
struct StoreViewModifier: ViewModifier {
    @ObservedObject private var inApp = GameFrame.inApp

    func body(content: Content) -> some View {
        content
            .overlay(VStack{
                if self.inApp.purchasing {
                    WaitView()
                } else {
                    EmptyView()
                }
            })
            .overlay(VStack{
                if self.inApp.error != nil {
                    ErrorView(error: self.inApp.error!)
                } else {
                    EmptyView()
                }
            })
    }
}

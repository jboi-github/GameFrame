//
//  WaitWithErrorOverlay.swift
//  TheGame
//
//  Created by Juergen Boiselle on 09.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

/**
 Show Activity-Spinner while waiting and Error-Popup, when error occured.
 */
struct WaitWithErrorOverlay<S>: View where S: Skin {
    var skin: S
    var geometryProxy: GeometryProxy
    var completionHandler: (() -> Void)? = nil
    @ObservedObject private var inApp = GameFrame.inApp
    
    private struct WaitOverlay<S>: View where S: Skin {
        var skin: S
        var geometryProxy: GeometryProxy
        var completionHandler: (() -> Void)?
        
        @State private var spin = false
        @ObservedObject private var inApp = GameFrame.inApp
        
        var body: some View {
            Image(systemName: "arrow.2.circlepath")
                .modifier(skin.getWaitModifier(geometryProxy: self.geometryProxy))
                .rotationEffect(.degrees(spin ? 360 : 0)) // TODO: Make Standard View and move to Modifier
                .animation(Animation.linear(duration: 1.0).repeatForever(autoreverses: true))
                .onAppear() {self.spin.set()}
                .onDisappear(perform: {
                    log(self.inApp.purchasing, self.inApp.error)
                    if self.inApp.error == nil {self.completionHandler?()}
                })
        }
    }

    private struct ErrorOverlay<S>: View where S: Skin {
        var skin: S
        var geometryProxy: GeometryProxy
        var completionHandler: (() -> Void)?
        @State private var inApp = GameFrame.inApp
        
        var body: some View {
            VStack {
                Text("\(inApp.error?.localizedDescription ?? "OK")")
                    .modifier(skin.getErrorMessageModifier(geometryProxy: self.geometryProxy))
                Button(action: {
                    defer {
                        log(self.completionHandler)
                        self.completionHandler?()
                    }
                    self.inApp.clearError()
                }) {
                    Image(systemName: "xmark")
                }
                .buttonStyle(skin.getErrorButtonModifier(geometryProxy: self.geometryProxy, isDisabled: false))
            }
        }
    }

    var body: some View {
        VStack {
            if inApp.error != nil {
                ErrorOverlay(skin: skin, geometryProxy: geometryProxy, completionHandler: completionHandler)
            } else if inApp.purchasing {
                WaitOverlay(skin: skin, geometryProxy: geometryProxy, completionHandler: completionHandler)
            }
        }
        .modifier(skin.getWaitWithErrorModifier(geometryProxy: self.geometryProxy))
    }
}

struct WaitWithErrorOverlay_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {
            WaitWithErrorOverlay(skin: SkinImpl(), geometryProxy: $0)
        }
    }
}

//
//  WaitWithErrorOverlay.swift
//  TheGame
//
//  Created by Juergen Boiselle on 09.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import UIKit
import GameFrameKit

/**
 Show Activity-Spinner while waiting and Error-Popup, when error occured.
 */
struct WaitWithErrorOverlay<S>: View where S: Skin {
    var skin: S
    var geometryProxy: GeometryProxy
    var completionHandler: (() -> Void)? = nil
    @ObservedObject private var inApp = GameFrame.inApp
    
    /// Copied from stackoverflow.com: https://stackoverflow.com/questions/56496638/activity-indicator-in-swiftui
    private struct ActivityIndicator: UIViewRepresentable {
        var isAnimating: Bool
        let style: UIActivityIndicatorView.Style

        func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
            return UIActivityIndicatorView(style: style)
        }

        func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
            isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        }
    }
    
    private struct WaitOverlay<S>: View where S: Skin {
        var skin: S
        var geometryProxy: GeometryProxy
        var completionHandler: (() -> Void)?
        
        @State private var spin = false
        @ObservedObject private var inApp = GameFrame.inApp
        
        var body: some View {
            ActivityIndicator(isAnimating: inApp.purchasing, style: .large)
                .modifier(skin.getWaitModifier(geometryProxy: self.geometryProxy))
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
            WaitWithErrorOverlay(skin: PreviewSkin(), geometryProxy: $0)
        }
    }
}

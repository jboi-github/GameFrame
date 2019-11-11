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
struct WaitWithErrorOverlay: View {
    var completionHandler: (() -> Void)? = nil
    @ObservedObject private var inApp = GameFrame.inApp
    
    private struct WaitOverlay: View {
        var completionHandler: (() -> Void)?
        
        @State private var spin = false
        @ObservedObject private var inApp = GameFrame.inApp
        
        var body: some View {
            Image(systemName: "arrow.2.circlepath")
                .rotationEffect(.degrees(spin ? 360 : 0))
                .animation(Animation.linear(duration: 1.0).repeatForever(autoreverses: true))
                .onAppear() {self.spin.set()}
                .onDisappear(perform: {
                    log(self.inApp.purchasing, self.inApp.error)
                    if self.inApp.error == nil {self.completionHandler?()}
                })
        }
    }

    private struct ErrorOverlay: View {
        var completionHandler: (() -> Void)?
        @State private var inApp = GameFrame.inApp
        
        var body: some View {
            VStack {
                Text("\(inApp.error?.localizedDescription ?? "OK")")
                Button(action: {
                    defer {
                        log(self.completionHandler)
                        self.completionHandler?()
                    }
                    self.inApp.clearError()
                }) {
                    Image(systemName: "xmark")
                }
            }
        }
    }

    var body: some View {
        VStack {
            if inApp.error != nil {
                ErrorOverlay(completionHandler: completionHandler)
            } else if inApp.purchasing {
                WaitOverlay(completionHandler: completionHandler)
            }
        }
    }
}

struct WaitWithErrorOverlay_Previews: PreviewProvider {
    static var previews: some View {
        WaitWithErrorOverlay()
    }
}

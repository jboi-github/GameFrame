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
struct WaitWithErrorOverlay<S>: View where S: GameSkin {
    var completionHandler: (() -> Void)? = nil
    @ObservedObject private var inApp = GameFrame.inApp
    @EnvironmentObject private var skin: S
    
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

    var body: some View {
        VStack {
            if inApp.error != nil {
                Text("\(inApp.error?.localizedDescription ?? "OK")")
                    .modifier(skin.getErrorMessageModifier())
                NavigationArea<S>(parent: "Error", items: [[.ErrorBackLink()]])
            } else if inApp.purchasing {
                ActivityIndicator(isAnimating: inApp.purchasing, style: .large)
                    .modifier(skin.getWaitModifier())
            }
        }
        .modifier(skin.getWaitWithErrorModifier())
        .onDisappear(perform: {
            log(self.inApp.purchasing, self.inApp.error)
            if self.inApp.error == nil {self.completionHandler?()}
        })
    }
}

struct WaitWithErrorOverlay_Previews: PreviewProvider {
    static var previews: some View {
        WaitWithErrorOverlay<PreviewSkin>()
        .environmentObject(PreviewSkin())
    }
}

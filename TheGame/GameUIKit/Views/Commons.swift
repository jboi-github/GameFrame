//
//  Commons.swift
//  GameUIKit
//
//  Created by Juergen Boiselle on 20.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

/// Copied from stackoverflow.com: https://stackoverflow.com/questions/56496638/activity-indicator-in-swiftui
struct ActivityIndicator: UIViewRepresentable {
    let isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

/// Copied from stackoverflow.com: https://stackoverflow.com/questions/56610957/is-there-a-method-to-blur-a-background-in-swiftui
struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: style)
        
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<BlurView>) {}
}

struct ErrorAlert<C, S>: View  where C: GameConfig, S: Skin {
    @EnvironmentObject private var skin: S
    
    var body: some View {
        VStack {
            Text("\(GameFrame.inApp.error?.localizedDescription ?? "OK")")
                .build(skin, .ErrorMessage)
            NavigationLayer<C, S>(parent: "Error", items: [[.Buttons(.ErrorBack())]])
        }
        .build(skin, .Commons(.Error))
    }
}

struct WaitAlert<S>: View  where S: Skin {
    @EnvironmentObject private var skin: S
    
    var body: some View {
        ActivityIndicator(isAnimating: true, style: .large)
            .build(skin, .Commons(.Wait))
    }
}

extension View {
    func debug(_ msg: Any?...) -> some View {
        log(msg)
        return self
    }
    
    func getFrame(_ frame: Binding<CGRect>) -> some View {
        self
        .background(
            GeometryReader {
                proxy -> AnyView in
                
                DispatchQueue.main.async {frame.wrappedValue = proxy.frame(in: .global)}
                return AnyView(EmptyView())
            }
        )
    }
}

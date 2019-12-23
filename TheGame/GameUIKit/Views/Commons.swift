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
    @State private var error: Error? = nil
    @EnvironmentObject private var skin: S
    
    var body: some View {
        VStack {
            Text("\(error?.localizedDescription ?? "unknown error")")
                .build(skin, .ErrorMessage)
            NavigationLayer<C, S>(
                parent: "Error",
                items: [[.Buttons(.ErrorBack())]])
        }
        .build(skin, .Commons(.Error))
        .onReceive(GameFrame.inApp.$error) {
            if self.error == nil {self.error = $0}
        }
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
    
    func storeFrame(_ key: String) -> some View {
        return self
        .background(
            GeometryReader {
                proxy -> AnyView in
                
                GameUI.instance.storeFrame(key, frame: proxy.frame(in: .global))
                return EmptyView().anyView()
            }
        )
    }
    
    func getFrame(_ key: String, frame: Binding<CGRect>) -> some View {
        self
        .onReceive(GameUI.instance.$storedFramesChanged.filter {
            key == $0
        }) {
            if let _frame = GameUI.instance.storedFrames[$0] {
                frame.wrappedValue = _frame
            }
        }
    }
}

public extension CGRect {
    var mid: CGPoint {CGPoint(x: midX, y: midY)}
}

/**
 A View that shows decimal numbers. When changed, the digits rotate depending on a given animation.
 */
public struct Number: View {
    let animation: Animation
    private let characters: [Character]
    private let frameId: String
    private static let digits: [Character] = [" ", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    @State private var frame: CGRect = .zero
    
    init(parent: String, id: String, text: String, animation: Animation = .spring()) {
        self.animation = animation
        self.characters = text.map {$0 as Character}
        self.frameId = "Number - \(parent) - \(id)"
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(0..<characters.count, id: \.self) {id in
                Group {
                    if self.getDigit(self.characters[id]) != nil {
                        DigitView(digit: self.getDigit(self.characters[id])!, height: self.frame.size.height / 11.0)
                    } else {
                        Text(String(self.characters[id]))
                    }
                }
            }
        }
        .animation(animation)
        .storeFrame(frameId)
        .getFrame(frameId, frame: $frame)
        .clipShape(Rectangle().path(in: CGRect(
            origin: .zero,
            size: CGSize(width: frame.size.width, height: frame.size.height / 11.0))))
        .frame(width: nil, height: frame.size.height / 11.0, alignment: .top)
    }
    
    private struct DigitView: View {
        let digit: Int
        let height: CGFloat
        
        var body: some View {
            VStack {
                ForEach(-1..<10, id: \.self) {
                    Text($0 < 0 ? " " : "\($0)")
                }
            }
            .offset(x: 0, y: -height * CGFloat(digit+1))
        }
    }
    
    private func getDigit(_ c: Character) -> Int? {
        if let idx = Number.digits.firstIndex(where: {$0 == c}) {
            return idx-1
        } else {
            return nil
        }
    }
}

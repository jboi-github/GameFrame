//
//  SkinImpl.swift
//  GameUIKit
//
//  Created by Juergen Boiselle on 06.12.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

// MARK: Simple skin implementation Definition
/**
 The simple skin follows these rules:
 - Text:
    - All text has primary color and the default font (When I find a way to change the font app wide, I will do so)
    - Is always defined as multiline, with unlimited number of lines
    - Title and description in store and offer are aligned to leading. All other text is centered
    - Title and description in store and offer have font headline and subheadline. All other fonts are body
 - Buttons:
    - All buttons have accent color and secondary color when disabled
    - Images have standard size
    - Play button is centered and fills the available display up to 75% with aspect ratio 1:1
    - When pressed, background is grayed and gets a shadow with the impression of laying deeper
 - Views:
    - Backgrounds are default
    - Navigation is set to inline. InLevel hides the back button
    - When overlayed, views are blurred
 - Overlays:
    - Backgroud is blurred with UltraThinMaterialDark, rounded edges as padded from the screen edges
    - Content within Overlay is extra padded
*/
open class SimpleSkin: IdentitySkin {
    private let primaryColor: UIColor
    private let secondaryColor: UIColor
    private let accentColor: UIColor
    private let primaryInvertColor: UIColor
    private let secondaryInvertColor: UIColor
    private let accentInvertColor: UIColor
    
    private let buttonShadowRadius: CGFloat
    private let buttonShadowOffset: CGFloat
    private let playButtonScale: CGFloat

    private let overlayedBlurRadius: CGFloat
    private let overlayingInnerPadding: CGFloat
    private let overlayingOuterPadding: CGFloat
    private let overlayingCornerRadius: CGFloat
    
    private let smooth: Animation
    private let spring: Animation
    
    private let soundGrandOpening: String
    
    private let turnAudioOnOff: String
    
    private var prevView = -1

    public init(
        primaryColor: UIColor = UIColor.white,
        secondaryColor: UIColor = UIColor.gray,
        accentColor: UIColor = UIColor.blue,
        primaryInvertColor: UIColor = UIColor.black,
        secondaryInvertColor: UIColor = UIColor.lightGray,
        accentInvertColor: UIColor = UIColor.yellow,
        
        buttonShadowRadius: CGFloat = 5.0,
        buttonShadowOffset: CGFloat = 2.0,
        playButtonScale: CGFloat = 0.75,

        overlayedBlurRadius: CGFloat = 5.0,
        overlayingInnerPadding: CGFloat = 16,
        overlayingOuterPadding: CGFloat = 32,
        overlayingCornerRadius: CGFloat = 32,
        soundGrandOpening: String = "GrandOpening",
        turnAudioOnOff: String = "turnAudioOnOff".localized
    ) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.accentColor = accentColor
        self.primaryInvertColor = primaryInvertColor
        self.secondaryInvertColor = secondaryInvertColor
        self.accentInvertColor = accentInvertColor
        self.buttonShadowRadius = buttonShadowRadius
        self.buttonShadowOffset = buttonShadowOffset
        self.playButtonScale = playButtonScale
        self.overlayedBlurRadius = overlayedBlurRadius
        self.overlayingInnerPadding = overlayingInnerPadding
        self.overlayingOuterPadding = overlayingOuterPadding
        self.overlayingCornerRadius = overlayingCornerRadius
        
        self.smooth = Animation.easeInOut
        self.spring = Animation.spring()
        
        self.soundGrandOpening = soundGrandOpening
        
        self.turnAudioOnOff = turnAudioOnOff
        
        super.init()
    }
    
    override open func build(_ item: SkinItem.SkinItemText, text: Text) -> AnyView {
        switch item {
        case .StoreProductTitle, .OfferProductTitle:
            return standardText(text, font: .headline, align: .leading).anyView()
        case .StoreProductDescription, .OfferProductDescription:
            return standardText(text, font: .subheadline, align: .leading).anyView()
        case let .NavigationBarTitle(parent: parent):
            return standardText(text, font: parent == "OffLevel" ? .largeTitle : .title).anyView()
        case .ErrorMessage:
            return standardText(text).foregroundColor(Color(primaryColor)).anyView()
        default:
            return standardText(text).anyView()
        }
    }
    
    override open func build<V>(_ item: SkinItem.SkinItemButton, label: V, isPressed: Bool = false) -> AnyView where V: View {
        switch item {
        case let .StoreProductButton(id: _, isDisabled: isDisabled):
            return defaultButton(label, isDisabled: isDisabled, isPressed: isPressed).anyView()
        case let .StoreProductStepper(id: _, isDisabled: isDisabled):
            return defaultButton(label, isDisabled: isDisabled, isPressed: isPressed).anyView()
        case let .OfferProduct(id: _, isDisabled: isDisabled):
            return defaultButton(label, isDisabled: isDisabled, isPressed: isPressed).anyView()
        case let .NavigationItem(parent: _, isDisabled: isDisabled, item: navigation):
            if isPlayButton(navigation) {
                return playButton(isDisabled: isDisabled, isPressed: isPressed).anyView()
            } else {
                return defaultButton(label, isDisabled: isDisabled, isPressed: isPressed).anyView()
            }
        }
    }
    
    override open func build<V>(_ item: SkinItem.SkinItemToggle, label: V, isOn: Binding<Bool>) -> AnyView where V: View {
        HStack {
            Text(turnAudioOnOff)
            Spacer()
            Button(action: {
                isOn.wrappedValue.toggle()
            }) {
                Image(systemName: isOn.wrappedValue ? "speaker.3" : "speaker.slash")
            }
        }
        .simpleSkinDefaultToggle(
            accentColor: Color(accentColor), secondaryColor: Color(secondaryColor),
            buttonShadowRadius: buttonShadowRadius, buttonShadowOffset: buttonShadowOffset)
        .anyView()
    }
    
    override open func build<V>(_ item: SkinItem.SkinItemView, view: V) -> AnyView where V: View {
        switch item {
        case let .Main(mainItem):
            switch mainItem {
            case let .Main(current: current):
                defer {prevView = current}
                return view
                .simpleSkinSmoothAppAppear(
                    smooth, primary: Color(primaryColor), primaryInvert: Color(primaryInvertColor),
                    preAppStart: current == -1, postAppStart: prevView == -1 && current != -1)
                .play(current == -1 ? soundGrandOpening : nil)
                .anyView()
            default:
                return view.anyView()
            }
        case let .OffLevel(offLevelItem):
            switch offLevelItem {
            case .Main:
                return view.simpleSkinSmoothAppear(smooth).anyView()
            }
        case let .InLevel(inLevelItem):
            switch inLevelItem {
            case .Main:
                return view
                    .simpleSkinSmoothAppear(smooth)
                    .anyView()
            case let .Game(isOverlayed: isOverlayed):
                return view
                    .simpleSkinOverlayed(isOverlayed, blurRadius: overlayedBlurRadius, animation: smooth)
                    .anyView()
            default:
                return view.anyView()
            }
        case let .Settings(settingsItem):
            switch settingsItem {
            case .Main:
                return view.simpleSkinSmoothAppear(smooth)
                    .padding(.horizontal)
                    .anyView()
            default:
                return view.anyView()
            }
        case let .Store(storeItem):
            switch storeItem {
            case .Main:
                return view.simpleSkinSmoothAppear(smooth).anyView()
            case let .Products(isOverlayed: isOverlayed):
                return view.simpleSkinOverlayed(isOverlayed, blurRadius: overlayedBlurRadius, animation: smooth)
                    .padding(.horizontal)
                    .anyView()
            default:
                return view.anyView()
            }
        case let .Offer(offerItem):
            switch offerItem {
            case .Main:
                return overlaying(view).anyView()
            case let .Products(isOverlayed: isOverlayed):
                return view
                    .simpleSkinOverlayed(isOverlayed, blurRadius: overlayedBlurRadius, animation: smooth)
                    .anyView()
            }
        case let .Commons(commonsItem):
            switch commonsItem {
            case .Error:
                return overlaying(view).anyView()
            case .Wait:
                return overlaying(view).scaledToFit().scaleEffect(0.5).anyView()
            case let .NavigationBar(parent: parent):
                return view.simpleSkinHide(parent == "InLevel").anyView()
            case let .NavigationLayer(parent: parent):
                return view.simpleSkinHide(parent == "Store")
                    .simpleSkinPosition(parent == "InLevel" ? .top : nil)
                    .anyView()
            case let .Information(parent: parent):
                return view.simpleSkinPosition(parent == "InLevel" ? .topTrailing : .bottom).anyView()
            case .InformationItem:
                return view.simpleSkinNumber(
                    font: .system(.body, design: .monospaced),
                    primary: Color(primaryColor))
                    .padding()
                    .anyView()
            default:
                return view.anyView()
            }
        }
    }
    
    /**
    - Title and description in store and offer are aligned to leading. All other text is centered
    - Title and description in store and offer have font headline and subheadline. All other fonts are body
    - All text has primary color and the default font (When I find a way to change the font app wide, I will do so)
    - Is always defined as multiline, with unlimited number of lines
    - Navigation is set to inline.
    */
    private func standardText(_ text: Text, font: Font = .body, align: TextAlignment = .center) -> some View {
        text.simpleSkinStandard(font: font, align: align, primary: Color(primaryColor))
    }

    /**
    - All buttons have accent color and secondary color when disabled
    - Images have standard size
    - When pressed, a shodow gives the impression, that background is lowered
    */
    private func defaultButton<V>(_ label: V, isDisabled: Bool, isPressed: Bool) -> some View where V: View {
        label.simpleSkinDefaultButton(
            isDisabled: isDisabled, isPressed: isPressed,
            accentColor: Color(accentColor), secondaryColor: Color(secondaryColor),
            buttonShadowRadius: buttonShadowRadius, buttonShadowOffset: buttonShadowOffset)
    }
    
    /**
    - Play button is centered and fills the available space up to 75% with aspect ratio 1:1
    */
    private func playButton(isDisabled: Bool, isPressed: Bool) -> some View {
        Image(systemName: "play.circle").simpleSkinPlayButton(
            isDisabled: isDisabled, isPressed: isPressed,
            playButtonScale: playButtonScale,
            accentColor: Color(accentColor), secondaryColor: Color(secondaryColor),
            buttonShadowRadius: buttonShadowRadius * 5.0,
            buttonShadowOffset: buttonShadowOffset * 5.0)
    }
    
    private func isPlayButton(_ item: Navigation) -> Bool {
        switch item {
        case let .Links(link: link):
            switch link {
            case .Play:
                return true
            default:
                return false
            }
        default:
            return false
        }
    }

    /**
     - Backgroud is blurred with UltraThinMaterialDark, rounded edges as padded from the screen edges
     - Content within Overlay is extra padded
     */
    private func overlaying<V>(_ view: V) -> some View where V: View {
        view.simpleSkinOverlaying(
            innerPadding: overlayingInnerPadding,
            outerPadding: overlayingOuterPadding,
            cornerRadius: overlayingCornerRadius,
            animation: smooth)
    }
}

enum ScaledCircleRadius {
    case Min, Max, Full
}

/// Create circle with radius just over all edges
struct ScaledCircle: Shape {
    let scaleOfOne: ScaledCircleRadius
    
    func path(in rect: CGRect) -> Path {
        let side = getSide(width: rect.width, height: rect.height, scaleOfOne: scaleOfOne)
        let square = CGRect(
            origin: CGPoint(x: rect.midX - side / 2.0, y: rect.midY - side / 2.0),
            size: CGSize(width: side, height: side))
        return Circle().path(in: square)
    }
    
    private func getSide(width: CGFloat, height: CGFloat, scaleOfOne: ScaledCircleRadius) -> CGFloat {
        switch scaleOfOne {
        case .Min:
            return min(width, height)
        case .Max:
            return max(width, height)
        case .Full:
            let s1 = min(width, height)
            let s2 = max(width, height)
            return sqrt(s1*s1 + s2*s2)
        }
    }
}

// MARK: Extend view with helper functions for skins
public extension View {
    func anyView() -> AnyView {
        return AnyView(self)
    }
    
    func simpleSkinDefaultButton(
        isDisabled: Bool, isPressed: Bool,
        accentColor: Color, secondaryColor: Color,
        buttonShadowRadius: CGFloat, buttonShadowOffset: CGFloat) -> some View
    {
        self.padding()
            .foregroundColor(isDisabled ? secondaryColor : accentColor)
            .shadow(
                color: secondaryColor,
                radius: buttonShadowRadius,
                x: isPressed ? -buttonShadowOffset : buttonShadowOffset,
                y: isPressed ? -buttonShadowOffset : buttonShadowOffset)
    }
    
    func simpleSkinDefaultToggle(
        accentColor: Color, secondaryColor: Color,
        buttonShadowRadius: CGFloat, buttonShadowOffset: CGFloat) -> some View
    {
        self.padding()
            .foregroundColor(accentColor)
            .shadow(
                color: secondaryColor, radius: buttonShadowRadius,
                x: buttonShadowOffset, y: buttonShadowOffset)
    }
    
    func simpleSkinHide(_ hidden: Bool) -> some View {
        Group {if !hidden {self}}
    }
    
    func simpleSkinPosition(_ position: UnitPoint?) -> some View {
        Group {
            if position == nil {
                self
            } else  {
                VStack {
                    if ![.top, .topLeading, .topTrailing].contains(position!) {Spacer()}
                    HStack {
                        if ![.topLeading, .leading , .bottomLeading].contains(position!) {Spacer()}
                        self
                        if ![.topTrailing, .trailing , .bottomTrailing].contains(position!) {Spacer()}
                    }
                    if ![.bottom, .bottomLeading, .bottomTrailing].contains(position!) {Spacer()}
                }
            }
        }
    }
    
    func simpleSkinOverlayed(_ isOverlayed: Bool, blurRadius: CGFloat, animation: Animation) -> some View {
        self.blur(radius: isOverlayed ? blurRadius : 0.0)
            .animation(animation, value: isOverlayed)
    }
    
    func simpleSkinOverlaying(
        innerPadding: CGFloat,
        outerPadding: CGFloat,
        cornerRadius: CGFloat,
        animation: Animation)
        -> some View
    {
        var offset: CGPoint = .zero
        if let triggerPoint = GameUI.instance.triggerPoint,
            let mainMid = GameUI.instance.storedFrames[mainFrameId]?.mid
        {
            offset = CGPoint(x: triggerPoint.x - mainMid.x, y: triggerPoint.y - mainMid.y)
        }
        return self
            .padding(innerPadding)
            .background(
                BlurView(style: .systemUltraThinMaterialLight)
                .cornerRadius(cornerRadius, antialiased: true)
            )
            .padding(outerPadding)
            .transition(AnyTransition.scale.combined(with: AnyTransition.offset(x: offset.x, y: offset.y)))
    }
    
    func simpleSkinSmoothAppAppear(
        _ animation: Animation, primary: Color, primaryInvert: Color,
        preAppStart: Bool, postAppStart: Bool)
        -> some View
    {
        ZStack {
            Rectangle()
                .opacity(preAppStart ? 0.0 : 1.0)
                .animation(postAppStart ? animation : nil, value: preAppStart)
                .foregroundColor(primaryInvert)
                .edgesIgnoringSafeArea(.all)
            
            self
                .background(primaryInvert)
                .clipShape(ScaledShape(
                    shape: ScaledCircle(scaleOfOne: .Full),
                    scale: preAppStart ? .zero : .init(width: 1, height: 1)))
                .animation(postAppStart ? animation : nil, value: preAppStart)
                .foregroundColor(primary)
        }
    }
    
    func simpleSkinSmoothAppear(_ animation: Animation) -> some View {
        self.transition(AnyTransition.opacity.animation(animation))
    }
    
    func simpleSkinNumber(font: Font = .body, primary: Color) -> some View {
        self
            .foregroundColor(primary)
            .lineLimit(1)
            .font(font)
    }
}

public extension Image {
    func simpleSkinPlayButton(
        isDisabled: Bool, isPressed: Bool,
        playButtonScale: CGFloat,
        accentColor: Color, secondaryColor: Color,
        buttonShadowRadius: CGFloat, buttonShadowOffset: CGFloat) -> some View
    {
        VStack {
            Spacer()
            HStack {
                Spacer()
                self.resizable().scaledToFit().scaleEffect(playButtonScale)
                    .simpleSkinDefaultButton(
                        isDisabled: isDisabled, isPressed: isPressed,
                        accentColor: accentColor, secondaryColor: secondaryColor,
                        buttonShadowRadius: buttonShadowRadius,
                        buttonShadowOffset: buttonShadowOffset)
                Spacer()
            }
            Spacer()
        }
    }
}

public extension Text {
    func simpleSkinStandard(font: Font = .body, align: TextAlignment = .center, primary: Color) -> some View {
        let view = self
            .foregroundColor(primary)
            .lineLimit(nil)
            .font(font)
            .multilineTextAlignment(align)
        
        return Group {
            if align == .leading {
                HStack {view; Spacer()}
            } else {
                view
            }
        }
    }
}
